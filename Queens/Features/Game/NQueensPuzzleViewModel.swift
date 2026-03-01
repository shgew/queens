import Board
import BoardUI
import Foundation
import Game
import GameAudio
import Observation
import Problems
import ResourceStorage
import SwiftUI

@Observable
final class NQueensPuzzleViewModel {
  static let supportedBoardSizes = Array(Board.minimumSize...32)
  private static let occupant = Occupant(piece: .queen, side: .white)

  private var game: Game<NQueensProblem>
  private var areSoundsPreloaded = false
  private let soundPlayer: any GameSoundPlaying
  private let bestTimesStore: any BestTimesStoring
  private(set) var winViewModel: WinViewModel?
  private(set) var placeFeedbackTrigger = 0
  private(set) var removeFeedbackTrigger = 0
  private(set) var invalidPlaceFeedbackTrigger = 0

  init(
    size: Int = 4,
    soundPlayer: any GameSoundPlaying,
    bestTimesStore: any BestTimesStoring
  ) {
    self.game = Game(size: size, problem: NQueensProblem())
    self.soundPlayer = soundPlayer
    self.bestTimesStore = bestTimesStore
  }
}

// MARK: - View Exposed
extension NQueensPuzzleViewModel {
  var board: Board {
    game.board
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
    let endDate = winViewModel?.solvedAt ?? date
    return startedAt.formattedElapsedTime(to: endDate)
  }

  func cellState(for position: Position) -> BoardView.CellState {
    conflicts.contains(position) ? .conflicting : .normal
  }

  func squareTapped(at position: Position) async {
    if game.board.occupiedSquares[position] == Self.occupant {
      removePiece(at: position)
      return
    }

    guard canPlacePiece else {
      handleInvalidPlacement()
      return
    }

    placePiece(at: position)

    if game.isSolved {
      await presentWinView()
    }
  }

  func resetButtonTapped() {
    soundPlayer.play(.reset)
    resetGame()
  }
}

// MARK: - Helpers
extension NQueensPuzzleViewModel {
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
    game.apply(move: .remove(Self.occupant, from: position))
    removeFeedbackTrigger += 1
    soundPlayer.play(.remove)
  }

  private func placePiece(at position: Position) {
    game.apply(move: .place(Self.occupant, at: position))
    placeFeedbackTrigger += 1
    soundPlayer.play(.place)
  }

  private func handleInvalidPlacement() {
    invalidPlaceFeedbackTrigger += 1
    soundPlayer.play(.invalidMove)
  }

  private func presentWinView() async {
    let solvedAt = Date.now
    let elapsed = solvedAt.timeIntervalSince(game.startedAt)
    let isNewBest = await bestTimesStore.record(time: elapsed, forSize: game.board.size)
    let bestTime = await bestTimesStore.bestTime(forSize: game.board.size)
    soundPlayer.play(.win)
    withAnimation(Self.animation) {
      winViewModel = makeWinViewModel(
        solvedAt: solvedAt,
        bestTime: bestTime,
        isNewBest: isNewBest
      )
    }
  }

  private func makeWinViewModel(
    solvedAt: Date,
    bestTime: TimeInterval?,
    isNewBest: Bool
  ) -> WinViewModel {
    WinViewModel(
      boardSize: game.board.size,
      moveCount: game.moves.count,
      startedAt: game.startedAt,
      solvedAt: solvedAt,
      bestTime: bestTime,
      isNewBest: isNewBest,
      onPlayAgain: { [weak self] in
        self?.resetGame()
      }
    )
  }
}

// MARK: - Factory
extension NQueensPuzzleViewModel {
  static var live: NQueensPuzzleViewModel {
    let directory = FileManager.default
      .urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("Queens", isDirectory: true)
    let storage = FileResourceStorage(directory: directory)
    return NQueensPuzzleViewModel(
      soundPlayer: GameSoundPlayer(),
      bestTimesStore: BestTimesStore(storage: storage)
    )
  }

  static var preview: NQueensPuzzleViewModel {
    NQueensPuzzleViewModel(
      soundPlayer: SilentGameSoundPlayer(),
      bestTimesStore: BestTimesStore(storage: InMemoryResourceStorage())
    )
  }
}
