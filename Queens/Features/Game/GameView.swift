import BoardUI
import SwiftUI

struct GameView: View {
    @State private var model = GameViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 18) {
                statsRow
                    .padding(.horizontal)
                board
                controlsRow
                    .padding(.horizontal)
            }

            if let winScreenViewModel = model.winScreenViewModel {
                winOverlay(for: winScreenViewModel)
            }
        }
        .task {
            model.preload()
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
                        till: model.winScreenViewModel?.solvedAt ?? context.date
                    )
                )
            }
        }
    }

    private var controlsRow: some View {
        HStack(spacing: 12) {
            resetButton
            Spacer(minLength: 0)
            boardSizePicker
        }
    }

    private var boardSizePicker: some View {
        Picker(selection: $model.selectedBoardSize) {
            ForEach(GameViewModel.supportedBoardSizes, id: \.self) { size in
                Text("\(size)×\(size)")
                    .tag(size)
            }
        } label: {
            Label(
                "\(model.selectedBoardSize)×\(model.selectedBoardSize)",
                systemImage: "square.grid.3x3"
            )
        }
        .buttonStyle(.glass)
    }

    private var resetButton: some View {
        Button("Reset", role: .destructive, action: model.resetButtonTapped)
            .buttonStyle(.glass)
    }

    private var board: some View {
        BoardView(board: model.board)
            .onSquareTapped(model.squareTapped)
            .cellState { model.conflicts.contains($0) ? .conflicting : .normal }
    }

    private func winOverlay(for viewModel: WinScreenViewModel) -> some View {
        return ZStack {
            Color.black.opacity(0.2)
                .ignoresSafeArea()

            WinScreen(
                boardSize: viewModel.boardSize,
                moveCount: viewModel.moveCount,
                elapsedTime: formattedElapsedTime(
                    from: viewModel.startedAt,
                    to: viewModel.solvedAt
                ),
                onReset: model.resetButtonTapped
            )
            .padding(24)
            .transition(.scale(0.9).combined(with: .opacity))
        }
        .zIndex(1)
    }

    private func formattedElapsedTime(till date: Date) -> String {
        formattedElapsedTime(from: model.startedAt, to: date)
    }

    private func formattedElapsedTime(from start: Date, to end: Date) -> String {
        let elapsed = Duration.seconds(
            max(0, end.timeIntervalSince(start))
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
    GameView()
}
