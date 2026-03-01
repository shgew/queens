/// A ``GameSoundPlaying`` implementation that does nothing.
public struct SilentGameSoundPlayer: GameSoundPlaying {
  public init() {}
  public func preload(_ sounds: [GameSound]) {}
  public func play(_ sound: GameSound) {}
}
