import Engine
import SwiftUI

struct BoardView: View {
    private static let alphabet = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    ]

    let model: BoardViewModel

    init(model: BoardViewModel) {
        precondition(
            model.board.size <= Self.alphabet.count,
            "BoardView supports sizes up to \(Self.alphabet.count)"
        )
        self.model = model
    }

    var body: some View {
        GeometryReader { proxy in
            let cellSide = proxy.size.width / CGFloat(model.board.size)

            VStack(spacing: 0) {
                ForEach(0..<model.board.size, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<model.board.size, id: \.self) { column in
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
        let fillColor = isLightSquare ? Color.boardLight : Color.boardDark
        let labelColor = isLightSquare ? Color.boardDark : Color.boardLight

        return Rectangle()
            .fill(fillColor)
            .overlay(alignment: .topLeading) {
                if column == 0 {
                    coordinateLabel(
                        "\(model.board.size - row)",
                        color: labelColor,
                        cellSide: cellSide
                    )
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if row == model.board.size - 1 {
                    coordinateLabel(
                        Self.alphabet[column],
                        color: labelColor,
                        cellSide: cellSide
                    )
                }
            }
            .overlay {
                if model.board.queens.contains(.init(row: row, column: column)) {
                    Image(.blackQueen)
                        .resizable()
                        .scaledToFit()
                        .padding(cellSide * 0.1)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                model.squareTapped(.init(row: row, column: column))
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

#Preview {
    BoardView(model: BoardViewModel(size: 8))
}

#Preview {
    BoardView(model: BoardViewModel(size: 4))
}
