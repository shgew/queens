import BoardUI
import Observation
import SwiftUI

struct ContentView: View {
    @State private var model = BoardViewModel()

    var body: some View {
        @Bindable var model = model

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
                statPill(title: "Placed", value: "\(model.queensPlaced)")
                statPill(title: "Remaining", value: "\(model.queensRemaining)")
                statPill(title: "Status", value: model.isSolved ? "Solved" : "Playing")
            }

            BoardView(board: model.board) { position in
                model.squareTapped(position)
            }
        }
        .padding()
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
