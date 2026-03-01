import AVFAudio
import Foundation
import OSLog
import Logging

private let logger = Logger.queens(category: .audio)

final class AppAudioSession {
  private let audioSession: AVAudioSession

  init(audioSession: AVAudioSession) {
    self.audioSession = audioSession
  }

  func configure() {
    do {
      try audioSession.setCategory(.ambient, options: [.mixWithOthers])
      try audioSession.setActive(true)
    } catch {
      logger.error(
        "Failed to configure audio session: \(error.localizedDescription)"
      )
    }
  }
}
