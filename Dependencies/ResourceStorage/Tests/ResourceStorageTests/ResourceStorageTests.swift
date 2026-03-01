import Foundation
import Testing

@testable import ResourceStorage

struct ResourceStorageTests {
  @Test func `in-memory returns default for missing resource`() async throws {
    let storage = InMemoryResourceStorage<TestResource>()

    let value = try await storage.load(TestResource())
    #expect(value == [:])
  }

  @Test func `in-memory round trips saved value`() async throws {
    let storage = InMemoryResourceStorage<TestResource>()
    let resource = TestResource()

    try await storage.save([4: 10], for: resource)
    let value = try await storage.load(resource)
    #expect(value == [4: 10])
  }

  @Test func `file storage round trips saved value`() async throws {
    let directory = try makeTempDirectory()
    let storage = FileResourceStorage<TestResource>(directory: directory)
    let resource = TestResource()

    try await storage.save([8: 20], for: resource)
    let value = try await storage.load(resource)
    #expect(value == [8: 20])
  }
}

private struct TestResource: StorageResource {
  let id = "test-resource"
  let defaultValue: [Int: TimeInterval] = [:]
}

extension ResourceStorageTests {
  private func makeTempDirectory() throws -> URL {
    let directory = FileManager.default.temporaryDirectory
      .appendingPathComponent("ResourceStorageTests-\(UUID().uuidString)")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    return directory
  }
}
