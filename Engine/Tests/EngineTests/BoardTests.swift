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

    @Test func togglePlacesAndRemoves() throws {
        var board = Board(size: 4)
        let pos = Position(row: 0, column: 0)
        try board.toggleQueen(at: pos)
        #expect(board.queens.contains(pos))
        try board.toggleQueen(at: pos)
        #expect(!board.queens.contains(pos))
    }

    @Test func resetClearsBoard() throws {
        var board = Board(size: 4)
        try board.toggleQueen(at: Position(row: 0, column: 1))
        try board.toggleQueen(at: Position(row: 1, column: 3))
        board.reset()
        #expect(board.queens.isEmpty)
    }

    @Test func rowConflict() throws {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 0)
        let b = Position(row: 0, column: 3)
        try board.toggleQueen(at: a)
        try board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func columnConflict() throws {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 1)
        let b = Position(row: 3, column: 1)
        try board.toggleQueen(at: a)
        try board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func diagonalConflict() throws {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 0)
        let b = Position(row: 2, column: 2)
        try board.toggleQueen(at: a)
        try board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func antiDiagonalConflict() throws {
        var board = Board(size: 4)
        let a = Position(row: 0, column: 3)
        let b = Position(row: 3, column: 0)
        try board.toggleQueen(at: a)
        try board.toggleQueen(at: b)
        let c = board.conflicts()
        #expect(c.contains(a))
        #expect(c.contains(b))
    }

    @Test func noConflictForValidPlacement() throws {
        var board = Board(size: 4)
        try board.toggleQueen(at: Position(row: 0, column: 1))
        try board.toggleQueen(at: Position(row: 1, column: 3))
        #expect(board.conflicts().isEmpty)
    }

    @Test func solvedBoardIsRecognised() throws {
        var board = Board(size: 4)
        try board.toggleQueen(at: Position(row: 0, column: 1))
        try board.toggleQueen(at: Position(row: 1, column: 3))
        try board.toggleQueen(at: Position(row: 2, column: 0))
        try board.toggleQueen(at: Position(row: 3, column: 2))
        #expect(board.isSolved())
    }

    @Test func boardFullThrows() throws {
        var board = Board(size: 4)
        try board.toggleQueen(at: Position(row: 0, column: 1))
        try board.toggleQueen(at: Position(row: 1, column: 3))
        try board.toggleQueen(at: Position(row: 2, column: 0))
        try board.toggleQueen(at: Position(row: 3, column: 2))
        #expect(throws: Board.Error.boardFull) {
            try board.toggleQueen(at: Position(row: 0, column: 0))
        }
    }
}
