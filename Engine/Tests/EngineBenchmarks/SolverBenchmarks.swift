import Engine
import XCTest

final class SolverBenchmarks: XCTestCase {
    func testSolve4() {
        measure { _ = Solver.solve(size: 4) }
    }

    func testSolve8() {
        measure { _ = Solver.solve(size: 8) }
    }

    func testSolve12() {
        measure { _ = Solver.solve(size: 12) }
    }

    func testSolve16() {
        measure { _ = Solver.solve(size: 16) }
    }
}
