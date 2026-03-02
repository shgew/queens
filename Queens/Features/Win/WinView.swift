import SwiftUI

struct WinView: View {
  let viewModel: WinViewModel

  var body: some View {
    GlassEffectContainer(spacing: 16) {
      VStack(spacing: 20) {
        header
        metrics

        Button {
          viewModel.playAgainButtonTapped()
        } label: {
          Label("Play Again", systemImage: "arrow.counterclockwise")
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(.glassProminent)
      }
      .padding(24)
      .frame(width: 320)
      .glassEffect(.regular, in: .rect(cornerRadius: 24.0))
    }
  }

  private var header: some View {
    VStack(spacing: 10) {
      Image(systemName: "party.popper.fill")
        .font(.system(size: 42))
        .foregroundStyle(.orange)

      Text("Congratulations!")
        .font(.title2.bold())

      Text("You solved \(viewModel.boardSize)×\(viewModel.boardSize).")
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }

  private var metrics: some View {
    VStack(spacing: 10) {
      metricRow(systemImage: "figure.walk", title: "Moves") {
        metricValueText("\(viewModel.moveCount)")
      }
      metricRow(systemImage: "clock", title: "Time") {
        metricValueText(viewModel.elapsedTime.formattedElapsedTime())
      }
      if let bestTime = viewModel.bestTime {
        metricRow(systemImage: "trophy", title: "Best") {
          HStack(spacing: 6) {
            if viewModel.isNewBest {
              newBestBadge
            }
            metricValueText(bestTime.formattedElapsedTime())
          }
        }
      }
    }
  }

  private func metricRow(
    systemImage: String,
    title: String,
    @ViewBuilder value: () -> some View
  ) -> some View {
    LabeledContent {
      value()
    } label: {
      Label(title, systemImage: systemImage)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }

  private func metricValueText(_ value: String) -> some View {
    Text(value)
      .font(.headline)
      .monospacedDigit()
  }

  private var newBestBadge: some View {
    Text("New!")
      .font(.caption.bold())
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .glassEffect(.regular.tint(.orange))
  }
}

#Preview {
  WinView(
    viewModel: WinViewModel(
      boardSize: 8,
      moveCount: 12,
      elapsedTime: 165,
      onPlayAgain: {}
    )
  )
}

#Preview("New Best") {
  WinView(
    viewModel: WinViewModel(
      boardSize: 8,
      moveCount: 12,
      elapsedTime: 165,
      bestTime: 165,
      isNewBest: true,
      onPlayAgain: {}
    )
  )
}
