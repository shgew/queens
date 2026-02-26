import Engine
import Observation

@MainActor
@Observable
final class BoardViewModel {
    private(set) var board: Board

    init(size: Int = 8) {
        board = Board(size: size)
    }

    var queensPlaced: Int {
        board.queens.count
    }

    var queensRemaining: Int {
        board.queensRemaining
    }

    func isSolved() -> Bool {
        board.isSolved()
    }

    func squareTapped(_ position: Position) {
        board.toggleQueen(at: position)
    }

    func resetButtonTapped() {
        board.reset()
    }
}
