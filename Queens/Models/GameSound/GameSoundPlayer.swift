import AVFAudio
import Foundation

@MainActor
final class GameSoundPlayer: GameSoundPlaying {
    private let bundle: Bundle
    private var players: [GameSound: AVAudioPlayer] = [:]

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func preload(_ sounds: [GameSound]) {
        for sound in sounds {
            _ = player(for: sound)
        }
    }

    func play(_ sound: GameSound) {
        guard let player = player(for: sound) else { return }

        if player.isPlaying {
            player.currentTime = 0
        }

        player.play()
    }

    private func player(for sound: GameSound) -> AVAudioPlayer? {
        if let player = players[sound] {
            return player
        }

        guard let url = bundle.url(forResource: sound.fileName, withExtension: "wav") else {
            return nil
        }

        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            return nil
        }

        player.prepareToPlay()
        players[sound] = player
        return player
    }
}
