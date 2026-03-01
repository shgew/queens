import Board
import Testing

struct MoveTests {
  let queen = Occupant(piece: .queen, side: .white)

  // MARK: - Opposite

  @Test func oppositeOfPlaceIsRemove() {
    let move = Move.place(queen, at: Position(row: 0, column: 0))
    #expect(move.opposite == .remove(queen, from: Position(row: 0, column: 0)))
  }

  @Test func oppositeOfRemoveIsPlace() {
    let move = Move.remove(queen, from: Position(row: 1, column: 2))
    #expect(move.opposite == .place(queen, at: Position(row: 1, column: 2)))
  }

  @Test func oppositeIsItsOwnInverse() {
    let moves: [Move] = [
      .place(queen, at: Position(row: 0, column: 0)),
      .remove(queen, from: Position(row: 1, column: 1)),
    ]
    for move in moves {
      #expect(move.opposite.opposite == move)
    }
  }
}
