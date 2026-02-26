import Testing

@testable import Engine

@Suite("Solver")
struct SolverTests {
    @Test(arguments: 4...10)
    func findsASolution(size: Int) {
        let board = Solver.solve(size: size)
        #expect(board.isSolved())
    }

    @Test func solutionHasCorrectQueenCount() {
        let board = Solver.solve(size: 8)
        #expect(board.queens.count == 8)
    }
}
