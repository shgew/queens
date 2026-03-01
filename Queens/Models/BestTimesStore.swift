import Foundation
import Logging
import OSLog
import SwiftData

private let logger = Logger.queens(category: .storage)

@ModelActor
actor BestTimesStore: BestTimesStoring {
  private static let maxRecordsPerSize = 10

  init(isStoredInMemoryOnly: Bool) {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
      let container = try ModelContainer(
        for: BestTimeRecord.self,
        configurations: configuration
      )
      self.init(modelContainer: container)
    } catch {
      fatalError(
        "Failed to create SwiftData container (isStoredInMemoryOnly: \(isStoredInMemoryOnly)): \(error)"
      )
    }
  }

  func bestTime(for boardSize: Int) async -> TimeInterval? {
    fetchTopRecords(for: boardSize, limit: 1).first?.time
  }

  func topTimesByBoardSize() async -> [LeaderboardSection] {
    let records = fetchAllRecordsSorted()
    let grouped = Dictionary(grouping: records, by: \.boardSize)
    return grouped.compactMap { entry in
      guard !entry.value.isEmpty else {
        return nil
      }
      return LeaderboardSection(
        boardSize: entry.key,
        times: entry.value.map(\.time)
      )
    }
    .sorted { lhs, rhs in
      lhs.boardSize < rhs.boardSize
    }
  }

  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) async -> Bool {
    let topRecords = fetchTopRecords(
      for: boardSize,
      limit: Self.maxRecordsPerSize
    )
    let isNewBest =
      if let fastestRecord = topRecords.first {
        time < fastestRecord.time
      } else {
        true
      }

    if topRecords.count == Self.maxRecordsPerSize,
      let slowest = topRecords.last,
      time >= slowest.time
    {
      return false
    }

    modelContext.insert(BestTimeRecord(boardSize: boardSize, time: time))
    trimOverflowRecords(forSize: boardSize)

    do {
      try modelContext.save()
    } catch {
      logger.error("Failed to save top times for board size \(boardSize): \(error)")
      return false
    }

    return isNewBest
  }
}

extension BestTimesStore {
  private func fetchAllRecordsSorted() -> [BestTimeRecord] {
    let descriptor = FetchDescriptor<BestTimeRecord>(
      sortBy: [
        SortDescriptor(\.boardSize, order: .forward),
        SortDescriptor(\.time, order: .forward),
      ]
    )

    do {
      return try modelContext.fetch(descriptor)
    } catch {
      logger.error("Failed to fetch leaderboard records: \(error)")
      return []
    }
  }

  private func fetchTopRecords(
    for boardSize: Int,
    limit: Int? = nil
  ) -> [BestTimeRecord] {
    var descriptor = FetchDescriptor<BestTimeRecord>(
      predicate: #Predicate { record in
        record.boardSize == boardSize
      },
      sortBy: [
        SortDescriptor(\.time, order: .forward)
      ]
    )
    if let limit {
      descriptor.fetchLimit = limit
    }

    do {
      return try modelContext.fetch(descriptor)
    } catch {
      logger.error("Failed to fetch top times for board size \(boardSize): \(error)")
      return []
    }
  }

  private func trimOverflowRecords(forSize boardSize: Int) {
    let allRecords = fetchTopRecords(for: boardSize)
    guard allRecords.count > Self.maxRecordsPerSize else { return }

    for record in allRecords.dropFirst(Self.maxRecordsPerSize) {
      modelContext.delete(record)
    }
  }
}

extension BestTimesStore {
  static let live = BestTimesStore(isStoredInMemoryOnly: false)
}
