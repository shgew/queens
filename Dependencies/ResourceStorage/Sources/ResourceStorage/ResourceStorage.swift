import Foundation

public protocol StorageResource: Sendable {
  associatedtype Value: Sendable
  var id: String { get }
  var defaultValue: Value { get }
}

public protocol ResourceStorage<Resource>: Sendable {
  associatedtype Resource: StorageResource
  func load(_ resource: Resource) async throws -> Resource.Value
  func save(_ value: Resource.Value, for resource: Resource) async throws
}
