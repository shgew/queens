import Foundation
import ResourceStorage

final class BestTimesStore: BestTimesStoring {
  private let storage: any ResourceStorage

  static let resource = Resource(
    id: "best-times",
    defaultValue: [Int: TimeInterval]()
  )

  init(storage: any ResourceStorage) {
    self.storage = storage
  }

  func bestTime(forSize size: Int) async -> TimeInterval? {
    let times = await loadTimes()
    return times[size]
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool {
    var times = await loadTimes()
    if let existing = times[size], existing <= time {
      return false
    }

    times[size] = time
    try? await storage.save(times, for: Self.resource)
    return true
  }

  private func loadTimes() async -> [Int: TimeInterval] {
    do {
      return try await storage.load(Self.resource)
    } catch {
      return Self.resource.defaultValue
    }
  }
}
