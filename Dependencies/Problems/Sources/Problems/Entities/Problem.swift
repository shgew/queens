import Board

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
