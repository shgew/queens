import Foundation
import Logging
import OSLog
import SwiftData

private let logger = Logger.queens(category: .storage)

@Model
final class BestTimeRecord {
  var size: Int
  var time: TimeInterval
  var recordedAt: Date

  init(size: Int, time: TimeInterval, recordedAt: Date = .now) {
    self.size = size
    self.time = time
    self.recordedAt = recordedAt
  }
}

actor BestTimesStore: BestTimesStoring {
  private let container: ModelContainer
  private static let maxRecordsPerSize = 10

  init(container: ModelContainer) {
    self.container = container
  }
}

extension BestTimesStore {
  func bestTime(forSize size: Int) async -> TimeInterval? {
    let context = ModelContext(container)
    return fetchTopRecords(forSize: size, context: context, limit: 1).first?.time
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool {
    let context = ModelContext(container)
    let topRecords = fetchTopRecords(
      forSize: size,
      context: context,
      limit: Self.maxRecordsPerSize
    )
    let isNewBest = topRecords.first.map { time < $0.time } ?? true

    if topRecords.count == Self.maxRecordsPerSize,
      let slowest = topRecords.last,
      time >= slowest.time
    {
      return false
    }

    context.insert(BestTimeRecord(size: size, time: time))
    trimOverflowRecords(forSize: size, context: context)

    do {
      try context.save()
    } catch {
      logger.error("Failed to save top times for size \(size): \(error)")
      return false
    }

    return isNewBest
  }
}

extension BestTimesStore {
  static var live: BestTimesStore {
    do {
      let container = try ModelContainer(for: BestTimeRecord.self)
      return BestTimesStore(container: container)
    } catch {
      logger.error("Failed to create SwiftData container, falling back to in-memory: \(error)")
      return preview
    }
  }

  static var preview: BestTimesStore {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: BestTimeRecord.self, configurations: configuration)
      return BestTimesStore(container: container)
    } catch {
      fatalError("Failed to create in-memory SwiftData container: \(error)")
    }
  }
}

extension BestTimesStore {
  private func fetchTopRecords(
    forSize size: Int,
    context: ModelContext,
    limit: Int? = nil
  ) -> [BestTimeRecord] {
    let descriptor = FetchDescriptor<BestTimeRecord>(
      predicate: #Predicate { record in
        record.size == size
      }
    )

    do {
      let sorted = try context.fetch(descriptor).sorted {
        if $0.time == $1.time {
          return $0.recordedAt < $1.recordedAt
        }
        return $0.time < $1.time
      }
      if let limit {
        return Array(sorted.prefix(limit))
      }
      return sorted
    } catch {
      logger.error("Failed to fetch top times for size \(size): \(error)")
      return []
    }
  }

  private func trimOverflowRecords(forSize size: Int, context: ModelContext) {
    let allRecords = fetchTopRecords(forSize: size, context: context)
    guard allRecords.count > Self.maxRecordsPerSize else { return }

    for record in allRecords.dropFirst(Self.maxRecordsPerSize) {
      context.delete(record)
    }
  }
}
