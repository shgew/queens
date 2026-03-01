import Foundation

final class MockFileManager: FileManager {
  var files: [String: Data] = [:]

  override func contents(atPath path: String) -> Data? {
    files[path]
  }

  override func createFile(
    atPath path: String,
    contents data: Data?,
    attributes attr: [FileAttributeKey: Any]? = nil
  ) -> Bool {
    files[path] = data
    return true
  }

  override func createDirectory(
    at url: URL,
    withIntermediateDirectories createIntermediates: Bool,
    attributes: [FileAttributeKey: Any]? = nil
  ) throws {
    // no-op
  }
}
