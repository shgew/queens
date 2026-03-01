/// Enumerates all sound effects used by the game.
public enum GameSound: CaseIterable {
  /// Sound for placing a piece.
  case place
  /// Sound for removing a piece.
  case remove
  /// Sound for changing the board size.
  case boardSizeChanged
  /// Sound for an invalid action.
  case invalidMove
  /// Sound for a solved board.
  case win
  /// Sound for resetting the game.
  case reset
}

extension GameSound {
  var fileName: String {
    switch self {
    case .place:
      return "click_002"
    case .remove:
      return "click_005"
    case .boardSizeChanged:
      return "switch13"
    case .invalidMove:
      return "error_004"
    case .win:
      return "confirmation_001"
    case .reset:
      return "back_003"
    }
  }
}
