import Engine
import XCTest

final class BoardBenchmarks: XCTestCase {
    func testConflictsOn8x8() throws {
        var board = Board(size: 8)
        for col in 0..<8 {
            try board.toggleQueen(at: Position(row: col, column: col))
        }
        measure { _ = board.conflicts() }
    }

    func testConflictsOn16x16() throws {
        var board = Board(size: 16)
        for col in 0..<16 {
            try board.toggleQueen(at: Position(row: col, column: col))
        }
        measure { _ = board.conflicts() }
    }
}
