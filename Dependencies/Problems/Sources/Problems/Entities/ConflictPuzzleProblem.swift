import Board
import Logging
import OSLog

private let logger = Logger.queens(category: .problems)

protocol ConflictPuzzleProblem: PuzzleProblem where Diagnostic == ConflictDiagnostic {
  static var problemName: String { get }
  static var pieceLabelPlural: String { get }
  func computeConflicts(on board: Board) -> Set<Position>
}

extension ConflictPuzzleProblem {
  public func evaluate(
    on board: Board,
    moves: [Move]
  ) -> Evaluation<Diagnostic> {
    precondition(Self.supportedBoardSizes.contains(board.size), "Unsupported board size")

    let conflicts = computeConflicts(on: board)
    if conflicts.isEmpty && board.occupiedSquares.count == board.size {
      logger.info(
        "Solved \(Self.problemName) for board size \(board.size) after \(moves.count) moves"
      )
      return .solved
    }
    logger.debug(
      "Evaluated board size \(board.size): \(Self.pieceLabelPlural) \(board.occupiedSquares.count), conflicts \(conflicts.count)"
    )
    if !conflicts.isEmpty {
      logger.debug(
        "Conflict positions: \(conflicts.sorted())"
      )
    }
    return .unsolved(ConflictDiagnostic(conflicts: conflicts))
  }
}
