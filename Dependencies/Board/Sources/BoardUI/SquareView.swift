import Board
import SwiftUI

/// A single square on the board.
///
/// Renders a colored tile with optional coordinate labels in the top-leading
/// and bottom-trailing corners, and an optional piece image. Configure
/// appearance using modifier-style methods:
///
/// ```swift
/// SquareView(cellSide: 44)
///     .fillColor(.white)
///     .labelColor(.black)
///     .topLeadingText("8")
///     .bottomTrailingText("a")
///     .occupant(Occupant(piece: .queen, side: .white))
///     .conflicting(true)
/// ```
///
/// Font size and label padding scale proportionally with `cellSide`.
/// When ``conflicting(_:)`` is set to `true`, a red tinted mask is applied
/// over the occupant image.
struct SquareView: View {
	let cellSide: CGFloat
	private var fillColor: Color = .clear
	private var labelColor: Color = .primary
	private var topLeadingText: String?
	private var bottomTrailingText: String?
	private var occupant: Occupant?
	private var isConflicting = false

	init(cellSide: CGFloat) {
		self.cellSide = cellSide
	}

	func fillColor(_ color: Color) -> Self {
		var copy = self
		copy.fillColor = color
		return copy
	}

	func labelColor(_ color: Color) -> Self {
		var copy = self
		copy.labelColor = color
		return copy
	}

	func topLeadingText(_ text: String?) -> Self {
		var copy = self
		copy.topLeadingText = text
		return copy
	}

	func bottomTrailingText(_ text: String?) -> Self {
		var copy = self
		copy.bottomTrailingText = text
		return copy
	}

	func occupant(_ occupant: Occupant?) -> Self {
		var copy = self
		copy.occupant = occupant
		return copy
	}

	func conflicting(_ isConflicting: Bool) -> Self {
		var copy = self
		copy.isConflicting = isConflicting
		return copy
	}

	var body: some View {
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
