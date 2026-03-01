public enum GameSound: CaseIterable {
	case place
	case remove
	case boardSizeChanged
	case invalidMove
	case win
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
