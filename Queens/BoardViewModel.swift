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
        game.board.squares.count
    }

    var piecesRemaining: Int {
        game.board.size - game.board.squares.count
    }

    var isSolved: Bool {
        game.isSolved
    }

    var conflicts: Set<Position> {
        if case .unsolved(let positions) = game.evaluation {
            return positions
        }
        return []
    }

    func squareTapped(_ position: Position) {
        let occupant = self.occupant
        game.apply { board in
            if board.squares[position] == occupant {
                board.toggle(occupant, at: position)
            } else {
                guard board.squares.count < board.size else { return }
                board.toggle(occupant, at: position)
            }
        }
    }

    func resetButtonTapped() {
        game.reset()
    }
}
