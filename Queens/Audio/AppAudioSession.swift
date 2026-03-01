import AVFAudio
import Foundation
import OSLog

final class AppAudioSession {
    private let audioSession: AVAudioSession
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Queens",
        category: "AppAudioSession"
    )

    init(audioSession: AVAudioSession) {
        self.audioSession = audioSession
    }

    func configure() {
        do {
            try audioSession.setCategory(.ambient, options: [.mixWithOthers])
            try audioSession.setActive(true)
        } catch {
            logger.error(
                "Failed to configure audio session: \(error.localizedDescription, privacy: .public)"
            )
        }
    }
}
