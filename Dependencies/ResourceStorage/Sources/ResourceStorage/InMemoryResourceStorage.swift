import Foundation

public actor InMemoryResourceStorage<Resource: StorageResource>: ResourceStorage {
  private var values: [String: Resource.Value]

  public init(values: [String: Resource.Value] = [:]) {
    self.values = values
  }

  public func load(_ resource: Resource) async throws -> Resource.Value {
    values[resource.id] ?? resource.defaultValue
  }

  public func save(_ value: Resource.Value, for resource: Resource) async throws {
    values[resource.id] = value
  }
}
