import Board
import SwiftUI

public struct SquareView: View {
    let cellSide: CGFloat
    private var fillColor: Color = .clear
    private var labelColor: Color = .primary
    private var topLeadingText: String?
    private var bottomTrailingText: String?
    private var occupant: Occupant?
    private var isConflicting = false

    public init(cellSide: CGFloat) {
        self.cellSide = cellSide
    }

    public func fillColor(_ color: Color) -> Self {
        var copy = self
        copy.fillColor = color
        return copy
    }

    public func labelColor(_ color: Color) -> Self {
        var copy = self
        copy.labelColor = color
        return copy
    }

    public func topLeadingText(_ text: String?) -> Self {
        var copy = self
        copy.topLeadingText = text
        return copy
    }

    public func bottomTrailingText(_ text: String?) -> Self {
        var copy = self
        copy.bottomTrailingText = text
        return copy
    }

    public func occupant(_ occupant: Occupant?) -> Self {
        var copy = self
        copy.occupant = occupant
        return copy
    }

    public func conflicting(_ isConflicting: Bool) -> Self {
        var copy = self
        copy.isConflicting = isConflicting
        return copy
    }

    public var body: some View {
        ZStack {
            Rectangle()
                .fill(fillColor)

            if let topLeadingText {
                coordinateLabel(topLeadingText)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .topLeading
                    )
            }

            if let bottomTrailingText {
                coordinateLabel(bottomTrailingText)
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity,
                        alignment: .bottomTrailing
                    )
            }

            if let occupant {
                let image = Image(of: occupant)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                image
                    .overlay {
                        if isConflicting {
                            Color.red.opacity(0.4)
                                .mask { image }
                        }
                    }
            }
        }
    }

    private func coordinateLabel(_ text: String) -> some View {
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
            .foregroundStyle(labelColor)
            .aspectRatio(contentMode: .fit)
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
    }
}
