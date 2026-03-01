import Foundation
import ResourceStorage
import Testing

struct FileResourceStorageTests {
  let storage: FileResourceStorage
  let cache: Cache
  let resource = Resource(id: "test", defaultValue: [Int: TimeInterval]())

  init() {
    let cache = Cache()
    self.cache = cache
    self.storage = FileResourceStorage(
      directory: URL(filePath: "/mock"),
      fileManager: MockFileManager(),
      cache: cache
    )
  }

  @Test func `returns default for missing resource`() async throws {
    let value = try await storage.load(resource)
    #expect(value == [:])
  }

  @Test func `round trips saved value`() async throws {
    try await storage.save([8: 20], for: resource)
    let value = try await storage.load(resource)
    #expect(value == [8: 20])
  }

  @Test func `load populates cache`() async throws {
    try await storage.save([4: 10], for: resource)
    _ = try await storage.load(resource)

    let cached: [Int: TimeInterval]? = await cache.value(forKey: "test")
    #expect(cached == [4: 10])
  }

  @Test func `save populates cache`() async throws {
    try await storage.save([4: 10], for: resource)

    let cached: [Int: TimeInterval]? = await cache.value(forKey: "test")
    #expect(cached == [4: 10])
  }

  @Test func `load returns cached value`() async throws {
    await cache.setValue([4: 99] as [Int: TimeInterval], forKey: "test")

    let value = try await storage.load(resource)
    #expect(value == [4: 99])
  }
}
