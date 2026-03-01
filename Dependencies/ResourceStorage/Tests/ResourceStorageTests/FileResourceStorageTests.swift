import Foundation
import Testing

@testable import ResourceStorage

struct FileResourceStorageTests {
  let storage: FileResourceStorage<TestResource>
  let resource = TestResource()

  init() {
    let fm = MockFileManager()
    storage = FileResourceStorage(directory: URL(filePath: "/mock"), fileManager: fm)
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
}
