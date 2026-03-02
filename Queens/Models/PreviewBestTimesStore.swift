import Foundation

struct PreviewBestTimesStore: BestTimesStoring {
  func bestTime(for boardSize: Int) async -> TimeInterval? {
    previewBestTimes[boardSize]
  }

  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) async -> Bool {
    false
  }
}

extension PreviewBestTimesStore {
  private var previewBestTimes: [Int: TimeInterval] {
    [
      4: 19.2,
      5: 41.7,
      6: 86.4,
    ]
  }
}
