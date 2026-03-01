import Board
import Foundation
import Game
import GameAudio
import Observation
import Problems
import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    static let maximumBoardSize = 32
    static let supportedBoardSizes = Array(Board.minimumSize...maximumBoardSize)

    private var game: Game<NQueensProblem>
    private let soundPlayer: any GameSoundPlaying
    private(set) var winScreenViewModel: WinScreenViewModel?
    private(set) var placeFeedbackTrigger = 0
    private(set) var removeFeedbackTrigger = 0
    private var areSoundsPreloaded = false

    var board: Board {
        game.board
    }

    var startedAt: Date {
        game.startedAt
    }

    private let occupant = Occupant(piece: .queen, side: .white)

    init(
        size: Int = 4,
        soundPlayer: any GameSoundPlaying = GameSoundPlayer()
    ) {
        self.game = Game(size: size, problem: NQueensProblem())
        self.soundPlayer = soundPlayer
    }

    func preload() {
        guard !areSoundsPreloaded else { return }
        soundPlayer.preload(GameSound.allCases)
        areSoundsPreloaded = true
    }

    var selectedBoardSize: Int {
        get { game.board.size }
        set {
            guard newValue != game.board.size else { return }
            game = Game(size: newValue, problem: NQueensProblem())
            winScreenViewModel = nil
            soundPlayer.play(.boardSizeChanged)
        }
    }

    var piecesRemaining: Int {
        game.board.size - game.board.occupiedSquares.count
    }

    var isSolved: Bool {
        game.isSolved
    }

    var moveCount: Int {
        game.moves.count
    }

    var canUndo: Bool {
        !game.moves.isEmpty
    }

    var conflicts: Set<Position> {
        if case .unsolved(let diagnostic) = game.evaluation {
            return diagnostic.conflicts
        }
        return []
    }

    func squareTapped(_ position: Position) {
        if game.board.occupiedSquares[position] == occupant {
            game.apply(move: .remove(occupant, from: position))
            removeFeedbackTrigger += 1
            soundPlayer.play(.remove)
            return
        }

        guard piecesRemaining > 0 else {
            soundPlayer.play(.invalidMove)
            return
        }

        game.apply(move: .place(occupant, at: position))
        placeFeedbackTrigger += 1

        if game.isSolved {
            let solvedAt = Date.now
            soundPlayer.play(.win)
            withAnimation(Self.animation) {
                winScreenViewModel = WinScreenViewModel(
                    boardSize: game.board.size,
                    moveCount: game.moves.count,
                    startedAt: game.startedAt,
                    solvedAt: solvedAt
                )
            }
        } else {
            soundPlayer.play(.place)
        }
    }

    func undoButtonTapped() {
        game.undo()
    }

    func resetButtonTapped() {
        soundPlayer.play(.reset)
        withAnimation(Self.animation) {
            winScreenViewModel = nil
        }
        game.reset()
    }
}

private extension GameViewModel {
    private static let animation = Animation.default.speed(2)
}
