import Board
import Engine
import Observation

@MainActor
@Observable
final class BoardViewModel {
    static let maximumBoardSize = 32
    static let supportedBoardSizes = Array(Board.minimumSize...maximumBoardSize)

    private(set) var board: Board {
        didSet { evaluation = problem.evaluate(board) }
    }
    private let problem: NQueensProblem
    private(set) var evaluation: Evaluation<Set<Position>>

    init(size: Int = 8, problem: NQueensProblem = NQueensProblem()) {
        self.problem = problem
        let board = Board(size: size)
        self.board = board
        self.evaluation = problem.evaluate(board)
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
        if case .unsolved(let positions) = evaluation {
            return positions
        }
        return []
    }

    var isSolved: Bool {
        evaluation == .solved
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
