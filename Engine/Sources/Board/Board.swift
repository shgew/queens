/// A square grid that maps positions to occupants.
///
/// `Board` is a general-purpose grid with no game-specific rules.
/// Conflict detection and win conditions live in higher-level modules.
public struct Board: Sendable {
    /// The smallest supported board dimension.
    public static let minimumSize = 4

    /// The number of rows (and columns) on this board.
    public let size: Int

    /// The current contents of the board, keyed by position.
    public private(set) var squares: [Position: Occupant]

    /// Creates an empty board of the given size.
    ///
    /// - Precondition: `size` must be at least ``minimumSize``.
    public init(size: Int) {
        precondition(
            size >= Self.minimumSize,
            "Board size must be at least \(Self.minimumSize)"
        )
        self.size = size
        self.squares = [:]
    }

    /// Places or removes an occupant at the given position.
    ///
    /// If the square already contains the same occupant, it is removed.
    /// Otherwise the occupant is placed (replacing any existing occupant).
    ///
    /// - Precondition: `position` must be within bounds.
    public mutating func toggle(_ occupant: Occupant, at position: Position) {
        precondition(
            position.row >= 0
                && position.row < size
                && position.column >= 0
                && position.column < size,
            "Position out of bounds"
        )

        if squares[position] == occupant {
            squares.removeValue(forKey: position)
        } else {
            squares[position] = occupant
        }
    }

    /// Removes all occupants from the board.
    public mutating func reset() {
        squares = [:]
    }
}
