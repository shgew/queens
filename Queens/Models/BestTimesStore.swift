import Foundation
import Logging
import OSLog
import SwiftData

private let logger = Logger.queens(category: .storage)

@Model
final class BestTimeRecord {
  var size: Int
  var time: TimeInterval

  init(size: Int, time: TimeInterval) {
    self.size = size
    self.time = time
  }
}

@ModelActor
actor BestTimesStore: BestTimesStoring {
  private static let maxRecordsPerSize = 10
}

extension BestTimesStore {
  func bestTime(forSize size: Int) async -> TimeInterval? {
    fetchTopRecords(forSize: size, limit: 1).first?.time
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool {
    let topRecords = fetchTopRecords(
      forSize: size,
      limit: Self.maxRecordsPerSize
    )
    let isNewBest = topRecords.first.map { time < $0.time } ?? true

    if topRecords.count == Self.maxRecordsPerSize,
      let slowest = topRecords.last,
      time >= slowest.time
    {
      return false
    }

    modelContext.insert(BestTimeRecord(size: size, time: time))
    trimOverflowRecords(forSize: size)

    do {
      try modelContext.save()
    } catch {
      logger.error("Failed to save top times for size \(size): \(error)")
      return false
    }

    return isNewBest
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

extension BestTimesStore {
  private func fetchTopRecords(
    forSize size: Int,
    limit: Int? = nil
  ) -> [BestTimeRecord] {
    var descriptor = FetchDescriptor<BestTimeRecord>(
      predicate: #Predicate { record in
        record.size == size
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
      logger.error("Failed to fetch top times for size \(size): \(error)")
      return []
    }
  }

  private func trimOverflowRecords(forSize size: Int) {
    let allRecords = fetchTopRecords(forSize: size)
    guard allRecords.count > Self.maxRecordsPerSize else { return }

    for record in allRecords.dropFirst(Self.maxRecordsPerSize) {
      modelContext.delete(record)
    }
  }
}
