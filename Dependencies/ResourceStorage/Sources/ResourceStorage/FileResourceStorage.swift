import Foundation

/// A ``ResourceStorage`` that persists values as JSON files in a directory on disk.
///
/// Each resource is stored as `<directory>/<resource.id>.json`. The directory is created
/// automatically on the first save if it doesn't already exist.
public actor FileResourceStorage: ResourceStorage {
  let directory: URL
  let fileManager: FileManager
  let encoder: JSONEncoder
  let decoder: JSONDecoder

  /// Creates a file-backed storage.
  ///
  /// - Parameters:
  ///   - directory: The directory where resource files are stored.
  ///   - fileManager: The file manager used for all file operations.
  ///   - encoder: The JSON encoder used to serialize values.
  ///   - decoder: The JSON decoder used to deserialize values.
  public init(
    directory: URL,
    fileManager: FileManager = .default,
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
  ) {
    self.directory = directory
    self.fileManager = fileManager
    self.encoder = encoder
    self.decoder = decoder
  }

  public func load<R: Resource>(_ resource: R) async throws -> R.Value {
    let fileURL = fileURL(for: resource)
    guard let data = fileManager.contents(atPath: fileURL.path()) else {
      return resource.defaultValue
    }

    return try decoder.decode(R.Value.self, from: data)
  }

  public func save<R: Resource>(_ value: R.Value, for resource: R) async throws {
    try ensureDirectoryExists()
    let data = try encoder.encode(value)
    fileManager.createFile(atPath: fileURL(for: resource).path(), contents: data)
  }
}

extension FileResourceStorage {
  private func ensureDirectoryExists() throws {
    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
  }

  private func fileURL<R: Resource>(for resource: R) -> URL {
    directory.appendingPathComponent("\(resource.id).json")
  }
}
