import Foundation

final class PreviewBestTimesStore: BestTimesStoring {
  private var bestTimes: [Int: TimeInterval]

  init(initialBestTimes: [Int: TimeInterval] = [:]) {
    self.bestTimes = initialBestTimes
  }

  func bestTime(for boardSize: Int) -> TimeInterval? {
    bestTimes[boardSize]
  }

  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) -> Bool {
    if let existing = bestTime(for: boardSize), time >= existing {
      return false
    }

    bestTimes[boardSize] = time
    return true
  }
}
