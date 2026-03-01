import AVFAudio
import Foundation
import OSLog

private let logger = Logger(
  subsystem: Bundle.module.bundleIdentifier ?? "Queens.GameAudio",
  category: "GameSoundPlayer"
)

public final class GameSoundPlayer: GameSoundPlaying {
  private let bundle: Bundle
  private var players: [GameSound: AVAudioPlayer] = [:]

  public init() {
    self.bundle = .module
  }

  public func preload(_ sounds: [GameSound]) {
    logger.debug("Preloading \(sounds.count) sounds")
    for sound in sounds {
      _ = player(for: sound)
    }
  }

  public func play(_ sound: GameSound) {
    guard let player = player(for: sound) else {
      logger.error(
        "Cannot play sound '\(sound.fileName)' because player failed to load"
      )
      return
    }

    if player.isPlaying {
      player.currentTime = 0
    }

    if !player.play() {
      logger.error(
        "Failed to play sound '\(sound.fileName)'"
      )
      return
    }

    logger.debug("Played sound '\(sound.fileName)'")
  }

  private func player(for sound: GameSound) -> AVAudioPlayer? {
    if let player = players[sound] {
      return player
    }

    guard let url = bundle.url(forResource: sound.fileName, withExtension: "wav") else {
      logger.error(
        "Missing sound resource '\(sound.fileName).wav'"
      )
      return nil
    }

    let player: AVAudioPlayer
    do {
      player = try AVAudioPlayer(contentsOf: url)
    } catch {
      logger.error(
        "Failed to initialize player for '\(sound.fileName)': \(error.localizedDescription)"
      )
      return nil
    }

    if !player.prepareToPlay() {
      logger.error(
        "Failed to prepare sound '\(sound.fileName)'"
      )
    }
    players[sound] = player
    return player
  }
}
