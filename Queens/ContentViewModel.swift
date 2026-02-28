import Board
import Foundation
import Game
import Observation
import Problems

@MainActor
@Observable
final class ContentViewModel {
    static let maximumBoardSize = 32
    static let supportedBoardSizes = Array(Board.minimumSize...maximumBoardSize)

    private var game: Game<NQueensProblem>
    var isWinScreenPresented = false
    private(set) var solvedAt: Date?
    private let haptics: any GameHaptics

    var board: Board {
        game.board
    }

    var startedAt: Date {
        game.startedAt
    }

    private let occupant = Occupant(piece: .queen, side: .white)

    init(
        size: Int = 4,
        haptics: any GameHaptics = SystemGameHaptics()
    ) {
        self.haptics = haptics
        self.game = Game(size: size, problem: NQueensProblem())
    }

    var selectedBoardSize: Int {
        get { game.board.size }
        set {
            guard newValue != game.board.size else { return }
            game = Game(size: newValue, problem: NQueensProblem())
            isWinScreenPresented = false
            solvedAt = nil
        }
    }

    var piecesRemaining: Int {
        game.board.size - game.board.occupiedSquares.count
    }

    var isSolved: Bool {
        game.isSolved
    }

    var moveCount: Int {
        game.moves.count
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

    func prepare() {
        haptics.prepare()
    }

    func squareTapped(_ position: Position) {
        if game.board.occupiedSquares[position] == occupant {
            game.apply(move: .remove(occupant, from: position))
            haptics.playRemovePiece()
        } else {
            game.apply(move: .place(occupant, at: position))
            haptics.playPlacePiece()
        }
        if game.isSolved {
            solvedAt = .now
            isWinScreenPresented = true
        }
    }

    func undoButtonTapped() {
        game.undo()
    }

    func resetButtonTapped() {
        game.reset()
        isWinScreenPresented = false
        solvedAt = nil
    }
}
