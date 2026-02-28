import Board
import Problems
import Foundation
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

    @Test func newGameIsSolved() {
        let game = Game(size: 4, problem: problem)
        #expect(game.isSolved)
    }

    @Test func isSolvedIsFalseAfterApply() {
        var game = Game(size: 4, problem: problem)
        game.apply(move: .placed(Occupant(piece: .queen, side: .white), at: Position(row: 0, column: 0)))
        #expect(!game.isSolved)
    }

    @Test func applyMutatesBoardAndReEvaluates() {
        var game = Game(size: 4, problem: problem)
        let pos = Position(row: 1, column: 2)
        game.apply(move: .placed(queen, at: pos))

        #expect(game.board.occupiedSquares[pos] == queen)
        #expect(game.evaluation == .unsolved(Set([pos])))
    }

    @Test func resetClearsBoardAndReEvaluates() {
        var game = Game(size: 4, problem: problem)
        game.apply(move: .placed(queen, at: Position(row: 0, column: 0)))
        #expect(!game.isSolved)

        game.reset()
        #expect(game.board.occupiedSquares.isEmpty)
        #expect(game.isSolved)
    }

    @Test func resetUpdatesStartedAt() async throws {
        var game = Game(size: 4, problem: problem)
        let originalStartedAt = game.startedAt

        try await Task.sleep(for: .milliseconds(50))
        game.reset()

        #expect(game.startedAt > originalStartedAt)
    }

    // MARK: - Move tracking

    @Test func applyRecordsMove() {
        var game = Game(size: 4, problem: problem)
        let pos = Position(row: 0, column: 0)
        game.apply(move: .placed(queen, at: pos))

        #expect(game.moves == [.placed(queen, at: pos)])
    }

    @Test func removeMoveRecorded() {
        var game = Game(size: 4, problem: problem)
        let pos = Position(row: 0, column: 0)
        game.apply(move: .placed(queen, at: pos))
        game.apply(move: .removed(queen, from: pos))

        #expect(game.moves == [.placed(queen, at: pos), .removed(queen, from: pos)])
        #expect(game.board.occupiedSquares.isEmpty)
    }

    // MARK: - Undo

    @Test func undoReversesPlace() {
        var game = Game(size: 4, problem: problem)
        let pos = Position(row: 1, column: 2)
        game.apply(move: .placed(queen, at: pos))

        game.undo()

        #expect(game.board.occupiedSquares.isEmpty)
        #expect(game.moves.isEmpty)
        #expect(game.isSolved)
    }

    @Test func undoReversesRemove() {
        var game = Game(size: 4, problem: problem)
        let pos = Position(row: 1, column: 2)
        game.apply(move: .placed(queen, at: pos))
        game.apply(move: .removed(queen, from: pos))

        game.undo()

        #expect(game.board.occupiedSquares[pos] == queen)
        #expect(game.moves == [.placed(queen, at: pos)])
    }

    @Test func undoOnEmptyMovesIsNoOp() {
        var game = Game(size: 4, problem: problem)
        game.undo()

        #expect(game.board.occupiedSquares.isEmpty)
        #expect(game.moves.isEmpty)
        #expect(game.isSolved)
    }

    @Test func resetClearsMoves() {
        var game = Game(size: 4, problem: problem)
        game.apply(move: .placed(queen, at: Position(row: 0, column: 0)))
        game.apply(move: .placed(queen, at: Position(row: 1, column: 1)))

        game.reset()

        #expect(game.moves.isEmpty)
        #expect(game.board.occupiedSquares.isEmpty)
    }

}
