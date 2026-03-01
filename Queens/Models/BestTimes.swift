import Foundation
import ResourceStorage

protocol BestTimesStoring {
  func bestTime(forSize size: Int) async -> TimeInterval?
  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool
}

struct BestTimesResource: Resource {
  let id = "best-times"
  let defaultValue: [Int: TimeInterval] = [:]
}

actor BestTimesStore: BestTimesStoring {
  private let storage: any ResourceStorage
  private let resource: BestTimesResource
  private var times: [Int: TimeInterval]?

  init(
    storage: (any ResourceStorage)? = nil,
    resource: BestTimesResource = BestTimesResource()
  ) {
    self.storage = storage ?? Self.makeDefaultStorage()
    self.resource = resource
  }

  func bestTime(forSize size: Int) async -> TimeInterval? {
    let loadedTimes = await loadTimesIfNeeded()
    return loadedTimes[size]
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool {
    var loadedTimes = await loadTimesIfNeeded()
    if let existing = loadedTimes[size], existing <= time {
      return false
    }

    loadedTimes[size] = time
    times = loadedTimes
    do {
      try await storage.save(loadedTimes, for: resource)
    } catch {
      print("BestTimesStore failed to save: \(error)")
    }
    return true
  }
}

extension BestTimesStore {
  private func loadTimesIfNeeded() async -> [Int: TimeInterval] {
    if let times {
      return times
    }
    let loadedTimes: [Int: TimeInterval]
    do {
      loadedTimes = try await storage.load(resource)
    } catch {
      print("BestTimesStore failed to load: \(error)")
      loadedTimes = resource.defaultValue
    }
    times = loadedTimes
    return loadedTimes
  }

  private static func makeDefaultStorage() -> FileResourceStorage {
    let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("Queens", isDirectory: true)
    return FileResourceStorage(directory: directory)
  }
}
