import Board

/// A diagnostic that can report conflicting positions on the board.
public protocol ConflictDiagnosing: Sendable, Equatable {
  /// Positions involved in at least one conflict.
  var conflicts: Set<Position> { get }
}

/// Diagnostic details for puzzles whose violations are conflict positions.
public struct ConflictDiagnostic: ConflictDiagnosing {
  public let conflicts: Set<Position>

  public init(conflicts: Set<Position>) {
    self.conflicts = conflicts
  }
}
