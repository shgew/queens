import Foundation

/// A ``ResourceStorage`` that holds values in memory.
///
/// Values are lost when the instance is deallocated. Useful for previews and tests.
public actor InMemoryResourceStorage: ResourceStorage {
  private var values: [String: any Sendable]

  /// Creates an in-memory storage, optionally pre-populated with values keyed by resource id.
  public init(values: [String: any Sendable] = [:]) {
    self.values = values
  }

  public func load<Value>(_ resource: Resource<Value>) async throws -> Value {
    (values[resource.id] as? Value) ?? resource.defaultValue
  }

  public func save<Value>(_ value: Value, for resource: Resource<Value>) async throws {
    values[resource.id] = value
  }
}
