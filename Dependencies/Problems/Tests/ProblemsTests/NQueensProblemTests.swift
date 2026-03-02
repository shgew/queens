import Board
import Problems
import Testing

struct NQueensProblemTests {
  let problem = NQueensProblem()
  let queen = Occupant(piece: .queen, side: .white)

  // MARK: - Solved

  @Test func `solved when N non-conflicting queens placed`() {
    // . Q . .
    // . . . Q
    // Q . . .
    // . . Q .
    var board = Board(size: 4)
    board.apply(move: .place(queen, at: Position(row: 0, column: 1)))
    board.apply(move: .place(queen, at: Position(row: 1, column: 3)))
    board.apply(move: .place(queen, at: Position(row: 2, column: 0)))
    board.apply(move: .place(queen, at: Position(row: 3, column: 2)))

    #expect(problem.evaluate(on: board, moves: []) == .solved)
  }

  // MARK: - Unsolved — not enough queens

  @Test func `unsolved with no conflicts when board is empty`() {
    // . . . .
    // . . . .
    // . . . .
    // . . . .
    let board = Board(size: 4)
    let evaluation = problem.evaluate(on: board, moves: [])

    #expect(evaluation == .unsolved(NQueensProblem.Diagnostic(conflicts: [])))
  }

  @Test func `unsolved with no conflicts when fewer than N queens placed`() {
    // Q . . .
    // . . . .
    // . . . .
    // . . . .
    var board = Board(size: 4)
    board.apply(move: .place(queen, at: Position(row: 0, column: 0)))

    let evaluation = problem.evaluate(on: board, moves: [])

    #expect(evaluation == .unsolved(NQueensProblem.Diagnostic(conflicts: [])))
  }

  // MARK: - Row conflict

  @Test func `detects row conflict`() {
    // Q . . Q  ← same row
    // . . . .
    // . . . .
    // . . . .
    var board = Board(size: 4)
    let a = Position(row: 0, column: 0)
    let b = Position(row: 0, column: 3)
    board.apply(move: .place(queen, at: a))
    board.apply(move: .place(queen, at: b))

    let conflicts = extractConflicts(from: problem.evaluate(on: board, moves: []))

    #expect(conflicts == [a, b])
  }

  // MARK: - Column conflict

  @Test func `detects column conflict`() {
    // . Q . .  ↕ same column
    // . . . .
    // . Q . .
    // . . . .
    var board = Board(size: 4)
    let a = Position(row: 0, column: 1)
    let b = Position(row: 2, column: 1)
    board.apply(move: .place(queen, at: a))
    board.apply(move: .place(queen, at: b))

    let conflicts = extractConflicts(from: problem.evaluate(on: board, moves: []))

    #expect(conflicts == [a, b])
  }

  // MARK: - Diagonal conflict

  @Test func `detects diagonal conflict`() {
    // Q . . .  ↘ same diagonal
    // . . . .
    // . . Q .
    // . . . .
    var board = Board(size: 4)
    let a = Position(row: 0, column: 0)
    let b = Position(row: 2, column: 2)
    board.apply(move: .place(queen, at: a))
    board.apply(move: .place(queen, at: b))

    let conflicts = extractConflicts(from: problem.evaluate(on: board, moves: []))

    #expect(conflicts == [a, b])
  }

  // MARK: - Anti-diagonal conflict

  @Test func `detects anti-diagonal conflict`() {
    // . . . Q  ↙ same anti-diagonal
    // . . . .
    // . . . .
    // Q . . .
    var board = Board(size: 4)
    let a = Position(row: 0, column: 3)
    let b = Position(row: 3, column: 0)
    board.apply(move: .place(queen, at: a))
    board.apply(move: .place(queen, at: b))

    let conflicts = extractConflicts(from: problem.evaluate(on: board, moves: []))

    #expect(conflicts == [a, b])
  }

  // MARK: - Non-conflicting queens have no conflicts

  @Test func `non-conflicting queens are not in conflict set`() {
    // . . . .
    // . . . .
    // . . Q Q  ← row conflict
    // Q . . .  ← safe
    var board = Board(size: 4)
    let safe = Position(row: 3, column: 0)
    let conflictA = Position(row: 2, column: 2)
    let conflictB = Position(row: 2, column: 3)
    board.apply(move: .place(queen, at: safe))
    board.apply(move: .place(queen, at: conflictA))
    board.apply(move: .place(queen, at: conflictB))

    let conflicts = extractConflicts(from: problem.evaluate(on: board, moves: []))

    #expect(!conflicts.contains(safe))
    #expect(conflicts.contains(conflictA))
    #expect(conflicts.contains(conflictB))
  }

  // MARK: - Single queen has no conflicts

  @Test func `single queen has no conflicts`() {
    // . . . .
    // . . Q .
    // . . . .
    // . . . .
    var board = Board(size: 4)
    board.apply(move: .place(queen, at: Position(row: 1, column: 2)))

    let conflicts = extractConflicts(from: problem.evaluate(on: board, moves: []))

    #expect(conflicts.isEmpty)
  }

  // MARK: - Full board unsolved

  @Test func `full board with conflicts is unsolved`() {
    // Q . . .  ↘ all on same diagonal
    // . Q . .
    // . . Q .
    // . . . Q
    var board = Board(size: 4)
    for i in 0..<4 {
      board.apply(move: .place(queen, at: Position(row: i, column: i)))
    }

    let evaluation = problem.evaluate(on: board, moves: [])

    #expect(evaluation != .solved)
    let conflicts = extractConflicts(from: evaluation)
    #expect(conflicts.count == 4)
  }

  // MARK: - Helpers

  private func extractConflicts(
    from evaluation: Evaluation<NQueensProblem.Diagnostic>
  ) -> Set<Position> {
    if case .unsolved(let diagnostic) = evaluation {
      return diagnostic.conflicts
    }
    return []
  }
}
