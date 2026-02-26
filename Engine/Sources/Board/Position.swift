/// A zero-indexed row/column coordinate on a ``Board``.
public struct Position: Hashable, Sendable {
    /// The row index, starting from `0` at the top.
    public var row: Int

    /// The column index, starting from `0` at the left.
    public var column: Int

    /// Creates a position with the given row and column.
    public init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }
}
