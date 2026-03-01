import Foundation
import Logging
import OSLog

/// A ``ResourceStorage`` that persists values as JSON files in a directory on disk.
///
/// Each resource is stored as `<directory>/<resource.id>.json`. The directory is created
/// automatically on the first save if it doesn't already exist.
///
/// Loaded values are cached in memory to avoid redundant disk reads.
private let logger = Logger.queens(category: .storage)

public actor FileResourceStorage: ResourceStorage {
  let directory: URL
  let fileManager: FileManager
  let encoder: JSONEncoder
  let decoder: JSONDecoder
  private let cache: Cache

  /// Creates a file-backed storage.
  ///
  /// - Parameters:
  ///   - directory: The directory where resource files are stored.
  ///   - fileManager: The file manager used for all file operations.
  ///   - encoder: The JSON encoder used to serialize values.
  ///   - decoder: The JSON decoder used to deserialize values.
  ///   - cache: The cache used to avoid redundant disk reads.
  public init(
    directory: URL,
    fileManager: FileManager = .default,
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder(),
    cache: Cache = Cache()
  ) {
    self.directory = directory
    self.fileManager = fileManager
    self.encoder = encoder
    self.decoder = decoder
    self.cache = cache
  }

  public func load<Value>(_ resource: Resource<Value>) async throws -> Value {
    if let cached: Value = await cache.value(forKey: resource.id) {
      logger.debug("Cache hit for \(resource.id)")
      return cached
    }

    let fileURL = fileURL(for: resource)
    guard let data = fileManager.contents(atPath: fileURL.path()) else {
      logger.debug("No file for \(resource.id), returning default")
      return resource.defaultValue
    }

    do {
      let value = try decoder.decode(Value.self, from: data)
      await cache.setValue(value, forKey: resource.id)
      logger.debug("Loaded \(resource.id) from disk")
      return value
    } catch {
      logger.error("Failed to decode \(resource.id): \(error)")
      throw error
    }
  }

  public func save<Value>(_ value: Value, for resource: Resource<Value>) async throws {
    try ensureDirectoryExists()
    do {
      let data = try encoder.encode(value)
      fileManager.createFile(atPath: fileURL(for: resource).path(), contents: data)
      await cache.setValue(value, forKey: resource.id)
      logger.debug("Saved \(resource.id)")
    } catch {
      logger.error("Failed to encode \(resource.id): \(error)")
      throw error
    }
  }
}

extension FileResourceStorage {
  private func ensureDirectoryExists() throws {
    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
  }

  private func fileURL<Value>(for resource: Resource<Value>) -> URL {
    directory.appendingPathComponent("\(resource.id).json")
  }
}
