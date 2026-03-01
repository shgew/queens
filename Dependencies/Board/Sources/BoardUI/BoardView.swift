import Board
import Logging
import OSLog
import SwiftUI

private let logger = Logger.queens(category: .ui)

/// A chess-style board that displays pieces on an alternating grid.
///
/// The board renders row numbers along the left edge and column letters along
/// the bottom edge. Supports sizes up to 32 (a–z, then A–F).
///
/// Use modifier-style methods to handle taps and highlight conflicting cells:
///
/// ```swift
/// BoardView(board: board)
///     .onSquareTapped { position in
///         // handle tap
///     }
///     .cellState { position in
///         conflicts.contains(position) ? .conflicting : .normal
///     }
/// ```
public struct BoardView: View {
  private static let columnLabels = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
    "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F",
  ]

  /// The visual state of a cell on the board.
  public enum CellState {
    /// Default appearance.
    case normal
    /// Highlights the cell's occupant with a red tinted overlay.
    case conflicting
  }

  let board: Board
  private var squareTapHandler: (Position) -> Void = { _ in }
  private var cellStateProvider: (Position) -> CellState = { _ in .normal }

  /// Creates a board view for the provided board state.
  ///
  /// - Parameter board: The board to render.
  public init(board: Board) {
    precondition(
      board.size <= Self.columnLabels.count,
      "BoardView supports sizes up to \(Self.columnLabels.count)"
    )
    self.board = board
  }

  /// Returns a copy that invokes the action when a square is tapped.
  ///
  /// - Parameter action: A handler receiving the tapped position.
  /// - Returns: A configured board view.
  public func onSquareTapped(_ action: @escaping (Position) -> Void) -> Self {
    var copy = self
    copy.squareTapHandler = action
    return copy
  }

  /// Returns a copy that derives per-cell visual state.
  ///
  /// - Parameter state: A closure mapping positions to cell states.
  /// - Returns: A configured board view.
  public func cellState(_ state: @escaping (Position) -> CellState) -> Self {
    var copy = self
    copy.cellStateProvider = state
    return copy
  }

  /// The rendered board layout.
  public var body: some View {
    GeometryReader { proxy in
      let cellSide = proxy.size.width / CGFloat(board.size)

      VStack(spacing: 0) {
        ForEach(0..<board.size, id: \.self) { row in
          HStack(spacing: 0) {
            ForEach(0..<board.size, id: \.self) { column in
              square(row: row, column: column, cellSide: cellSide)
            }
          }
        }
      }
    }
    .aspectRatio(contentMode: .fit)
  }

  private func square(row: Int, column: Int, cellSide: CGFloat) -> some View {
    let isLightSquare = row.isMultiple(of: 2) == column.isMultiple(of: 2)
    let position = Position(row: row, column: column)

    return SquareView(cellSide: cellSide)
      .fillColor(isLightSquare ? Color(.boardLight) : Color(.boardDark))
      .labelColor(isLightSquare ? Color(.boardDark) : Color(.boardLight))
      .topLeadingText(
        column == 0 ? "\(board.size - row)" : nil
      )
      .bottomTrailingText(
        row == board.size - 1 ? Self.columnLabels[column] : nil
      )
      .occupant(board.occupiedSquares[position])
      .conflicting(cellStateProvider(position) == .conflicting)
      .contentShape(Rectangle())
      .onTapGesture {
        logger.debug(
          "Tapped square row \(position.row), column \(position.column)"
        )
        squareTapHandler(position)
      }
  }
}

// MARK: - Previews
#Preview("8×8 solved queens") {
  BoardView(board: .preview8x8Solution)
}

#Preview("4×4 solved queens") {
  BoardView(board: .preview4x4Solution)
}

#Preview("8×8 mixed pieces") {
  BoardView(board: .preview8x8Mixed)
}

#Preview("8×8 conflicts highlighted") {
  let conflicts: Set<Position> = [
    .init(row: 0, column: 0),
    .init(row: 0, column: 4),
    .init(row: 3, column: 3),
    .init(row: 6, column: 0),
  ]

  return BoardView(board: .preview8x8ConflictingQueens)
    .cellState { position in
      conflicts.contains(position) ? .conflicting : .normal
    }
}

extension Board {
  fileprivate static let preview4x4Solution = board(
    size: 4,
    occupants: [
      (.init(row: 0, column: 1), .init(piece: .queen, side: .white)),
      (.init(row: 1, column: 3), .init(piece: .queen, side: .white)),
      (.init(row: 2, column: 0), .init(piece: .queen, side: .white)),
      (.init(row: 3, column: 2), .init(piece: .queen, side: .white)),
    ]
  )

  fileprivate static let preview8x8Solution = board(
    size: 8,
    occupants: [
      (.init(row: 0, column: 0), .init(piece: .queen, side: .white)),
      (.init(row: 1, column: 4), .init(piece: .queen, side: .white)),
      (.init(row: 2, column: 7), .init(piece: .queen, side: .white)),
      (.init(row: 3, column: 5), .init(piece: .queen, side: .white)),
      (.init(row: 4, column: 2), .init(piece: .queen, side: .white)),
      (.init(row: 5, column: 6), .init(piece: .queen, side: .white)),
      (.init(row: 6, column: 1), .init(piece: .queen, side: .white)),
      (.init(row: 7, column: 3), .init(piece: .queen, side: .white)),
    ]
  )

  fileprivate static let preview8x8Mixed = board(
    size: 8,
    occupants: [
      (.init(row: 0, column: 3), .init(piece: .queen, side: .black)),
      (.init(row: 1, column: 6), .init(piece: .queen, side: .white)),
      (.init(row: 3, column: 1), .init(piece: .queen, side: .black)),
      (.init(row: 4, column: 4), .init(piece: .queen, side: .white)),
      (.init(row: 6, column: 2), .init(piece: .queen, side: .black)),
    ]
  )

  fileprivate static let preview8x8ConflictingQueens = board(
    size: 8,
    occupants: [
      (.init(row: 0, column: 0), .init(piece: .queen, side: .white)),
      (.init(row: 0, column: 4), .init(piece: .queen, side: .white)),
      (.init(row: 3, column: 3), .init(piece: .queen, side: .black)),
      (.init(row: 6, column: 0), .init(piece: .queen, side: .black)),
      (.init(row: 7, column: 5), .init(piece: .queen, side: .white)),
    ]
  )

  fileprivate static func board(size: Int, occupants: [(Position, Occupant)])
    -> Board
  {
    var board = Board(size: size)
    for (position, occupant) in occupants {
      board.apply(move: .place(occupant, at: position))
    }
    return board
  }
}
