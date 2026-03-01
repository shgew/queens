import Foundation

/// A named, defaultable value that can be persisted by a ``ResourceStorage``.
public struct Resource<Value: Codable & Sendable>: Identifiable, Sendable {
  /// A unique identifier used to distinguish this resource from others in the same storage.
  public let id: String

  /// The value returned when no previously saved value exists.
  public let defaultValue: Value

  public init(id: String, defaultValue: Value) {
    self.id = id
    self.defaultValue = defaultValue
  }
}
