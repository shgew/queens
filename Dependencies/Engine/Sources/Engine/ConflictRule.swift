import Board

public protocol ConflictRule: Sendable {
    func conflicts(on board: Board) -> Set<Position>
}
