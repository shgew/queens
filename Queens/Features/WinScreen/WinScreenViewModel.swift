import Foundation

struct WinScreenViewModel {
    let boardSize: Int
    let moveCount: Int
    let startedAt: Date
    let solvedAt: Date
    private let onPlayAgain: () -> Void

    init(
        boardSize: Int,
        moveCount: Int,
        startedAt: Date,
        solvedAt: Date,
        onPlayAgain: @escaping () -> Void
    ) {
        self.boardSize = boardSize
        self.moveCount = moveCount
        self.startedAt = startedAt
        self.solvedAt = solvedAt
        self.onPlayAgain = onPlayAgain
    }

    func playAgainButtonTapped() {
        onPlayAgain()
    }
}
