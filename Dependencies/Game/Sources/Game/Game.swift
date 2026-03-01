import Board
import Foundation
import OSLog
import Problems
import Logging

private let logger = Logger.queens(category: .game)

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
    logger.debug("Initialized game with board size \(size)")
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
    logMoveApplied(moveCount: moves.count, solved: isSolved)
  }

  /// Undoes the last move, reversing its effect on the board.
  public mutating func undo() {
    guard let move = moves.popLast() else {
      logger.debug("Undo ignored because no moves are available")
      return
    }
    execute(move: move.opposite)
    evaluation = problem.evaluate(on: board, moves: moves)
    logMoveUndone(moveCount: moves.count, solved: isSolved)
  }

  private mutating func execute(move: Move) {
    board.apply(move: move)
  }

  /// Clears the board, move history, and resets the start time.
  public mutating func reset() {
    board.reset()
    moves.removeAll()
    evaluation = problem.evaluate(on: board, moves: moves)
    startedAt = .now
    logger.info("Game reset")
  }
}

// MARK: Logging
extension Game {
  private func logMoveApplied(moveCount: Int, solved: Bool) {
    logger.debug("Applied move; total moves \(moveCount), solved \(solved)")
  }

  private func logMoveUndone(moveCount: Int, solved: Bool) {
    logger.debug("Undid move; remaining moves \(moveCount), solved \(solved)")
  }
}
