import Foundation

/// A thread-safe, type-erased cache backed by `NSCache`.
public final actor Cache {
  private let storage = NSCache<NSString, Entry>()

  public init() {}

  public func value<Value: Sendable>(forKey key: String) -> Value? {
    let object = storage.object(forKey: key as NSString)
    return object?.value as? Value
  }

  public func setValue<Value: Sendable>(_ value: Value, forKey key: String) {
    storage.setObject(Entry(value: value), forKey: key as NSString)
  }
}

extension Cache {
  private final class Entry {
    let value: any Sendable
    init(value: any Sendable) { self.value = value }
  }
}
