import Foundation
import ResourceStorage
import Testing

@testable import Queens

struct BestTimesTests {
  let bestTimes = BestTimesStore(storage: InMemoryResourceStorage())

  @Test func `returns nil for unseen size`() {
    let result = bestTimes.bestTime(forSize: 4)
    #expect(result == nil)
  }

  @Test func `records first time`() {
    let isNew = bestTimes.record(time: 10.0, forSize: 4)

    #expect(isNew)
    #expect(bestTimes.bestTime(forSize: 4) == 10.0)
  }

  @Test func `faster time replaces existing`() {
    bestTimes.record(time: 10.0, forSize: 4)
    let isNew = bestTimes.record(time: 7.0, forSize: 4)

    #expect(isNew)
    #expect(bestTimes.bestTime(forSize: 4) == 7.0)
  }

  @Test func `slower time does not replace existing`() {
    bestTimes.record(time: 10.0, forSize: 4)
    let isNew = bestTimes.record(time: 15.0, forSize: 4)

    #expect(!isNew)
    #expect(bestTimes.bestTime(forSize: 4) == 10.0)
  }

  @Test func `equal time does not replace existing`() {
    bestTimes.record(time: 10.0, forSize: 4)
    let isNew = bestTimes.record(time: 10.0, forSize: 4)

    #expect(!isNew)
  }

  @Test func `different sizes are independent`() {
    bestTimes.record(time: 10.0, forSize: 4)
    bestTimes.record(time: 20.0, forSize: 8)

    #expect(bestTimes.bestTime(forSize: 4) == 10.0)
    #expect(bestTimes.bestTime(forSize: 8) == 20.0)
  }

  @Test func `persists across store instances with file storage`() throws {
    let directory = try makeTempDirectory()
    let storage = FileResourceStorage(directory: directory)
    let bestTimes = BestTimesStore(storage: storage)
    bestTimes.record(time: 10.0, forSize: 4)

    let reloadedStorage = FileResourceStorage(directory: directory)
    let reloaded = BestTimesStore(storage: reloadedStorage)
    #expect(reloaded.bestTime(forSize: 4) == 10.0)
  }

  @Test func `load failure falls back to default`() {
    let storage = FailingResourceStorage(shouldFailLoad: true)
    let bestTimes = BestTimesStore(storage: storage)

    #expect(bestTimes.bestTime(forSize: 4) == nil)
  }

  @Test func `save failure still updates in-memory best time`() {
    let storage = FailingResourceStorage(shouldFailSave: true)
    let bestTimes = BestTimesStore(storage: storage)

    let isNewBest = bestTimes.record(time: 10.0, forSize: 4)
    #expect(isNewBest)
    #expect(bestTimes.bestTime(forSize: 4) == 10.0)
  }

  private func makeTempDirectory() throws -> URL {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent("BestTimesTests-\(UUID().uuidString)")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    return directory
  }
}

private final class FailingResourceStorage: ResourceStorage {
  enum Failure: Error {
    case load
    case save
  }

  private let shouldFailLoad: Bool
  private let shouldFailSave: Bool
  private var values: [Int: TimeInterval]

  init(
    shouldFailLoad: Bool = false,
    shouldFailSave: Bool = false,
    values: [Int: TimeInterval] = [:]
  ) {
    self.shouldFailLoad = shouldFailLoad
    self.shouldFailSave = shouldFailSave
    self.values = values
  }

  func load<R: StorageResource>(_ resource: R) throws -> R.Value {
    if shouldFailLoad {
      throw Failure.load
    }
    let data = try JSONEncoder().encode(values)
    return try JSONDecoder().decode(R.Value.self, from: data)
  }

  func save<R: StorageResource>(_ value: R.Value, for resource: R) throws {
    if shouldFailSave {
      throw Failure.save
    }
    let data = try JSONEncoder().encode(value)
    values = try JSONDecoder().decode([Int: TimeInterval].self, from: data)
  }
}
