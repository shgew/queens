import Foundation

/// A named, defaultable value that can be persisted by a ``ResourceStorage``.
public protocol Resource: Identifiable, Sendable {
  /// The type of value this resource stores.
  associatedtype Value: Codable & Sendable

  /// A unique identifier used to distinguish this resource from others in the same storage.
  var id: String { get }

  /// The value returned when no previously saved value exists.
  var defaultValue: Value { get }
}
