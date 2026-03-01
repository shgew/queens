import Testing

@testable import Board

struct BoardTests {
	let queen = Occupant(piece: .queen, side: .white)

	@Test func newBoardIsEmpty() {
		let board = Board(size: 4)
		#expect(board.occupiedSquares.isEmpty)
	}

	@Test func applyPlacesOccupant() {
		var board = Board(size: 4)
		let pos = Position(row: 0, column: 0)
		board.apply(move: .place(queen, at: pos))
		#expect(board.occupiedSquares[pos] == queen)
	}

	@Test func applyRemovesOccupant() {
		var board = Board(size: 4)
		let pos = Position(row: 0, column: 0)
		board.apply(move: .place(queen, at: pos))
		board.apply(move: .remove(queen, from: pos))
		#expect(board.occupiedSquares[pos] == nil)
	}

	@Test func resetClearsBoard() {
		var board = Board(size: 4)
		board.apply(move: .place(queen, at: Position(row: 0, column: 1)))
		board.apply(move: .place(queen, at: Position(row: 1, column: 3)))
		board.reset()
		#expect(board.occupiedSquares.isEmpty)
	}
}
