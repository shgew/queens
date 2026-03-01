import Foundation
import Testing

@testable import Queens

@MainActor
struct WinViewModelTests {
  @Test func `stored properties match init arguments`() {
    let startedAt = Date.now
    let solvedAt = startedAt.addingTimeInterval(42)

    let vm = WinViewModel(
      boardSize: 8,
      moveCount: 12,
      startedAt: startedAt,
      solvedAt: solvedAt,
      onPlayAgain: {}
    )

    #expect(vm.boardSize == 8)
    #expect(vm.moveCount == 12)
    #expect(vm.startedAt == startedAt)
    #expect(vm.solvedAt == solvedAt)
  }

  @Test func `play again button tapped invokes closure`() {
    var called = false
    let vm = WinViewModel(
      boardSize: 4,
      moveCount: 5,
      startedAt: .now,
      solvedAt: .now,
      onPlayAgain: { called = true }
    )

    vm.playAgainButtonTapped()

    #expect(called)
  }
}
