import BoardUI
import Game
import Observation
import SwiftUI

struct ContentView: View {
    @State private var model = BoardViewModel()

    var body: some View {
        @Bindable var model = model

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
                    statPill(
                        title: "Status",
                        value: model.isSolved ? "Solved" : "Playing"
                    )
                }

                HStack {
                    Text("Board Size")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Picker("Board Size", selection: $model.selectedBoardSize) {
                        ForEach(BoardViewModel.supportedBoardSizes, id: \.self)
                        { size in
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
                    model.conflicts.contains(position) ? .conflicting : .normal
                }
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
