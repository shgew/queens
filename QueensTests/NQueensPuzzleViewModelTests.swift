import Board
import BoardUI
import Foundation
import GameAudio
import SwiftData
import Testing

@testable import Queens

struct NQueensPuzzleViewModelTests {
  let spy = SpyGameSoundPlayer()
  let vm: NQueensPuzzleViewModel

  init() {
    vm = NQueensPuzzleViewModel(
      size: 4,
      soundPlayer: spy,
      bestTimesStore: Self.makeInMemoryBestTimesStore()
    )
  }

  // MARK: - Initial State

  @Test func `initial board size`() {
    #expect(vm.board.size == 4)
  }

  @Test func `initial pieces remaining`() {
    #expect(vm.piecesRemaining == 4)
  }

  @Test func `initial move count`() {
    #expect(vm.moveCount == 0)
  }

  @Test func `initial win view model is nil`() {
    #expect(vm.winViewModel == nil)
  }

  // MARK: - selectedBoardSize

  @Test func `setting board size creates new game`() {
    vm.selectedBoardSize = 5
    #expect(vm.board.size == 5)
    #expect(vm.piecesRemaining == 5)
    #expect(spy.playedSounds == [.boardSizeChanged])
  }

  @Test func `setting board size nils win view model`() async {
    // Solve the board first
    await solve4Queens()
    #expect(vm.winViewModel != nil)

    vm.selectedBoardSize = 5
    #expect(vm.winViewModel == nil)
  }

  @Test func `setting same board size is no-op`() {
    vm.selectedBoardSize = 4
    #expect(spy.playedSounds.isEmpty)
  }

  // MARK: - load()

  @Test func `load preloads sounds`() {
    vm.load()
    #expect(spy.preloadedSounds.count == 1)
    #expect(spy.preloadedSounds[0] == GameSound.allCases)
  }

  @Test func `load is idempotent`() {
    vm.load()
    vm.load()
    #expect(spy.preloadedSounds.count == 1)
  }

  // MARK: - playTime(at:)

  @Test func `play time formats elapsed time`() {
    let time = vm.playTime(at: vm.startedAt.addingTimeInterval(125))
    #expect(time == "02:05")
  }

  @Test func `play time uses solved at when present`() async throws {
    await solve4Queens()
    let solvedAt = try #require(vm.winViewModel).solvedAt

    // Even with a far-future date, should use solvedAt
    let time = vm.playTime(at: solvedAt.addingTimeInterval(9999))
    let expected = vm.startedAt.formattedElapsedTime(to: solvedAt)
    #expect(time == expected)
  }

  // MARK: - cellState(for:)

  @Test func `cell state normal for empty board`() {
    let state = vm.cellState(for: Position(row: 0, column: 0))
    #expect(state == .normal)
  }

  @Test func `cell state conflicting for conflicting queens`() async {
    // Place two queens that conflict (same row)
    await vm.squareTapped(at: Position(row: 0, column: 0))
    await vm.squareTapped(at: Position(row: 0, column: 1))

    let state = vm.cellState(for: Position(row: 0, column: 0))
    #expect(state == .conflicting)
  }

  // MARK: - squareTapped — place

  @Test func `placing queen updates board state`() async {
    let pos = Position(row: 0, column: 0)
    await vm.squareTapped(at: pos)

    #expect(vm.piecesRemaining == 3)
    #expect(vm.moveCount == 1)
    #expect(!vm.board.occupiedSquares.isEmpty)
    #expect(spy.playedSounds == [.place])
    #expect(vm.placeFeedbackTrigger == 1)
  }

  // MARK: - squareTapped — remove

  @Test func `tapping occupied square removes it`() async {
    let pos = Position(row: 0, column: 0)
    await vm.squareTapped(at: pos)  // place
    await vm.squareTapped(at: pos)  // remove

    #expect(vm.piecesRemaining == 4)
    #expect(vm.moveCount == 2)
    #expect(vm.board.occupiedSquares.isEmpty)
    #expect(spy.playedSounds == [.place, .remove])
    #expect(vm.removeFeedbackTrigger == 1)
  }

  // MARK: - squareTapped — invalid

  @Test func `placing when no pieces remaining plays invalid move`() async {
    // Fill with 4 non-conflicting queens so piecesRemaining == 0
    await solve4Queens()
    spy.resetPlayedSounds()

    // Try placing on an unoccupied square — no pieces remaining
    await vm.squareTapped(at: Position(row: 3, column: 3))
    #expect(spy.playedSounds == [.invalidMove])
    #expect(vm.invalidPlaceFeedbackTrigger == 1)
  }

  @Test func `placing when board full but unsolved plays invalid move`() async {
    // Place 4 queens that conflict so board is full but unsolved
    await vm.squareTapped(at: Position(row: 0, column: 0))
    await vm.squareTapped(at: Position(row: 1, column: 1))
    await vm.squareTapped(at: Position(row: 2, column: 2))
    await vm.squareTapped(at: Position(row: 3, column: 3))
    spy.resetPlayedSounds()

    #expect(vm.piecesRemaining == 0)

    await vm.squareTapped(at: Position(row: 0, column: 3))  // can't place — no pieces remaining
    // Tapping occupied removes, tapping unoccupied triggers invalidMove
    #expect(spy.playedSounds == [.invalidMove])
    #expect(vm.invalidPlaceFeedbackTrigger == 1)
  }

  // MARK: - squareTapped — solve

  @Test func `solving board sets win view model`() async {
    await solve4Queens()

    #expect(vm.winViewModel != nil)
    #expect(spy.playedSounds.contains(.win))
  }

  @Test func `solving board records best time`() async throws {
    await solve4Queens()
    let win = try #require(vm.winViewModel)

    #expect(win.bestTime != nil)
    #expect(win.isNewBest)
  }

  // MARK: - resetButtonTapped

  @Test func `reset clears board and state`() async {
    await vm.squareTapped(at: Position(row: 0, column: 0))
    spy.resetPlayedSounds()

    vm.resetButtonTapped()

    #expect(vm.board.occupiedSquares.isEmpty)
    #expect(vm.moveCount == 0)
    #expect(vm.winViewModel == nil)
    #expect(spy.playedSounds == [.reset])
  }

  // MARK: - WinViewModel.playAgain integration

  @Test func `play again resets game`() async throws {
    await solve4Queens()
    let win = try #require(vm.winViewModel)

    win.playAgainButtonTapped()

    #expect(vm.board.occupiedSquares.isEmpty)
    #expect(vm.moveCount == 0)
    #expect(vm.winViewModel == nil)
  }

  // MARK: - Helpers

  /// Places queens at (0,1), (1,3), (2,0), (3,2) — a valid 4-queens solution.
  private func solve4Queens() async {
    await vm.squareTapped(at: Position(row: 0, column: 1))
    await vm.squareTapped(at: Position(row: 1, column: 3))
    await vm.squareTapped(at: Position(row: 2, column: 0))
    await vm.squareTapped(at: Position(row: 3, column: 2))
  }
}

extension NQueensPuzzleViewModelTests {
  private static func makeInMemoryBestTimesStore() -> BestTimesStore {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
      let container = try ModelContainer(for: BestTimeRecord.self, configurations: configuration)
      return BestTimesStore(container: container)
    } catch {
      fatalError("Failed to create in-memory SwiftData container for tests: \(error)")
    }
  }
}
