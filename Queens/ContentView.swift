import BoardUI
import SwiftUI

struct ContentView: View {
    @State private var model = ContentViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(spacing: 16) {
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

                    HStack {
                        Picker(
                            selection: $model.selectedBoardSize
                        ) {
                            ForEach(
                                ContentViewModel.supportedBoardSizes,
                                id: \.self
                            ) { size in
                                Text("\(size)×\(size)")
                                    .tag(size)
                            }
                        } label: {
                            Image(systemName: "square.grid.3x3")
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Button {
                            model.resetButtonTapped()
                        } label: {
                            Text("Reset")
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                BoardView(board: model.board)
                    .onSquareTapped { position in
                        model.squareTapped(position)
                    }
                    .cellState { position in
                        model.conflicts.contains(position)
                            ? .conflicting : .normal
                    }
            }

            if model.isWinScreenPresented {
                ZStack {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture {}

                    ConfettiBurstView()
                        .ignoresSafeArea()
                        .allowsHitTesting(false)

                    WinScreen(
                        boardSize: model.selectedBoardSize,
                        moveCount: model.moveCount,
                        elapsedTime: formattedElapsedTime(
                            now: model.solvedAt ?? .now
                        ),
                        onReset: {
                            model.resetButtonTapped()
                        }
                    )
                    .padding(24)
                }
            }
        }
    }

    private func formattedElapsedTime(now: Date) -> String {
        let elapsed = max(0, now.timeIntervalSince(model.startedAt))
        let duration = Duration.seconds(elapsed)
        if elapsed >= 3600 {
            return duration.formatted(.time(pattern: .hourMinuteSecond))
        }
        return duration.formatted(.time(pattern: .minuteSecond))
    }
}

#Preview {
    ContentView()
}
