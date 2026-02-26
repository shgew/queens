import Board

public struct QueenConflictRule: ConflictRule {
    public init() {}

    public func conflicts(on board: Board) -> Set<Position> {
        let queens = board.squares.filter { $0.value.piece == .queen }

        let diagonalCount = 2 * board.size - 1
        let diagonalOffset = board.size - 1

        var rowCounts = Array(repeating: 0, count: board.size)
        var columnCounts = Array(repeating: 0, count: board.size)
        var diagonalCounts = Array(repeating: 0, count: diagonalCount)
        var antiDiagonalCounts = Array(repeating: 0, count: diagonalCount)

        for position in queens.keys {
            rowCounts[position.row] += 1
            columnCounts[position.column] += 1
            diagonalCounts[position.row - position.column + diagonalOffset] += 1
            antiDiagonalCounts[position.row + position.column] += 1
        }

        var result: Set<Position> = []
        for position in queens.keys {
            if rowCounts[position.row] > 1
                || columnCounts[position.column] > 1
                || diagonalCounts[position.row - position.column + diagonalOffset] > 1
                || antiDiagonalCounts[position.row + position.column] > 1
            {
                result.insert(position)
            }
        }

        return result
    }
}
