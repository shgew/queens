import Foundation

struct WinViewModel {
  let boardSize: Int
  let moveCount: Int
  let elapsedTime: TimeInterval
  let bestTime: TimeInterval?
  let isNewBest: Bool
  private let onPlayAgain: () -> Void

  init(
    boardSize: Int,
    moveCount: Int,
    elapsedTime: TimeInterval,
    bestTime: TimeInterval? = nil,
    isNewBest: Bool = false,
    onPlayAgain: @escaping () -> Void
  ) {
    self.boardSize = boardSize
    self.moveCount = moveCount
    self.elapsedTime = elapsedTime
    self.bestTime = bestTime
    self.isNewBest = isNewBest
    self.onPlayAgain = onPlayAgain
  }

  func playAgainButtonTapped() {
    onPlayAgain()
  }
}
