import Board
import SwiftUI

public struct BoardView: View {
    private static let alphabet = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    ]

    let board: Board
    let onSquareTapped: (Position) -> Void

    public init(board: Board, onSquareTapped: @escaping (Position) -> Void) {
        precondition(
            board.size <= Self.alphabet.count,
            "BoardView supports sizes up to \(Self.alphabet.count)"
        )
        self.board = board
        self.onSquareTapped = onSquareTapped
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
        let fillColor = isLightSquare
            ? Color("BoardLight", bundle: .module)
            : Color("BoardDark", bundle: .module)
        let labelColor = isLightSquare
            ? Color("BoardDark", bundle: .module)
            : Color("BoardLight", bundle: .module)

        return Rectangle()
            .fill(fillColor)
            .overlay(alignment: .topLeading) {
                if column == 0 {
                    coordinateLabel(
                        "\(board.size - row)",
                        color: labelColor,
                        cellSide: cellSide
                    )
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if row == board.size - 1 {
                    coordinateLabel(
                        Self.alphabet[column],
                        color: labelColor,
                        cellSide: cellSide
                    )
                }
            }
            .overlay {
                if let occupant = board.squares[.init(row: row, column: column)] {
                    Image(of: occupant)
                        .resizable()
                        .scaledToFit()
                        .padding(cellSide * 0.1)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onSquareTapped(.init(row: row, column: column))
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

#Preview("8×8 empty") {
    BoardView(board: Board(size: 8)) { _ in }
}

#Preview("4×4 empty") {
    BoardView(board: Board(size: 4)) { _ in }
}
