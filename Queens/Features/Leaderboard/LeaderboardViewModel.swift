import Foundation
import Observation

@Observable
final class LeaderboardViewModel: Identifiable {
  let id = UUID()

  private let bestTimesStore: any BestTimesStoring
  private(set) var sections: [LeaderboardSection] = []
  private(set) var isLoading = false

  init(bestTimesStore: any BestTimesStoring) {
    self.bestTimesStore = bestTimesStore
  }
}

extension LeaderboardViewModel {
  func load() async {
    guard !isLoading else { return }

    isLoading = true
    defer { isLoading = false }

    sections = await bestTimesStore.topTimesByBoardSize()
  }
}

// MARK: - Factory
extension LeaderboardViewModel {
  static var live: LeaderboardViewModel {
    LeaderboardViewModel(bestTimesStore: BestTimesStore.live)
  }
}
