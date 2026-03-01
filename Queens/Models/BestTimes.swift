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

  init(
    storage: (any ResourceStorage)? = nil,
  ) {
    self.storage = storage ?? Self.makeDefaultStorage()
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

extension BestTimesStore {
  private static func makeDefaultStorage() -> FileResourceStorage {
    let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("Queens", isDirectory: true)
    return FileResourceStorage(directory: directory)
  }
}
