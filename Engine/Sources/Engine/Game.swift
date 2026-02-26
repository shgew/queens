public struct Game {
    public private(set) var board: Board
    public private(set) var phase: Phase

    public enum Phase: Sendable {
        case idle
        case playing
        case won
    }

    public init(size: Int = 8) {
        precondition(
            size >= Board.minimumSize,
            "Game size must be at least \(Board.minimumSize)"
        )
        self.board = Board(size: size)
        self.phase = .idle
    }

    public mutating func start() {
        phase = .playing
    }

    public mutating func toggleQueen(at position: Position) throws {
        guard phase == .playing else { return }
        try board.toggleQueen(at: position)
        if board.isSolved() {
            phase = .won
        }
    }

    public mutating func reset() {
        board.reset()
        phase = .idle
    }
}
