import Foundation

protocol BestTimesStoring {
  func bestTime(forSize size: Int) -> TimeInterval?
  @discardableResult
  func record(time: TimeInterval, forSize size: Int) -> Bool
}

protocol Storage<Value> {
  associatedtype Value
  func load() -> Value
  func save(_ value: Value)
}

final class BestTimesStore: BestTimesStoring {
  private let storage: any Storage<[Int: TimeInterval]>
  private var times: [Int: TimeInterval]?

  init(
    storage: any Storage<[Int: TimeInterval]> = FileStorage<[Int: TimeInterval]>.bestTimesStorage()
  ) {
    self.storage = storage
  }

  func bestTime(forSize size: Int) -> TimeInterval? {
    let loadedTimes = loadTimesIfNeeded()
    return loadedTimes[size]
  }

  @discardableResult
  func record(time: TimeInterval, forSize size: Int) -> Bool {
    var loadedTimes = loadTimesIfNeeded()
    if let existing = loadedTimes[size], existing <= time {
      return false
    }
    loadedTimes[size] = time
    times = loadedTimes
    storage.save(loadedTimes)
    return true
  }
}

extension BestTimesStore {
  private func loadTimesIfNeeded() -> [Int: TimeInterval] {
    if let times {
      return times
    }
    let loadedTimes = storage.load()
    times = loadedTimes
    return loadedTimes
  }
}

final class FileStorage<Value: Codable>: Storage {
  private let fileURL: URL
  private let defaultValue: Value

  init(
    directory: URL,
    fileName: String,
    defaultValue: Value
  ) {
    fileURL = directory.appendingPathComponent(fileName)
    self.defaultValue = defaultValue
  }

  func load() -> Value {
    do {
      let data = try Data(contentsOf: fileURL)
      return try JSONDecoder().decode(Value.self, from: data)
    } catch let error as CocoaError where error.code == .fileReadNoSuchFile {
      return defaultValue
    } catch {
      print("FileStorage failed to load best times: \(error)")
      return defaultValue
    }
  }

  func save(_ value: Value) {
    do {
      let data = try JSONEncoder().encode(value)
      try data.write(to: fileURL, options: .atomic)
    } catch {
      print("FileStorage failed to save best times: \(error)")
    }
  }
}

extension FileStorage where Value == [Int: TimeInterval] {
  static func bestTimesStorage(
    directory: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0],
    fileName: String = "best-times.json"
  ) -> FileStorage {
    FileStorage(directory: directory, fileName: fileName, defaultValue: [:])
  }
}

final class InMemoryStorage<Value>: Storage {
  private var value: Value

  init(initialValue: Value) {
    value = initialValue
  }

  func load() -> Value {
    value
  }

  func save(_ value: Value) {
    self.value = value
  }
}
