import Board
import Engine
import Observation

@MainActor
@Observable
final class BoardViewModel {
    static let maximumBoardSize = 26
    static let supportedBoardSizes = Array(Board.minimumSize...maximumBoardSize)

    private(set) var board: Board
    private let rule: any ConflictRule

    init(size: Int = 8, rule: any ConflictRule = QueenConflictRule()) {
        board = Board(size: size)
        self.rule = rule
    }

    var queensPlaced: Int {
        board.squares.count
    }

    var queensRemaining: Int {
        board.size - board.squares.count
    }

    var selectedBoardSize: Int {
        get { board.size }
        set {
            guard newValue != board.size else { return }
            board = Board(size: newValue)
        }
    }

    var conflicts: Set<Position> {
        rule.conflicts(on: board)
    }

    var isSolved: Bool {
        board.squares.count == board.size && conflicts.isEmpty
    }

    func squareTapped(_ position: Position) {
        let occupant = Occupant(piece: .queen, side: .white)
        if board.squares[position] == occupant {
            board.toggle(occupant, at: position)
        } else {
            guard board.squares.count < board.size else { return }
            board.toggle(occupant, at: position)
        }
    }

    func resetButtonTapped() {
        board.reset()
    }
}
