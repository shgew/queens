import BoardUI
import Game
import Observation
import SwiftUI

struct ContentView: View {
    @State private var model = ContentViewModel()

    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Queens")
                            .font(.title.bold())
                        Spacer()
                        Button("Reset") {
                            model.resetButtonTapped()
                        }
                    }

                    HStack(spacing: 12) {
                        statPill(title: "Placed", value: "\(model.piecesPlaced)")
                        statPill(
                            title: "Remaining",
                            value: "\(model.piecesRemaining)"
                        )
                        TimelineView(
                            .periodic(from: .now, by: 1)
                        ) { context in
                            statPill(
                                title: "Time",
                                value: model.elapsedTime(
                                    now: model.solvedAt ?? context.date
                                )
                            )
                        }
                    }

                    HStack {
                        Text("Board Size")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                        Picker(
                            "Board Size", selection: $model.selectedBoardSize
                        ) {
                            ForEach(
                                ContentViewModel.supportedBoardSizes, id: \.self
                            ) { size in
                                Text("\(size)×\(size)")
                                    .tag(size)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                BoardView(board: model.game.board)
                    .onSquareTapped { position in
                        model.squareTapped(position)
                    }
                    .cellState { position in
                        model.conflicts.contains(position)
                            ? .conflicting : .normal
                    }
            }

            if model.isWinScreenPresented {
                winScreen
            }
        }
    }

    private var winScreen: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Congratulations!")
                    .font(.largeTitle.bold())

                VStack(spacing: 8) {
                    Text("Board: \(model.selectedBoardSize)×\(model.selectedBoardSize)")
                    Text("Moves: \(model.moveCount)")
                    Text("Time: \(model.elapsedTime(now: model.solvedAt ?? .now))")
                }
                .font(.title3)

                Button {
                    model.resetButtonTapped()
                } label: {
                    Text("New Game")
                        .font(.headline)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(.tint, in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                .padding(.top, 8)
            }
            .padding(32)
            .background(
                .regularMaterial,
                in: RoundedRectangle(cornerRadius: 20)
            )
            .padding(32)
        }
    }

    private func statPill(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.monospaced())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    ContentView()
}
