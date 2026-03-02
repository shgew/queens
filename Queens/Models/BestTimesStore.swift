import Foundation

final class BestTimesStore: BestTimesStoring {
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
    return userDefaults.object(forKey: key).flatMap { $0 as? TimeInterval }
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
