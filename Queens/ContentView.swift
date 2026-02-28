import BoardUI
import SwiftUI

struct ContentView: View {
    @State private var model = ContentViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                topBar
                board
            }

            if model.isWinScreenPresented {
                winOverlay
            }
        }
        .sensoryFeedback(
            .impact(weight: .heavy, intensity: 0.9),
            trigger: model.placeFeedbackTrigger
        )
        .sensoryFeedback(
            .impact(weight: .light, intensity: 0.6),
            trigger: model.removeFeedbackTrigger
        )
    }

    private var topBar: some View {
        VStack(spacing: 16) {
            statsRow
            controlsRow
        }
        .padding(.horizontal)
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatPill(
                systemImage: "crown",
                value: "\(model.piecesRemaining)"
            )
            TimelineView(.periodic(from: .now, by: 1)) { context in
                StatPill(
                    systemImage: "clock",
                    value: formattedElapsedTime(
                        now: model.solvedAt ?? context.date
                    )
                )
            }
        }
    }

    private var controlsRow: some View {
        HStack {
            boardSizePicker
            Spacer()
            resetButton
        }
    }

    private var boardSizePicker: some View {
        Picker(selection: $model.selectedBoardSize) {
            ForEach(ContentViewModel.supportedBoardSizes, id: \.self) { size in
                Text("\(size)×\(size)")
                    .tag(size)
            }
        } label: {
            Image(systemName: "square.grid.3x3")
                .foregroundStyle(.secondary)
        }
    }

    private var resetButton: some View {
        Button("Reset", action: model.resetButtonTapped)
    }

    private var board: some View {
        BoardView(board: model.board)
            .onSquareTapped(model.squareTapped)
            .cellState { model.conflicts.contains($0) ? .conflicting : .normal }
    }

    private var winOverlay: some View {
        ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            WinScreen(
                boardSize: model.selectedBoardSize,
                moveCount: model.moveCount,
                elapsedTime: formattedElapsedTime(
                    now: model.solvedAt ?? .now
                ),
                onReset: model.resetButtonTapped
            )
            .padding(24)
            .transition(.scale(0.9).combined(with: .opacity))
        }
        .zIndex(1)
    }

    private func formattedElapsedTime(now: Date) -> String {
        let elapsed = Duration.seconds(
            max(0, now.timeIntervalSince(model.startedAt))
        )
        let pattern: Duration.TimeFormatStyle.Pattern
        if elapsed >= .seconds(3600) {
            pattern = .hourMinuteSecond
        } else {
            pattern = .minuteSecond(padMinuteToLength: 2)
        }
        return elapsed.formatted(.time(pattern: pattern))
    }
}

#Preview {
    ContentView()
}
