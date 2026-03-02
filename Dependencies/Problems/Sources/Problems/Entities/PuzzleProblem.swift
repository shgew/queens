import Board

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
