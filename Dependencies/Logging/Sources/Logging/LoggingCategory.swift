/// Categories used to partition Queens log output.
public enum LoggingCategory: String, Sendable {
  /// Audio playback and loading events.
  case audio
  /// Board mutation and validation events.
  case board
  /// User interface interaction events.
  case ui
  /// Game session events.
  case game
  /// Problem evaluation events.
  case problems
}
