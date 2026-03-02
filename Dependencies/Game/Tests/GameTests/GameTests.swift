import Board
import Foundation
import Problems
import Testing

@testable import Game

/// A stub problem that reports `.solved` when the board is empty
/// and `.unsolved` with the occupied positions otherwise.
struct StubProblem: Problem {
  func evaluate(
    on board: Board,
    moves: [Move]
  ) -> Evaluation<Set<Position>> {
    let occupied = Set(board.occupiedSquares.keys)
    return occupied.isEmpty ? .solved : .unsolved(occupied)
  }
}

struct GameTests {
  let problem = StubProblem()
  let queen = Occupant(piece: .queen, side: .white)

  @Test func `new game is solved`() {
    // . . . .
    // . . . .
    // . . . .
    // . . . .
    let game = Game(size: 4, problem: problem)
    #expect(game.isSolved)
  }

  @Test func `is solved is false after apply`() {
    // Q . . .
    // . . . .
    // . . . .
    // . . . .
    var game = Game(size: 4, problem: problem)
    game.apply(move: .place(queen, at: Position(row: 0, column: 0)))
    #expect(!game.isSolved)
  }

  @Test func `apply mutates board and re-evaluates`() {
    // . . . .
    // . . Q .
    // . . . .
    // . . . .
    var game = Game(size: 4, problem: problem)
    let pos = Position(row: 1, column: 2)
    game.apply(move: .place(queen, at: pos))

    #expect(game.board.occupiedSquares[pos] == queen)
    #expect(game.evaluation == .unsolved(Set([pos])))
  }

  @Test func `reset clears board and re-evaluates`() {
    // Q . . .    . . . .
    // . . . .    . . . .
    // . . . .  → . . . .
    // . . . .    . . . .
    var game = Game(size: 4, problem: problem)
    game.apply(move: .place(queen, at: Position(row: 0, column: 0)))
    #expect(!game.isSolved)

    game.reset()
    #expect(game.board.occupiedSquares.isEmpty)
    #expect(game.isSolved)
  }

  @Test func `reset updates started at`() async throws {
    var game = Game(size: 4, problem: problem)
    let originalStartedAt = game.startedAt

    try await Task.sleep(for: .milliseconds(50))
    game.reset()

    #expect(game.startedAt > originalStartedAt)
  }

  // MARK: - Move tracking

  @Test func `apply records move`() {
    // Q . . .
    // . . . .
    // . . . .
    // . . . .
    var game = Game(size: 4, problem: problem)
    let pos = Position(row: 0, column: 0)
    game.apply(move: .place(queen, at: pos))

    #expect(game.moves == [.place(queen, at: pos)])
  }

  @Test func `remove move recorded`() {
    // Q . . .    . . . .
    // . . . .    . . . .
    // . . . .  → . . . .
    // . . . .    . . . .
    var game = Game(size: 4, problem: problem)
    let pos = Position(row: 0, column: 0)
    game.apply(move: .place(queen, at: pos))
    game.apply(move: .remove(queen, from: pos))

    #expect(game.moves == [.place(queen, at: pos), .remove(queen, from: pos)])
    #expect(game.board.occupiedSquares.isEmpty)
  }

  // MARK: - Undo

  @Test func `undo reverses place`() {
    // . . . .    . . . .
    // . . Q .    . . . .
    // . . . .  → . . . .
    // . . . .    . . . .
    var game = Game(size: 4, problem: problem)
    let pos = Position(row: 1, column: 2)
    game.apply(move: .place(queen, at: pos))

    game.undo()

    #expect(game.board.occupiedSquares.isEmpty)
    #expect(game.moves.isEmpty)
    #expect(game.isSolved)
  }

  @Test func `undo reverses remove`() {
    // . . . .    . . . .    . . . .
    // . . Q .  → . . . .  → . . Q .
    // . . . .    . . . .    . . . .
    // . . . .    . . . .    . . . .
    var game = Game(size: 4, problem: problem)
    let pos = Position(row: 1, column: 2)
    game.apply(move: .place(queen, at: pos))
    game.apply(move: .remove(queen, from: pos))

    game.undo()

    #expect(game.board.occupiedSquares[pos] == queen)
    #expect(game.moves == [.place(queen, at: pos)])
  }

  @Test func `undo on empty moves is no-op`() {
    // . . . .
    // . . . .
    // . . . .
    // . . . .
    var game = Game(size: 4, problem: problem)
    game.undo()

    #expect(game.board.occupiedSquares.isEmpty)
    #expect(game.moves.isEmpty)
    #expect(game.isSolved)
  }

  @Test func `reset clears moves`() {
    // Q . . .    . . . .
    // . Q . .    . . . .
    // . . . .  → . . . .
    // . . . .    . . . .
    var game = Game(size: 4, problem: problem)
    game.apply(move: .place(queen, at: Position(row: 0, column: 0)))
    game.apply(move: .place(queen, at: Position(row: 1, column: 1)))

    game.reset()

    #expect(game.moves.isEmpty)
    #expect(game.board.occupiedSquares.isEmpty)
  }
}
