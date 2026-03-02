import Foundation

final class MockUserDefaults: UserDefaults {
  private var storage: [String: Any] = [:]

  convenience init() {
    self.init(suiteName: "Mock.\(UUID().uuidString)")!
  }

  override func object(forKey defaultName: String) -> Any? {
    storage[defaultName]
  }

  override func double(forKey defaultName: String) -> Double {
    storage[defaultName] as? Double ?? 0
  }

  override func set(_ value: Any?, forKey defaultName: String) {
    if let value {
      storage[defaultName] = value
    } else {
      storage.removeValue(forKey: defaultName)
    }
  }
}
