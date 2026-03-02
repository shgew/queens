import Foundation

protocol BestTimesStoring {
  func bestTime(for boardSize: Int) -> TimeInterval?
  @discardableResult
  func record(time: TimeInterval, for boardSize: Int) -> Bool
}
