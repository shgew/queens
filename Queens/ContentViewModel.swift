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

    private(set) var game: Game<NQueensProblem>
    var isWinScreenPresented = false
    private(set) var solvedAt: Date?

    private let occupant = Occupant(piece: .queen, side: .white)

    init(size: Int = 4) {
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

    var piecesPlaced: Int {
        game.board.occupiedSquares.count
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

    func elapsedTime(now: Date) -> String {
        let elapsed = max(0, now.timeIntervalSince(game.startedAt))
        let duration = Duration.seconds(elapsed)
        if elapsed >= 3600 {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        }
        return duration.formatted(.time(pattern: .minuteSecond))
    }

    func squareTapped(_ position: Position) {
        if game.board.occupiedSquares[position] == occupant {
            game.apply(move: .remove(occupant, from: position))
        } else {
            game.apply(move: .place(occupant, at: position))
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
