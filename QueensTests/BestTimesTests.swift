import Foundation
import ResourceStorage
import Testing

@testable import Queens

struct BestTimesTests {
  let bestTimes = BestTimesStore(storage: InMemoryResourceStorage())

  @Test func `returns nil for unseen size`() async {
    let result = await bestTimes.bestTime(forSize: 4)
    #expect(result == nil)
  }

  @Test func `records first time`() async {
    let isNew = await bestTimes.record(time: 10.0, forSize: 4)

    #expect(isNew)
    #expect(await bestTimes.bestTime(forSize: 4) == 10.0)
  }

  @Test func `faster time replaces existing`() async {
    await bestTimes.record(time: 10.0, forSize: 4)
    let isNew = await bestTimes.record(time: 7.0, forSize: 4)

    #expect(isNew)
    #expect(await bestTimes.bestTime(forSize: 4) == 7.0)
  }

  @Test func `slower time does not replace existing`() async {
    await bestTimes.record(time: 10.0, forSize: 4)
    let isNew = await bestTimes.record(time: 15.0, forSize: 4)

    #expect(!isNew)
    #expect(await bestTimes.bestTime(forSize: 4) == 10.0)
  }

  @Test func `equal time does not replace existing`() async {
    await bestTimes.record(time: 10.0, forSize: 4)
    let isNew = await bestTimes.record(time: 10.0, forSize: 4)

    #expect(!isNew)
  }

  @Test func `different sizes are independent`() async {
    await bestTimes.record(time: 10.0, forSize: 4)
    await bestTimes.record(time: 20.0, forSize: 8)

    #expect(await bestTimes.bestTime(forSize: 4) == 10.0)
    #expect(await bestTimes.bestTime(forSize: 8) == 20.0)
  }

  @Test func `persists across store instances with file storage`() async throws {
    let directory = try makeTempDirectory()
    let storage = FileResourceStorage(directory: directory)
    let bestTimes = BestTimesStore(storage: storage)
    await bestTimes.record(time: 10.0, forSize: 4)

    let reloadedStorage = FileResourceStorage(directory: directory)
    let reloaded = BestTimesStore(storage: reloadedStorage)
    #expect(await reloaded.bestTime(forSize: 4) == 10.0)
  }

  @Test func `load failure falls back to default`() async {
    let storage = FailingResourceStorage(shouldFailLoad: true)
    let bestTimes = BestTimesStore(storage: storage)

    #expect(await bestTimes.bestTime(forSize: 4) == nil)
  }

  private func makeTempDirectory() throws -> URL {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent("BestTimesTests-\(UUID().uuidString)")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    return directory
  }
}

private actor FailingResourceStorage: ResourceStorage {
  enum Failure: Error {
    case load
  }

  private let shouldFailLoad: Bool

  init(shouldFailLoad: Bool = false) {
    self.shouldFailLoad = shouldFailLoad
  }

  func load<Value>(_ resource: Resource<Value>) async throws -> Value {
    if shouldFailLoad {
      throw Failure.load
    }
    return resource.defaultValue
  }

  func save<Value>(_ value: Value, for resource: Resource<Value>) async throws {}
}
