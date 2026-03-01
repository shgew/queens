import Foundation
import Logging
import OSLog
import SwiftData

private let logger = Logger.queens(category: .storage)

@ModelActor
actor BestTimesStore: BestTimesStoring {
  private static let maxRecordsPerSize = 10

  func bestTime(for boardSize: Int) async -> TimeInterval? {
    fetchTopRecords(for: boardSize, limit: 1).first?.time
  }

  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) async -> Bool {
    let topRecords = fetchTopRecords(
      for: boardSize,
      limit: Self.maxRecordsPerSize
    )
    let isNewBest = if let fastestRecord = topRecords.first {
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
  static var live: BestTimesStore {
    makeStore(inMemory: false)
  }

  static var preview: BestTimesStore {
    makeStore(inMemory: true)
  }

  private static func makeStore(inMemory: Bool) -> BestTimesStore {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: inMemory)
      let container = try ModelContainer(
        for: BestTimeRecord.self,
        configurations: configuration
      )
      return BestTimesStore(modelContainer: container)
    } catch {
      fatalError("Failed to create SwiftData container (inMemory: \(inMemory)): \(error)")
    }
  }
}
