import Board
import Testing

struct MoveTests {
    let queen = Occupant(piece: .queen, side: .white)

    // MARK: - Opposite

    @Test func oppositeOfPlacedIsRemoved() {
        let move = Move.placed(queen, at: Position(row: 0, column: 0))
        #expect(move.opposite == .removed(queen, from: Position(row: 0, column: 0)))
    }

    @Test func oppositeOfRemovedIsPlaced() {
        let move = Move.removed(queen, from: Position(row: 1, column: 2))
        #expect(move.opposite == .placed(queen, at: Position(row: 1, column: 2)))
    }

    @Test func oppositeIsItsOwnInverse() {
        let moves: [Move] = [
            .placed(queen, at: Position(row: 0, column: 0)),
            .removed(queen, from: Position(row: 1, column: 1)),
        ]
        for move in moves {
            #expect(move.opposite.opposite == move)
        }
    }
}
