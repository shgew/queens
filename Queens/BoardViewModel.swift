import Board
import Problems
import Game
import Observation

@MainActor
@Observable
final class BoardViewModel {
    static let maximumBoardSize = 32
    static let supportedBoardSizes = Array(Board.minimumSize...maximumBoardSize)

    private(set) var game: Game<NQueensProblem>

    private let occupant = Occupant(piece: .queen, side: .white)

    init(size: Int = 8) {
        self.game = Game(size: size, problem: NQueensProblem())
    }

    var selectedBoardSize: Int {
        get { game.board.size }
        set {
            guard newValue != game.board.size else { return }
            game = Game(size: newValue, problem: NQueensProblem())
        }
    }

    var piecesPlaced: Int {
        game.board.occupiedSquares.count
    }

    var piecesRemaining: Int {
        game.board.size - game.board.occupiedSquares.count
    }

    var isSolved: Bool {
        game.isSolved
    }

    var canUndo: Bool {
        !game.moves.isEmpty
    }

    var conflicts: Set<Position> {
        if case .unsolved(let diagnostic) = game.evaluation {
            return diagnostic.conflicts
        }
        return []
    }

    func squareTapped(_ position: Position) {
        if game.board.occupiedSquares[position] == occupant {
            game.apply(move: .removed(occupant, from: position))
        } else {
            game.apply(move: .placed(occupant, at: position))
        }
    }

    func undoButtonTapped() {
        game.undo()
    }

    func resetButtonTapped() {
        game.reset()
    }
}
