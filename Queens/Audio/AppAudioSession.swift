import AVFAudio
import Foundation
import Logging
import OSLog

private let logger = Logger.queens(category: .audio)

final class AppAudioSession {
  private let audioSession: AVAudioSession

  init(audioSession: AVAudioSession) {
    self.audioSession = audioSession
  }

  func configure() {
    do {
      // Avoid pausing any playing media when playing game sounds
      try audioSession.setCategory(.ambient, options: [.mixWithOthers])
    } catch {
      logger.error(
        "Failed to configure audio session: \(error.localizedDescription)"
      )
    }
  }
}
