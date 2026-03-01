import Foundation

struct WinViewModel {
  let boardSize: Int
  let moveCount: Int
  let startedAt: Date
  let solvedAt: Date
  let bestTime: TimeInterval?
  let isNewBest: Bool
  private let onPlayAgain: () -> Void

  init(
    boardSize: Int,
    moveCount: Int,
    startedAt: Date,
    solvedAt: Date,
    bestTime: TimeInterval? = nil,
    isNewBest: Bool = false,
    onPlayAgain: @escaping () -> Void
  ) {
    self.boardSize = boardSize
    self.moveCount = moveCount
    self.startedAt = startedAt
    self.solvedAt = solvedAt
    self.bestTime = bestTime
    self.isNewBest = isNewBest
    self.onPlayAgain = onPlayAgain
  }

  func playAgainButtonTapped() {
    onPlayAgain()
  }
}
