import Engine
import SwiftUI

struct BoardView: View {
    private static let alphabet = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    ]

    let size: Int
    let queens: Set<Position> = [
        .init(row: 0, column: 7), .init(row: 7, column: 3),
    ]

    init(size: Int) {
        precondition(size >= 4, "BoardView size must be at least 4")
        precondition(
            size <= Self.alphabet.count,
            "BoardView supports sizes up to \(Self.alphabet.count)"
        )
        self.size = size
    }

    var body: some View {
        GeometryReader { proxy in
            let cellSide = proxy.size.width / Double(size)

            VStack(spacing: 0) {
                ForEach(0..<size, id: \.self) { row in
                    HStack(spacing: 0) {
                        ForEach(0..<size, id: \.self) { column in
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
                        "\(size - row)",
                        color: labelColor,
                        cellSide: cellSide
                    )
                }
            }
            .overlay(alignment: .bottomTrailing) {
                if row == size - 1 {
                    coordinateLabel(
                        Self.alphabet[column],
                        color: labelColor,
                        cellSide: cellSide
                    )
                }
            }
            .overlay {
                if queens.contains(.init(row: row, column: column)) {
                    Image(.blackQueen)
                        .resizable()
                }
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
    BoardView(size: 8)
}

#Preview {
    BoardView(size: 4)
}
