import Foundation
import ResourceStorage

protocol BestTimesStoring {
  func bestTime(forSize size: Int) -> TimeInterval?
  @discardableResult
  func record(time: TimeInterval, forSize size: Int) -> Bool
}

struct BestTimesResource: StorageResource {
  static let resourceID = "best-times"

  let id = Self.resourceID
  let defaultValue: [Int: TimeInterval] = [:]
}

final class BestTimesStore: BestTimesStoring {
  private let storage: any ResourceStorage
  private let resource: BestTimesResource
  private var times: [Int: TimeInterval]?
  private let lock = NSLock()

  init(
    storage: any ResourceStorage = Self.makeDefaultStorage(),
    resource: BestTimesResource = BestTimesResource()
  ) {
    self.storage = storage
    self.resource = resource
  }

  func bestTime(forSize size: Int) -> TimeInterval? {
    lock.lock()
    defer { lock.unlock() }
    return loadTimesIfNeeded()[size]
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) -> Bool {
    lock.lock()
    defer { lock.unlock() }

    var loadedTimes = loadTimesIfNeeded()
    if let existing = loadedTimes[size], existing <= time {
      return false
    }

    loadedTimes[size] = time
    times = loadedTimes
    do {
      try storage.save(loadedTimes, for: resource)
    } catch {
      print("BestTimesStore failed to save: \(error)")
    }
    return true
  }
}

extension BestTimesStore {
  private func loadTimesIfNeeded() -> [Int: TimeInterval] {
    if let times {
      return times
    }
    let loadedTimes: [Int: TimeInterval]
    do {
      loadedTimes = try storage.load(resource)
    } catch {
      print("BestTimesStore failed to load: \(error)")
      loadedTimes = resource.defaultValue
    }
    times = loadedTimes
    return loadedTimes
  }

  private static func makeDefaultStorage(fileManager: FileManager = .default) -> FileResourceStorage {
    let directory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("Queens", isDirectory: true)
    return FileResourceStorage(directory: directory, fileManager: fileManager)
  }
}
