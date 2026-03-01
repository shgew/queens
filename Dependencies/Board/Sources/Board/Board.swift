import Foundation
import OSLog
import Logging

private let logger = Logger.queens(category: .board)

/// A square grid that maps positions to occupants.
///
/// `Board` is a general-purpose grid with no game-specific rules.
/// Conflict detection and win conditions live in higher-level modules.
public struct Board: Sendable {
  /// The smallest supported board dimension.
  public static let minimumSize = 4

  /// The number of rows (and columns) on this board.
  public let size: Int

  /// The occupied positions on the board, keyed by position.
  public private(set) var occupiedSquares: [Position: Occupant]

  /// Creates an empty board of the given size.
  ///
  /// - Precondition: `size` must be at least ``minimumSize``.
  public init(size: Int) {
    precondition(
      size >= Self.minimumSize,
      "Board size must be at least \(Self.minimumSize)"
    )
    self.size = size
    self.occupiedSquares = [:]
    logger.debug("Initialized board with size \(size)")
  }

  /// Applies a move to the board.
  ///
  /// - Precondition: The move's position must be within bounds.
  public mutating func apply(move: Move) {
    switch move {
    case .place(let occupant, at: let position):
      boundsCheck(position)
      occupiedSquares[position] = occupant
      logger.debug(
        "Placed occupant at row \(position.row), column \(position.column)"
      )
    case .remove(_, from: let position):
      boundsCheck(position)
      occupiedSquares[position] = nil
      logger.debug(
        "Removed occupant at row \(position.row), column \(position.column)"
      )
    }
  }

  private func boundsCheck(_ position: Position) {
    precondition(
      position.row >= 0
        && position.row < size
        && position.column >= 0
        && position.column < size,
      "Position out of bounds"
    )
  }

  /// Removes all occupants from the board.
  public mutating func reset() {
    occupiedSquares = [:]
    logger.info("Board reset")
  }
}
