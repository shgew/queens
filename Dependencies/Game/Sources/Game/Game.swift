import Board
import Problems
import Foundation

/// A playable game session that pairs a ``Board`` with a ``Problem`` to solve.
///
/// `Game` is generic over any `Problem` conformance, keeping it free of
/// puzzle-specific knowledge. It tracks the board state, a cached evaluation,
/// and the time the current attempt was started.
public struct Game<P: Problem>: Sendable {
    public let problem: P
    public private(set) var board: Board
    public private(set) var moves: [Move] = []
    public private(set) var evaluation: Evaluation<P.Diagnostic>
    public private(set) var startedAt: Date

    public init(size: Int = 8, problem: P) {
        self.problem = problem
        let board = Board(size: size)
        self.board = board
        self.evaluation = problem.evaluate(on: board, moves: [])
        self.startedAt = .now
    }

    /// Whether the current board satisfies the problem's constraints.
    public var isSolved: Bool {
        if case .solved = evaluation { return true }
        return false
    }

    /// Applies a move to the board, records it, and re-evaluates.
    public mutating func apply(move: Move) {
        execute(move: move)
        moves.append(move)
        evaluation = problem.evaluate(on: board, moves: moves)
    }

    /// Undoes the last move, reversing its effect on the board.
    public mutating func undo() {
        guard let move = moves.popLast() else { return }
        execute(move: move.opposite)
        evaluation = problem.evaluate(on: board, moves: moves)
    }

    private mutating func execute(move: Move) {
        switch move {
        case .placed(let occupant, at: let position),
             .removed(let occupant, from: let position):
            board.toggle(occupant, at: position)
        case .moved(let occupant, from: let origin, to: let destination):
            board.toggle(occupant, at: origin)
            board.toggle(occupant, at: destination)
        }
    }

    /// Clears the board, move history, and resets the start time.
    public mutating func reset() {
        board.reset()
        moves.removeAll()
        evaluation = problem.evaluate(on: board, moves: moves)
        startedAt = .now
    }
}
