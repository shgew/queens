/// A discrete change to a ``Board``.
///
/// Each case explicitly describes what happened, allowing move history
/// to be recorded and undone without diffing.
public enum Move: Sendable, Equatable {
    case placed(Occupant, at: Position)
    case removed(Occupant, from: Position)
    case moved(Occupant, from: Position, to: Position)

    /// The move that reverses the effect of this one.
    public var opposite: Move {
        switch self {
        case .placed(let occupant, at: let position):
            .removed(occupant, from: position)
        case .removed(let occupant, from: let position):
            .placed(occupant, at: position)
        case .moved(let occupant, from: let origin, to: let destination):
            .moved(occupant, from: destination, to: origin)
        }
    }
}
