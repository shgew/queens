import BoardUI
import SwiftUI

struct NQueensPuzzleView: View {
  @State private var model: NQueensPuzzleViewModel

  init(viewModel: NQueensPuzzleViewModel) {
    self._model = State(initialValue: viewModel)
  }

  var body: some View {
    ZStack {
      VStack(spacing: 18) {
        statsRow
          .padding(.horizontal)
        board
        controlsRow
          .padding(.horizontal)
      }
      .padding(.vertical)

      if let winViewModel = model.winViewModel {
        winOverlay(for: winViewModel)
      }
    }
    .task {
      model.load()
    }
    .sensoryFeedback(
      .impact(weight: .heavy, intensity: 0.9),
      trigger: model.placeFeedbackTrigger
    )
    .sensoryFeedback(
      .impact(weight: .light, intensity: 0.6),
      trigger: model.removeFeedbackTrigger
    )
    .sensoryFeedback(
      .warning,
      trigger: model.invalidPlaceFeedbackTrigger
    )
  }

  private var statsRow: some View {
    HStack(spacing: 12) {
      StatPill(
        systemImage: "crown",
        value: "\(model.piecesRemaining)"
      )
      StatPill(
        systemImage: "figure.walk",
        value: "\(model.moveCount)"
      )
      TimelineView(.periodic(from: .now, by: 1)) { context in
        StatPill(
          systemImage: "clock",
          value: model.playTime(at: context.date)
        )
      }
    }
  }

  private var controlsRow: some View {
    HStack(spacing: 0) {
      resetButton
      Spacer(minLength: 12)
      boardSizePicker
    }
  }

  private var boardSizePicker: some View {
    Picker(selection: $model.selectedBoardSize) {
      ForEach(NQueensPuzzleViewModel.supportedBoardSizes, id: \.self) { size in
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
      .onSquareTapped { position in
        Task { @MainActor in
          await model.squareTapped(at: position)
        }
      }
      .cellState(model.cellState(for:))
  }

  private func winOverlay(for viewModel: WinViewModel) -> some View {
    return ZStack {
      Color.black.opacity(0.2)
        .ignoresSafeArea()

      WinView(viewModel: viewModel)
        .padding(24)
        .transition(.scale(0.9).combined(with: .opacity))
    }
    .zIndex(1)
  }
}

#Preview {
  NQueensPuzzleView(viewModel: .preview)
}
