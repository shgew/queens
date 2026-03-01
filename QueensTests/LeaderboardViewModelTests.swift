import Testing

@testable import Queens

struct LeaderboardViewModelTests {
  @Test func `load gets sections from store`() async {
    let expected = [
      LeaderboardSection(boardSize: 4, times: [8.0, 10.0]),
      LeaderboardSection(boardSize: 8, times: [20.0]),
    ]
    let vm = LeaderboardViewModel(
      bestTimesStore: BestTimesStoreStub(
        bestTime: nil,
        isNewBest: false,
        leaderboardSections: expected
      )
    )

    await vm.load()

    #expect(vm.sections == expected)
    #expect(!vm.isLoading)
  }
}
