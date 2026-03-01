import Foundation

protocol BestTimesStoring {
  func bestTime(forSize size: Int) async -> TimeInterval?
  @discardableResult
  func record(time: TimeInterval, forSize size: Int) async -> Bool
}
