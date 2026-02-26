import Board

public struct Solver: Sendable {
    public static func solve(size: Int) -> Board {
        precondition(
            size >= Board.minimumSize,
            "Solver size must be at least \(Board.minimumSize)"
        )
        precondition(size <= 32, "Solver size must be at most 32")

        let queenColumns = constructSolutionColumns(size: size)
        return buildBoard(size: size, queenColumns: queenColumns)
    }

    private static func buildBoard(size: Int, queenColumns: [Int]) -> Board {
        var board = Board(size: size)
        let queen = Occupant(piece: .queen, side: .white)
        for (row, col) in queenColumns.enumerated() {
            board.toggle(queen, at: Position(row: row, column: col))
        }
        return board
    }

    private static func constructSolutionColumns(size: Int) -> [Int] {
        var evenColumns = Array(stride(from: 1, to: size, by: 2))
        var oddColumns = Array(stride(from: 0, to: size, by: 2))

        switch size % 6 {
        case 2:
            // 1-based rule: swap 1 and 3, move 5 to the end of odd columns.
            oddColumns.swapAt(0, 1)
            let fiveIndex = oddColumns.firstIndex(of: 4)!
            oddColumns.remove(at: fiveIndex)
            oddColumns.append(4)
        case 3:
            // 1-based rule: move 2 to the end of even columns, and move 1 and 3 to the end of odd columns.
            let twoIndex = evenColumns.firstIndex(of: 1)!
            evenColumns.remove(at: twoIndex)
            evenColumns.append(1)

            oddColumns.removeAll { $0 == 0 || $0 == 2 }
            oddColumns.append(0)
            oddColumns.append(2)
        default:
            break
        }

        return evenColumns + oddColumns
    }
}
