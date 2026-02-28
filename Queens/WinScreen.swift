import SwiftUI

struct WinScreen: View {
    var boardSize: Int
    var moveCount: Int
    var elapsedTime: String
    var onReset: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Image(systemName: "party.popper.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.orange)

                Text("Congratulations!")
                    .font(.title2.bold())

                Text("You solved \(boardSize)×\(boardSize).")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            VStack(spacing: 10) {
                metricRow(systemImage: "figure.walk", title: "Moves", value: "\(moveCount)")
                metricRow(systemImage: "clock", title: "Time", value: elapsedTime)
            }

            Button {
                onReset()
            } label: {
                Label("Play Again", systemImage: "arrow.counterclockwise")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(.tint, in: Capsule())
                    .foregroundStyle(.white)
            }
        }
        .padding(24)
        .frame(width: 300, height: 300)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(.quaternary, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 24, y: 8)
    }

    private func metricRow(systemImage: String, title: String, value: String) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .foregroundStyle(.secondary)
            Spacer()
            Text(value)
                .font(.headline.monospacedDigit())
        }
        .font(.subheadline)
    }
}

#Preview {
    WinScreen(
        boardSize: 8,
        moveCount: 12,
        elapsedTime: "02:45",
        onReset: {}
    )
}
