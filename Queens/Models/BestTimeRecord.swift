import Foundation
import SwiftData

@Model
final class BestTimeRecord {
  var boardSize: Int
  var time: TimeInterval

  init(boardSize: Int, time: TimeInterval) {
    self.boardSize = boardSize
    self.time = time
  }
}
