import Foundation

/// An async key-value store that can persist any ``Resource``.
public protocol ResourceStorage: Sendable {
  /// Loads the value for `resource`, returning its ``Resource/defaultValue`` when
  /// no saved value exists.
  func load<Value>(_ resource: Resource<Value>) async throws -> Value

  /// Persists `value` for `resource`, overwriting any previously saved value.
  func save<Value>(_ value: Value, for resource: Resource<Value>) async throws
}
