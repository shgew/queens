import Foundation

/// An async key-value store that can persist any ``Resource``.
public protocol ResourceStorage: Sendable {
  /// Loads the value for `resource`, returning its ``Resource/defaultValue`` when
  /// no saved value exists.
  func load<R: Resource>(_ resource: R) async throws -> R.Value

  /// Persists `value` for `resource`, overwriting any previously saved value.
  func save<R: Resource>(_ value: R.Value, for resource: R) async throws
}
