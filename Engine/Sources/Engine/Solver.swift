public struct Solver: Sendable {
    public static func solve(size: Int) -> Board {
        precondition(
            size >= Board.minimumSize,
            "Solver size must be at least \(Board.minimumSize)"
        )

        let diagonalCount = 2 * size - 1
        var usedColumns = Array(repeating: false, count: size)
        var usedDiagonals = Array(repeating: false, count: diagonalCount)
        var usedAntiDiagonals = Array(repeating: false, count: diagonalCount)
        var queenColumns = Array(repeating: 0, count: size)

        guard
            placeQueens(
                row: 0,
                size: size,
                usedColumns: &usedColumns,
                usedDiagonals: &usedDiagonals,
                usedAntiDiagonals: &usedAntiDiagonals,
                queenColumns: &queenColumns
            )
        else {
            preconditionFailure("No solution exists for board size \(size)")
        }

        var board = Board(size: size)
        for (row, col) in queenColumns.enumerated() {
            board.toggleQueen(at: Position(row: row, column: col))
        }
        return board
    }

    private static func placeQueens(
        row: Int,
        size: Int,
        usedColumns: inout [Bool],
        usedDiagonals: inout [Bool],
        usedAntiDiagonals: inout [Bool],
        queenColumns: inout [Int]
    ) -> Bool {
        if row == size { return true }

        let diagonalOffset = size - 1
        for col in 0..<size {
            let diagonalIndex = row - col + diagonalOffset
            let antiDiagonalIndex = row + col
            if usedColumns[col] || usedDiagonals[diagonalIndex]
                || usedAntiDiagonals[antiDiagonalIndex]
            {
                continue
            }

            usedColumns[col] = true
            usedDiagonals[diagonalIndex] = true
            usedAntiDiagonals[antiDiagonalIndex] = true
            queenColumns[row] = col

            if placeQueens(
                row: row + 1,
                size: size,
                usedColumns: &usedColumns,
                usedDiagonals: &usedDiagonals,
                usedAntiDiagonals: &usedAntiDiagonals,
                queenColumns: &queenColumns
            ) {
                return true
            }

            usedColumns[col] = false
            usedDiagonals[diagonalIndex] = false
            usedAntiDiagonals[antiDiagonalIndex] = false
        }
        return false
    }
}
