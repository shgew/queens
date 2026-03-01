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
      metricRow(
        systemImage: "figure.walk",
        title: "Moves",
        value: "\(viewModel.moveCount)"
      )
      metricRow(
        systemImage: "clock",
        title: "Time",
        value: viewModel.startedAt.formattedElapsedTime(to: viewModel.solvedAt)
      )
    }
  }

  private func metricRow(
    systemImage: String,
    title: String,
    value: String
  ) -> some View {
    LabeledContent {
      Text(value)
        .font(.headline)
        .monospacedDigit()
    } label: {
      Label(title, systemImage: systemImage)
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
  }
}

#Preview {
  WinView(
    viewModel: WinViewModel(
      boardSize: 8,
      moveCount: 12,
      startedAt: .now.addingTimeInterval(-165),
      solvedAt: .now,
      onPlayAgain: {}
    )
  )
}
