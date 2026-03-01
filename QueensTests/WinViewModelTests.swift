import Foundation
import Testing

@testable import Queens

struct WinViewModelTests {
  @Test func storedPropertiesMatchInitArguments() {
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

  @Test func playAgainButtonTappedInvokesClosure() {
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
