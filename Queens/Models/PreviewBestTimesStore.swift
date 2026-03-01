import Foundation

struct PreviewBestTimesStore: BestTimesStoring {
  func bestTime(for boardSize: Int) async -> TimeInterval? {
    sampleSections
      .first(where: { $0.boardSize == boardSize })?
      .times
      .first
  }

  func topTimesByBoardSize() async -> [LeaderboardSection] {
    sampleSections
  }

  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) async -> Bool {
    false
  }
}

extension PreviewBestTimesStore {
  private var sampleSections: [LeaderboardSection] {
    [
      LeaderboardSection(boardSize: 4, times: [19.2, 22.8, 27.4]),
      LeaderboardSection(boardSize: 5, times: [41.7, 47.1, 52.6, 58.2]),
      LeaderboardSection(boardSize: 6, times: [86.4, 94.9]),
    ]
  }
}
