import Foundation

struct LeaderboardSection: Equatable, Sendable {
  let boardSize: Int
  let times: [TimeInterval]
}
