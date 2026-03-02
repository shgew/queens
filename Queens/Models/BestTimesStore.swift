import Foundation

struct BestTimesStore: BestTimesStoring {
  private let userDefaults: UserDefaults
  private let keyPrefix: String

  init(
    userDefaults: UserDefaults = UserDefaults.standard,
    keyPrefix: String = "bestTimes"
  ) {
    self.userDefaults = userDefaults
    self.keyPrefix = keyPrefix
  }

  func bestTime(for boardSize: Int) -> TimeInterval? {
    let key = storageKey(for: boardSize)
    guard userDefaults.object(forKey: key) != nil else { return nil }
    return userDefaults.double(forKey: key)
  }

  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) -> Bool {
    if let existing = bestTime(for: boardSize), time >= existing {
      return false
    }

    userDefaults.set(time, forKey: storageKey(for: boardSize))
    return true
  }
}

extension BestTimesStore {
  private func storageKey(for boardSize: Int) -> String {
    "\(keyPrefix).\(boardSize)"
  }
}

extension BestTimesStore {
  @MainActor
  static let live = BestTimesStore()
}
