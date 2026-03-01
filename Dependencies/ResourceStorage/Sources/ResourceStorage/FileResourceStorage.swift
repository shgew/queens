import Foundation

public actor FileResourceStorage<Resource: StorageResource>: ResourceStorage
where Resource.Value: Codable {
  let directory: URL
  let fileManager: FileManager
  let encoder: JSONEncoder
  let decoder: JSONDecoder

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

  public func load(_ resource: Resource) async throws -> Resource.Value {
    let fileURL = fileURL(for: resource)
    guard let data = fileManager.contents(atPath: fileURL.path()) else {
      return resource.defaultValue
    }

    return try decoder.decode(Resource.Value.self, from: data)
  }

  public func save(_ value: Resource.Value, for resource: Resource) async throws {
    try ensureDirectoryExists()
    let data = try encoder.encode(value)
    try data.write(to: fileURL(for: resource), options: .atomic)
  }
}

extension FileResourceStorage {
  private func ensureDirectoryExists() throws {
    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
  }

  private func fileURL(for resource: Resource) -> URL {
    directory.appendingPathComponent("\(resource.id).json")
  }
}
