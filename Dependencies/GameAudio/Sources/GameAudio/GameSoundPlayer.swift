import AVFAudio
import Foundation

public final class GameSoundPlayer: GameSoundPlaying {
	private let bundle: Bundle
	private var players: [GameSound: AVAudioPlayer] = [:]

	public init() {
		self.bundle = .module
	}

	public func preload(_ sounds: [GameSound]) {
		for sound in sounds {
			_ = player(for: sound)
		}
	}

	public func play(_ sound: GameSound) {
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
