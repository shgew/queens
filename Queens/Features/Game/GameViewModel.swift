import Board
import BoardUI
import Foundation
import Game
import GameAudio
import Observation
import Problems
import SwiftUI

@MainActor
@Observable
final class GameViewModel {
  static let supportedBoardSizes = Array(Board.minimumSize...32)

  private var game: Game<NQueensProblem>
  private var areSoundsPreloaded = false
  private let soundPlayer: any GameSoundPlaying
  private let occupant = Occupant(piece: .queen, side: .white)
  private(set) var winViewModel: WinViewModel?
  private(set) var placeFeedbackTrigger = 0
  private(set) var removeFeedbackTrigger = 0
  private(set) var invalidPlaceFeedbackTrigger = 0

  init(
    size: Int = 4,
    soundPlayer: any GameSoundPlaying = GameSoundPlayer()
  ) {
    self.game = Game(size: size, problem: NQueensProblem())
    self.soundPlayer = soundPlayer
  }
}

// MARK: - View Exposed
extension GameViewModel {
  var board: Board {
    game.board
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

  func playTime(at date: Date) -> String {
    let endDate = winViewModel?.solvedAt ?? date
    return startedAt.formattedElapsedTime(to: endDate)
  }

  func cellState(for position: Position) -> BoardView.CellState {
    conflicts.contains(position) ? .conflicting : .normal
  }

  func load() {
    guard !areSoundsPreloaded else { return }
    soundPlayer.preload(GameSound.allCases)
    areSoundsPreloaded = true
  }

  var selectedBoardSize: Int {
    get { game.board.size }
    set {
      guard newValue != game.board.size else { return }
      game = Game(size: newValue, problem: NQueensProblem())
      winViewModel = nil
      soundPlayer.play(.boardSizeChanged)
    }
  }

  func squareTapped(_ position: Position) {
    if game.board.occupiedSquares[position] == occupant {
      removePiece(at: position)
      return
    }

    guard canPlacePiece else {
      handleInvalidPlacement()
      return
    }

    placePiece(at: position)

    if game.isSolved {
      presentWinView()
    }
  }

  func resetButtonTapped() {
    soundPlayer.play(.reset)
    resetGame()
  }
}

// MARK: - Helpers
extension GameViewModel {
  private static let animation = Animation.default.speed(2)

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
    game.apply(move: .remove(occupant, from: position))
    removeFeedbackTrigger += 1
    soundPlayer.play(.remove)
  }

  private func placePiece(at position: Position) {
    game.apply(move: .place(occupant, at: position))
    placeFeedbackTrigger += 1
    soundPlayer.play(.place)
  }

  private func handleInvalidPlacement() {
    invalidPlaceFeedbackTrigger += 1
    soundPlayer.play(.invalidMove)
  }

  private func presentWinView() {
    let solvedAt = Date.now
    soundPlayer.play(.win)
    withAnimation(Self.animation) {
      winViewModel = makeWinViewModel(solvedAt: solvedAt)
    }
  }

  private func makeWinViewModel(solvedAt: Date) -> WinViewModel {
    WinViewModel(
      boardSize: game.board.size,
      moveCount: game.moves.count,
      startedAt: game.startedAt,
      solvedAt: solvedAt,
      onPlayAgain: { [weak self] in
        self?.resetGame()
      }
    )
  }
}
