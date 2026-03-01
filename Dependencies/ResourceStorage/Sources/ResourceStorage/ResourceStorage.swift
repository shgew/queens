import Foundation

public protocol StorageResource {
  associatedtype Value: Codable
  var id: String { get }
  var defaultValue: Value { get }
}

public protocol ResourceStorage {
  func load<R: StorageResource>(_ resource: R) throws -> R.Value
  func save<R: StorageResource>(_ value: R.Value, for resource: R) throws
}

public final class InMemoryResourceStorage: ResourceStorage {
  private var values: [String: Data]
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder
  private let lock = NSLock()

  public init(
    values: [String: Data] = [:],
    encoder: JSONEncoder = JSONEncoder(),
    decoder: JSONDecoder = JSONDecoder()
  ) {
    self.values = values
    self.encoder = encoder
    self.decoder = decoder
  }

  public func load<R: StorageResource>(_ resource: R) throws -> R.Value {
    lock.lock()
    defer { lock.unlock() }

    guard let data = values[resource.id] else {
      return resource.defaultValue
    }
    return try decoder.decode(R.Value.self, from: data)
  }

  public func save<R: StorageResource>(_ value: R.Value, for resource: R) throws {
    lock.lock()
    defer { lock.unlock() }

    values[resource.id] = try encoder.encode(value)
  }
}

public final class FileResourceStorage: ResourceStorage {
  private let directory: URL
  private let fileManager: FileManager
  private let encoder: JSONEncoder
  private let decoder: JSONDecoder
  private let lock = NSLock()

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

  public func load<R: StorageResource>(_ resource: R) throws -> R.Value {
    lock.lock()
    defer { lock.unlock() }

    let fileURL = fileURL(for: resource)
    guard fileManager.fileExists(atPath: fileURL.path) else {
      return resource.defaultValue
    }

    let data = try Data(contentsOf: fileURL)
    return try decoder.decode(R.Value.self, from: data)
  }

  public func save<R: StorageResource>(_ value: R.Value, for resource: R) throws {
    lock.lock()
    defer { lock.unlock() }

    try ensureDirectoryExists()
    let data = try encoder.encode(value)
    try data.write(to: fileURL(for: resource), options: .atomic)
  }
}

extension FileResourceStorage {
  private func ensureDirectoryExists() throws {
    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
  }

  private func fileURL<R: StorageResource>(for resource: R) -> URL {
    directory.appendingPathComponent("\(resource.id).json")
  }
}
