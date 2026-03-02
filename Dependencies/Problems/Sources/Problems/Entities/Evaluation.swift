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
