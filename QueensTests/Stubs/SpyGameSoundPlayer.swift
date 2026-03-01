import GameAudio

final class SpyGameSoundPlayer: GameSoundPlaying {
  private(set) var preloadedSounds: [[GameSound]] = []
  private(set) var playedSounds: [GameSound] = []

  func resetPlayedSounds() {
    playedSounds.removeAll()
  }

  func preload(_ sounds: [GameSound]) {
    preloadedSounds.append(sounds)
  }

  func play(_ sound: GameSound) {
    playedSounds.append(sound)
  }
}
