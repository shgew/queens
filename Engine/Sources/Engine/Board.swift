public struct Board: Sendable {
    public enum Error: Swift.Error {
        case boardFull
    }

    public static let minimumSize = 4

    public let size: Int
    public private(set) var queens: Set<Position>

    public init(size: Int) {
        precondition(
            size >= Self.minimumSize,
            "Board size must be at least \(Self.minimumSize)"
        )
        self.size = size
        self.queens = []
    }

    public var queensRemaining: Int {
        size - queens.count
    }

    public mutating func toggleQueen(at position: Position) throws(Error) {
        precondition(
            position.row >= 0
                && position.row < size
                && position.column >= 0
                && position.column < size,
            "Position out of bounds"
        )

        if queens.contains(position) {
            queens.remove(position)
        } else {
            guard queens.count < size else {
                throw Error.boardFull
            }
            queens.insert(position)
        }
    }

    public func conflicts() -> Set<Position> {
        let diagonalCount = 2 * size - 1
        let diagonalOffset = size - 1

        var rowCounts = Array(repeating: 0, count: size)
        var columnCounts = Array(repeating: 0, count: size)
        var diagonalCounts = Array(repeating: 0, count: diagonalCount)
        var antiDiagonalCounts = Array(repeating: 0, count: diagonalCount)

        for queen in queens {
            rowCounts[queen.row] += 1
            columnCounts[queen.column] += 1
            diagonalCounts[queen.row - queen.column + diagonalOffset] += 1
            antiDiagonalCounts[queen.row + queen.column] += 1
        }

        var result: Set<Position> = []
        for queen in queens {
            if rowCounts[queen.row] > 1
                || columnCounts[queen.column] > 1
                || diagonalCounts[queen.row - queen.column + diagonalOffset] > 1
                || antiDiagonalCounts[queen.row + queen.column] > 1
            {
                result.insert(queen)
            }
        }

        return result
    }

    public func isSolved() -> Bool {
        queens.count == size && conflicts().isEmpty
    }

    public mutating func reset() {
        queens = []
    }
}
