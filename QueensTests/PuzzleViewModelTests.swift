import Board
import BoardUI
import Foundation
import GameAudio
import Testing

@testable import Queens

/// Tests ``PuzzleViewModel`` with a ``StubProblem`` to verify the ViewModel
/// is fully generic and not coupled to any specific problem type.
struct PuzzleViewModelTests {
  let spy = SpyGameSoundPlayer()
  let vm: PuzzleViewModel<StubProblem>

  init() {
    vm = PuzzleViewModel(
      size: 2,
      soundPlayer: spy,
      bestTimesStore: BestTimesStoreStub(bestTime: 5, isNewBest: true)
    )
  }

  // MARK: - Board Sizes

  @Test func `default size uses problem lower bound`() {
    let vm = PuzzleViewModel<StubProblem>(
      soundPlayer: spy,
      bestTimesStore: BestTimesStoreStub(bestTime: nil, isNewBest: false)
    )
    #expect(vm.board.size == StubProblem.supportedBoardSizes.lowerBound)
  }

  // MARK: - Occupant

  @Test func `places problem occupant`() {
    // Q .
    // . .
    let pos = Position(row: 0, column: 0)
    vm.squareTapped(at: pos)

    #expect(vm.board.occupiedSquares[pos] == StubProblem.occupant)
  }

  @Test func `tapping occupied square removes problem occupant`() {
    // Q .    . .
    // . .  → . .
    let pos = Position(row: 0, column: 0)
    vm.squareTapped(at: pos)
    vm.squareTapped(at: pos)

    #expect(vm.board.occupiedSquares[pos] == nil)
  }

  // MARK: - Solving

  @Test func `solving with stub problem triggers win`() {
    // Q .
    // . N
    vm.squareTapped(at: Position(row: 0, column: 0))
    vm.squareTapped(at: Position(row: 1, column: 1))

    #expect(vm.winViewModel != nil)
    #expect(spy.playedSounds.contains(.win))
  }

  // MARK: - Cell State

  @Test func `cell state is normal when stub reports no conflicts`() {
    // Q .
    // . .
    vm.squareTapped(at: Position(row: 0, column: 0))

    #expect(vm.cellState(for: Position(row: 0, column: 0)) == .normal)
  }

  // MARK: - Size Change

  @Test func `changing board size resets game`() {
    // Q .    . . .
    // . .  → . . .
    //        . . .
    vm.squareTapped(at: Position(row: 0, column: 0))
    vm.selectedBoardSize = 3

    #expect(vm.board.size == 3)
    #expect(vm.board.occupiedSquares.isEmpty)
    #expect(vm.piecesRemaining == 3)
  }

  // MARK: - Reset

  @Test func `reset clears board`() {
    // Q .    . .
    // . .  → . .
    vm.squareTapped(at: Position(row: 0, column: 0))
    vm.resetButtonTapped()

    #expect(vm.board.occupiedSquares.isEmpty)
    #expect(vm.moveCount == 0)
  }
}
