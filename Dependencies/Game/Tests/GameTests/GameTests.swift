import Board
import Engine
import Foundation
import Testing

@testable import Game

/// A stub problem that reports `.solved` when the board is empty
/// and `.unsolved` with the occupied positions otherwise.
struct StubProblem: Problem {
    func evaluate(_ board: Board) -> Evaluation<Set<Position>> {
        let occupied = Set(board.squares.keys)
        return occupied.isEmpty ? .solved : .unsolved(occupied)
    }
}

@Suite("Game")
struct GameTests {
    let problem = StubProblem()
    let queen = Occupant(piece: .queen, side: .white)

    @Test func newGameIsSolved() {
        let game = Game(size: 4, problem: problem)
        #expect(game.isSolved)
    }

    @Test func isSolvedIsFalseAfterApply() {
        var game = Game(size: 4, problem: problem)
        game.apply { $0.toggle(Occupant(piece: .queen, side: .white), at: Position(row: 0, column: 0)) }
        #expect(!game.isSolved)
    }

    @Test func applyMutatesBoardAndReEvaluates() {
        var game = Game(size: 4, problem: problem)
        let pos = Position(row: 1, column: 2)
        game.apply { $0.toggle(Occupant(piece: .queen, side: .white), at: pos) }

        #expect(game.board.squares[pos] == queen)
        #expect(game.evaluation == .unsolved(Set([pos])))
    }

    @Test func resetClearsBoardAndReEvaluates() {
        var game = Game(size: 4, problem: problem)
        game.apply { $0.toggle(Occupant(piece: .queen, side: .white), at: Position(row: 0, column: 0)) }
        #expect(!game.isSolved)

        game.reset()
        #expect(game.board.squares.isEmpty)
        #expect(game.isSolved)
    }

    @Test func resetUpdatesStartedAt() async throws {
        var game = Game(size: 4, problem: problem)
        let originalStartedAt = game.startedAt

        try await Task.sleep(for: .milliseconds(50))
        game.reset()

        #expect(game.startedAt > originalStartedAt)
    }
}
