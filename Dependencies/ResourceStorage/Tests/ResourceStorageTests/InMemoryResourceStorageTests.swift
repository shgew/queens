import Foundation
import ResourceStorage
import Testing

struct InMemoryResourceStorageTests {
  let storage = InMemoryResourceStorage()
  let resource = Resource(id: "test", defaultValue: [Int: TimeInterval]())

  @Test func `returns default for missing resource`() async throws {
    let value = try await storage.load(resource)
    #expect(value == [:])
  }

  @Test func `round trips saved value`() async throws {
    try await storage.save([4: 10], for: resource)
    let value = try await storage.load(resource)
    #expect(value == [4: 10])
  }
}
