import Foundation

protocol BestTimesStoring {
  func bestTime(for boardSize: Int) async -> TimeInterval?
  func topTimesByBoardSize() async -> [LeaderboardSection]
  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) async -> Bool
}
