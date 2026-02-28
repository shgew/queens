import Board

/// The result of evaluating a board against a ``Problem``.
///
/// - ``solved``: The board satisfies all constraints.
/// - ``unsolved(_:)``: The board violates one or more constraints,
///   with a diagnostic describing what went wrong.
public enum Evaluation<Diagnostic: Sendable>: Sendable {
    case solved
    case unsolved(Diagnostic)
}

extension Evaluation: Equatable where Diagnostic: Equatable {}

/// A puzzle that can be evaluated against a ``Board``.
///
/// Conforming types define what it means for a board to be solved and produce
/// a `Diagnostic` describing any violations when it is not.
public protocol Problem<Diagnostic>: Sendable {
    associatedtype Diagnostic: Sendable

    /// Evaluates the board and returns whether it is solved.
    ///
    /// - Parameter board: The board to evaluate.
    /// - Returns: ``Evaluation/solved`` when all constraints are satisfied,
    ///   or ``Evaluation/unsolved(_:)`` with a diagnostic otherwise.
    func evaluate(_ board: Board) -> Evaluation<Diagnostic>
}
