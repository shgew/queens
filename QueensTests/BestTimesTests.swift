import Foundation
import Testing

@testable import Queens

struct BestTimesTests {
  let bestTimes = BestTimesStore(storage: InMemoryStorage(initialValue: [:]))

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
    let storage = FileStorage<[Int: TimeInterval]>.bestTimesStorage(directory: directory)
    let bestTimes = BestTimesStore(storage: storage)
    bestTimes.record(time: 10.0, forSize: 4)

    let reloaded = BestTimesStore(storage: storage)
    #expect(reloaded.bestTime(forSize: 4) == 10.0)
  }

  private func makeTempDirectory() throws -> URL {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent("BestTimesTests-\(UUID().uuidString)")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    return directory
  }
}
