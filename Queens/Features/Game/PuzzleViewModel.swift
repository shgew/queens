import Board
import BoardUI
import Foundation
import Game
import GameAudio
import Observation
import Problems
import SwiftUI

@Observable
final class PuzzleViewModel<P: PuzzleProblem> {
  private var game: Game<P>
  private var areSoundsPreloaded = false
  private let soundPlayer: any GameSoundPlaying
  private let bestTimesStore: any BestTimesStoring
  private(set) var winViewModel: WinViewModel?
  private(set) var placeFeedbackTrigger = 0
  private(set) var removeFeedbackTrigger = 0
  private(set) var invalidPlaceFeedbackTrigger = 0

  init(
    size: Int = P.supportedBoardSizes.lowerBound,
    soundPlayer: any GameSoundPlaying,
    bestTimesStore: any BestTimesStoring
  ) {
    self.game = Game(size: size, problem: P())
    self.soundPlayer = soundPlayer
    self.bestTimesStore = bestTimesStore
  }
}

// MARK: - View Exposed
extension PuzzleViewModel {
  var board: Board {
    game.board
  }

  var selectedBoardSize: Int {
    get { game.board.size }
    set {
      guard newValue != game.board.size else { return }
      game = Game(size: newValue, problem: P())
      winViewModel = nil
      soundPlayer.play(.boardSizeChanged)
    }
  }

  var startedAt: Date {
    game.startedAt
  }

  var piecesRemaining: Int {
    game.board.size - game.board.occupiedSquares.count
  }

  var moveCount: Int {
    game.moves.count
  }

  func load() {
    guard !areSoundsPreloaded else { return }
    soundPlayer.preload(GameSound.allCases)
    areSoundsPreloaded = true
  }

  func playTime(at date: Date) -> String {
    if let elapsedTime = winViewModel?.elapsedTime {
      return elapsedTime.formattedElapsedTime()
    }
    return date.timeIntervalSince(startedAt).formattedElapsedTime()
  }

  func cellState(for position: Position) -> BoardView.CellState {
    conflicts.contains(position) ? .conflicting : .normal
  }

  func squareTapped(at position: Position) {
    if game.board.occupiedSquares[position] == P.occupant {
      removePiece(at: position)
      return
    }

    guard canPlacePiece else {
      handleInvalidPlacement()
      return
    }

    placePiece(at: position)

    if game.isSolved {
      handleSolved()
    }
  }

  func resetButtonTapped() {
    soundPlayer.play(.reset)
    resetGame()
  }
}

// MARK: - Helpers
extension PuzzleViewModel {
  private static var animation: Animation { .default.speed(2) }

  private var conflicts: Set<Position> {
    if case .unsolved(let diagnostic) = game.evaluation {
      return diagnostic.conflicts
    }
    return []
  }

  private func resetGame() {
    withAnimation(Self.animation) {
      winViewModel = nil
    }
    game.reset()
  }

  private var canPlacePiece: Bool {
    piecesRemaining > 0
  }

  private func removePiece(at position: Position) {
    game.apply(move: .remove(P.occupant, from: position))
    removeFeedbackTrigger += 1
    soundPlayer.play(.remove)
  }

  private func placePiece(at position: Position) {
    game.apply(move: .place(P.occupant, at: position))
    placeFeedbackTrigger += 1
    soundPlayer.play(.place)
  }

  private func handleInvalidPlacement() {
    invalidPlaceFeedbackTrigger += 1
    soundPlayer.play(.invalidMove)
  }

  private func handleSolved() {
    let solvedAt = Date.now
    let elapsed = solvedAt.timeIntervalSince(game.startedAt)
    let isNewBest = bestTimesStore.record(time: elapsed, for: game.board.size)
    let bestTime = bestTimesStore.bestTime(for: game.board.size)
    soundPlayer.play(.win)
    withAnimation(Self.animation) {
      winViewModel = makeWinViewModel(
        elapsedTime: elapsed,
        bestTime: bestTime,
        isNewBest: isNewBest
      )
    }
  }

  private func makeWinViewModel(
    elapsedTime: TimeInterval,
    bestTime: TimeInterval?,
    isNewBest: Bool
  ) -> WinViewModel {
    WinViewModel(
      boardSize: game.board.size,
      moveCount: game.moves.count,
      elapsedTime: elapsedTime,
      bestTime: bestTime,
      isNewBest: isNewBest,
      onPlayAgain: { [weak self] in
        self?.resetGame()
      }
    )
  }
}

// MARK: - Factory
extension PuzzleViewModel where P == NQueensProblem {
  static var live: PuzzleViewModel {
    PuzzleViewModel(
      soundPlayer: GameSoundPlayer(),
      bestTimesStore: BestTimesStore()
    )
  }

  static var preview: PuzzleViewModel {
    PuzzleViewModel(
      soundPlayer: SilentGameSoundPlayer(),
      bestTimesStore: PreviewBestTimesStore()
    )
  }
}
