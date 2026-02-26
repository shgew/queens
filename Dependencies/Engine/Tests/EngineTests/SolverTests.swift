import Board
import Testing

@testable import Engine

@Suite("Solver")
struct SolverTests {
    @Test(arguments: 4...10)
    func findsASolution(size: Int) {
        let board = Solver.solve(size: size)
        let rule = QueenConflictRule()
        #expect(board.squares.count == size)
        #expect(rule.conflicts(on: board).isEmpty)
    }

    @Test func solutionHasCorrectQueenCount() {
        let board = Solver.solve(size: 8)
        #expect(board.squares.count == 8)
    }
}
