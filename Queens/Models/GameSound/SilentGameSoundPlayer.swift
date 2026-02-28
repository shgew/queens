@MainActor
struct SilentGameSoundPlayer: GameSoundPlaying {
    func preload(_ sounds: [GameSound]) {}
    func play(_ sound: GameSound) {}
}
