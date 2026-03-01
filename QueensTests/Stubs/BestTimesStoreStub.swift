import Foundation

@testable import Queens

final class BestTimesStoreStub: BestTimesStoring {
  private let bestTime: TimeInterval?
  private let isNewBest: Bool
  private let leaderboardSections: [LeaderboardSection]

  init(
    bestTime: TimeInterval?,
    isNewBest: Bool,
    leaderboardSections: [LeaderboardSection] = []
  ) {
    self.bestTime = bestTime
    self.isNewBest = isNewBest
    self.leaderboardSections = leaderboardSections
  }

  func bestTime(for _: Int) async -> TimeInterval? {
    bestTime
  }

  @discardableResult
  func record(time _: TimeInterval, for _: Int) async -> Bool {
    isNewBest
  }

  func topTimesByBoardSize() async -> [LeaderboardSection] {
    leaderboardSections
  }
}
