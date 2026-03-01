/// A piece together with the side it belongs to.
///
/// An occupant represents what is placed on a single square of a ``Board``.
public struct Occupant: Hashable, Sendable {
  /// The kind of piece.
  public var piece: Piece

  /// The side (color) this piece belongs to.
  public var side: Side

  /// Creates an occupant with the given piece and side.
  public init(piece: Piece, side: Side) {
    self.piece = piece
    self.side = side
  }
}
