/// Abstraction for preloading and playing game sounds.
public protocol GameSoundPlaying {
  /// Preloads sound assets so playback can start with low latency.
  ///
  /// - Parameter sounds: The sounds that should be prepared.
  func preload(_ sounds: [GameSound])
  /// Plays a single game sound.
  ///
  /// - Parameter sound: The sound to play.
  func play(_ sound: GameSound)
}
