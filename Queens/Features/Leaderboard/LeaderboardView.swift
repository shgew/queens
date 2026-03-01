import SwiftUI

struct LeaderboardView: View {
  @State private var model: LeaderboardViewModel

  init(viewModel: LeaderboardViewModel) {
    self._model = State(initialValue: viewModel)
  }

  var body: some View {
    NavigationStack {
      List {
        if model.sections.isEmpty {
          ContentUnavailableView(
            "No Records Yet",
            systemImage: "list.number"
          )
        } else {
          ForEach(model.sections, id: \.boardSize) { section in
            Section("\(section.boardSize)×\(section.boardSize)") {
              ForEach(section.times.enumerated(), id: \.element) { index, time in
                HStack {
                  Text("#\(index + 1)")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
                  Spacer()
                  Text(time.formattedElapsedTime())
                    .monospacedDigit()
                }
              }
            }
          }
        }
      }
      .navigationTitle("Leaderboard")
    }
    .task {
      await model.load()
    }
  }
}

#Preview {
  LeaderboardView(
    viewModel: LeaderboardViewModel(bestTimesStore: PreviewBestTimesStore())
  )
}
