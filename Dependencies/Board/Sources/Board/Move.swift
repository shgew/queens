/// A discrete change to a ``Board``.
///
/// Each case explicitly describes what happened, allowing move history
/// to be recorded and undone without diffing.
public enum Move: Sendable, Equatable {
  case place(Occupant, at: Position)
  case remove(Occupant, from: Position)

  /// The move that reverses the effect of this one.
  public var opposite: Move {
    switch self {
    case .place(let occupant, at: let position):
      .remove(occupant, from: position)
    case .remove(let occupant, from: let position):
      .place(occupant, at: position)
    }
  }
}
