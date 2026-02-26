import Board
import Engine
import XCTest

final class BoardBenchmarks: XCTestCase {
    func testConflictsOn8x8() {
        var board = Board(size: 8)
        let queen = Occupant(piece: .queen, side: .white)
        for col in 0..<8 {
            board.toggle(queen, at: Position(row: col, column: col))
        }
        let rule = QueenConflictRule()
        measure { _ = rule.conflicts(on: board) }
    }

    func testConflictsOn16x16() {
        var board = Board(size: 16)
        let queen = Occupant(piece: .queen, side: .white)
        for col in 0..<16 {
            board.toggle(queen, at: Position(row: col, column: col))
        }
        let rule = QueenConflictRule()
        measure { _ = rule.conflicts(on: board) }
    }
}
