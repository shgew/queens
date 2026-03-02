import Board

/// The result of evaluating a board against a ``Problem``.
///
/// - ``solved``: The board satisfies all constraints.
/// - ``unsolved(_:)``: The board violates one or more constraints,
///   with a diagnostic describing what went wrong.
public enum Evaluation<Diagnostic: Sendable>: Sendable {
  /// The board satisfies all constraints.
  case solved
  /// The board is not solved and includes diagnostic details.
  case unsolved(Diagnostic)
}

extension Evaluation: Equatable where Diagnostic: Equatable {}

/// A puzzle that can be evaluated against a ``Board``.
///
/// Conforming types define what it means for a board to be solved and produce
/// a `Diagnostic` describing any violations when it is not.
public protocol Problem<Diagnostic>: Sendable {
  /// Diagnostic details produced when evaluation is unsolved.
  associatedtype Diagnostic: Sendable

  /// Evaluates the board and returns whether it is solved.
  ///
  /// - Parameters:
  ///   - board: The board to evaluate.
  ///   - moves: The sequence of moves that produced the current board state.
  /// - Returns: ``Evaluation/solved`` when all constraints are satisfied,
  ///   or ``Evaluation/unsolved(_:)`` with a diagnostic otherwise.
  func evaluate(
    on board: Board,
    moves: [Move]
  ) -> Evaluation<Diagnostic>
}

/// A diagnostic that can report conflicting positions on the board.
public protocol ConflictDiagnosing: Sendable, Equatable {
  /// Positions involved in at least one conflict.
  var conflicts: Set<Position> { get }
}

/// A ``Problem`` suitable for driving a puzzle UI.
///
/// Bundles the metadata the view model needs: board sizes, which piece to
/// place, and a no-argument initializer.
public protocol PuzzleProblem: Problem where Diagnostic: ConflictDiagnosing {
  /// The board sizes this problem supports.
  static var supportedBoardSizes: ClosedRange<Int> { get }
  /// The occupant placed on the board when the user taps a square.
  static var occupant: Occupant { get }
  /// Creates a new problem evaluator.
  init()
}
