import Foundation

final class MockUserDefaults: UserDefaults {
  private var storage: [String: Any] = [:]

  convenience init() {
    self.init(suiteName: "Mock.\(UUID().uuidString)")!
  }

  override func object(forKey defaultName: String) -> Any? {
    storage[defaultName]
  }

  override func set(_ value: Any?, forKey defaultName: String) {
    storage[defaultName] = value
  }
}
