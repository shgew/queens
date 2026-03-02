import Board
import Problems

/// A trivial ``PuzzleProblem`` for testing the generic ``PuzzleViewModel``.
///
/// - Uses `.queen` / `.black` to distinguish from `NQueensProblem`'s `.white`.
/// - Uses `2...4` to prove the ViewModel reads `supportedBoardSizes` from `P`.
/// - Reports no conflicts; solved once *N* pieces are placed.
struct StubProblem: PuzzleProblem {
  static let supportedBoardSizes = 2...4
  static let occupant = Occupant(piece: .queen, side: .black)

  struct Diagnostic: ConflictDiagnosing {
    let conflicts: Set<Position>
  }

  init() {}

  func evaluate(
    on board: Board,
    moves: [Move]
  ) -> Evaluation<Diagnostic> {
    if board.occupiedSquares.count == board.size {
      return .solved
    }
    return .unsolved(Diagnostic(conflicts: []))
  }
}
