import Foundation
import Testing

@testable import Queens

struct WinViewModelTests {
  @Test func `play again button tapped invokes closure`() {
    var called = false
    let vm = WinViewModel(
      boardSize: 4,
      moveCount: 5,
      elapsedTime: 15,
      onPlayAgain: { called = true }
    )

    vm.playAgainButtonTapped()

    #expect(called)
  }
}
