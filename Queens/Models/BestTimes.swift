import Foundation
import ResourceStorage

protocol BestTimesStoring {
  func bestTime(forSize size: Int) async -> TimeInterval?
  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool
}

extension Resource where Value == [Int: TimeInterval] {
  static var bestTimes: Self {
    Resource(id: "best-times", defaultValue: [:])
  }
}

final class BestTimesStore: BestTimesStoring {
  private let storage: any ResourceStorage
  private static let resource = Resource<[Int: TimeInterval]>.bestTimes

  init(storage: any ResourceStorage) {
    self.storage = storage
  }

  func bestTime(forSize size: Int) async -> TimeInterval? {
    let times = (try? await storage.load(Self.resource)) ?? Self.resource.defaultValue
    return times[size]
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool {
    var times = (try? await storage.load(Self.resource)) ?? Self.resource.defaultValue
    if let existing = times[size], existing <= time {
      return false
    }

    times[size] = time
    try? await storage.save(times, for: Self.resource)
    return true
  }
}
