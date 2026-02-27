import Board
import Engine
import Foundation

/// A playable game session that pairs a ``Board`` with a ``Problem`` to solve.
///
/// `Game` is generic over any `Problem` conformance, keeping it free of
/// puzzle-specific knowledge. It tracks the board state, a cached evaluation,
/// and the time the current attempt was started.
public struct Game<P: Problem>: Sendable {
    public let problem: P
    public private(set) var board: Board
    public private(set) var evaluation: Evaluation<P.Diagnostic>
    public private(set) var startedAt: Date

    public init(size: Int = 8, problem: P) {
        self.problem = problem
        let board = Board(size: size)
        self.board = board
        self.evaluation = problem.evaluate(board)
        self.startedAt = .now
    }

    /// Whether the current board satisfies the problem's constraints.
    public var isSolved: Bool {
        if case .solved = evaluation { return true }
        return false
    }

    /// Mutates the board via `body`, then re-evaluates.
    public mutating func apply(_ body: (inout Board) -> Void) {
        body(&board)
        evaluation = problem.evaluate(board)
    }

    /// Clears the board and resets the start time.
    public mutating func reset() {
        board.reset()
        evaluation = problem.evaluate(board)
        startedAt = .now
    }
}
