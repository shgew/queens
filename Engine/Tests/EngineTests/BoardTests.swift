import Testing

@testable import Engine

@Suite("Board")
struct BoardTests {
    @Test func newBoardIsEmpty() {
        let board = Board(size: 4)
        #expect(board.queens.isEmpty)
        #expect(board.queensRemaining == 4)
        #expect(!board.isSolved())
    }

    @Test func togglePlacesAndRemoves() {
        var board = Board(size: 4)
        let pos = Position(row: 0, column: 0)
        board.toggleQueen(at: pos)
        #expect(board.queens.contains(pos))
        board.toggleQueen(at: pos)
        #expect(!board.queens.contains(pos))
    }

    @Test func resetClearsBoard() {
        var board = Board(size: 4)
        board.toggleQueen(at: Position(row: 0, column: 1))
        board.toggleQueen(at: Position(row: 1, column: 3))
        board.reset()
        #expect(board.queens.isEmpty)
    }

    @Test func rowConflict() {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 0)
        let b = Position(row: 0, column: 3)
        board.toggleQueen(at: a)
        board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func columnConflict() {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 1)
        let b = Position(row: 3, column: 1)
        board.toggleQueen(at: a)
        board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func diagonalConflict() {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 0)
        let b = Position(row: 2, column: 2)
        board.toggleQueen(at: a)
        board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func antiDiagonalConflict() {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 3)
        let b = Position(row: 3, column: 0)
        board.toggleQueen(at: a)
        board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func noConflictForValidPlacement() {
        var board = Board(size: 4)
        board.toggleQueen(at: Position(row: 0, column: 1))
        board.toggleQueen(at: Position(row: 1, column: 3))
        #expect(board.conflicts().isEmpty)
    }

    @Test func solvedBoardIsRecognised() {
        var board = Board(size: 4)
        board.toggleQueen(at: Position(row: 0, column: 1))
        board.toggleQueen(at: Position(row: 1, column: 3))
        board.toggleQueen(at: Position(row: 2, column: 0))
        board.toggleQueen(at: Position(row: 3, column: 2))
        #expect(board.isSolved())
    }
}
