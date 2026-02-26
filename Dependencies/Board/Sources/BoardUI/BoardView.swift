import Board
import SwiftUI

public struct BoardView: View {
    private static let alphabet = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    ]

    public enum CellState: Sendable {
        case normal
        case conflicting
    }

    let board: Board
    private var squareTapHandler: (Position) -> Void = { _ in }
    private var cellStateProvider: (Position) -> CellState = { _ in .normal }

    public init(board: Board) {
        precondition(
            board.size <= Self.alphabet.count,
            "BoardView supports sizes up to \(Self.alphabet.count)"
        )
        self.board = board
    }

    public func onSquareTapped(_ action: @escaping (Position) -> Void) -> Self {
        var copy = self
        copy.squareTapHandler = action
        return copy
    }

    public func cellState(_ state: @escaping (Position) -> CellState) -> Self {
        var copy = self
        copy.cellStateProvider = state
        return copy
    }

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
        let fillColor = isLightSquare ? Color(.boardLight) : Color(.boardDark)
        let labelColor = isLightSquare ? Color(.boardDark) : Color(.boardLight)

        let position = Position(row: row, column: column)

        return ZStack {
            Rectangle()
                .fill(fillColor)

            if column == 0 {
                coordinateLabel(
                    "\(board.size - row)",
                    color: labelColor,
                    cellSide: cellSide
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }

            if row == board.size - 1 {
                coordinateLabel(
                    Self.alphabet[column],
                    color: labelColor,
                    cellSide: cellSide
                )
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottomTrailing
                )
            }

            if let occupant = board.squares[position] {
                let image = Image(of: occupant)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                image
                    .overlay {
                        if cellStateProvider(position) == .conflicting {
                            Color.red.opacity(0.4)
                                .mask { image }
                        }
                    }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            squareTapHandler(position)
        }
    }

    private func coordinateLabel(
        _ text: String,
        color: Color,
        cellSide: CGFloat
    ) -> some View {
        let fontSize = cellSide * 0.25
        let horizontalPadding = cellSide * 0.04
        let verticalPadding = horizontalPadding / 2

        return Text(text)
            .font(
                .system(
                    size: fontSize,
                    weight: .semibold,
                    design: .monospaced
                )
            )
            .foregroundStyle(color)
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
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
            board.toggle(occupant, at: position)
        }
        return board
    }
}
