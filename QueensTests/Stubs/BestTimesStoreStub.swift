import Foundation

@testable import Queens

final class BestTimesStoreStub: BestTimesStoring {
  private let bestTime: TimeInterval?
  private let isNewBest: Bool

  init(
    bestTime: TimeInterval?,
    isNewBest: Bool
  ) {
    self.bestTime = bestTime
    self.isNewBest = isNewBest
  }

  func bestTime(for _: Int) async -> TimeInterval? {
    bestTime
  }

  @discardableResult
  func record(time _: TimeInterval, for _: Int) async -> Bool {
    isNewBest
  }
}
