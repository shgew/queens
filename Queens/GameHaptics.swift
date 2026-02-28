import UIKit

@MainActor
protocol GameHaptics {
    func prepare()
    func playPlacePiece()
    func playRemovePiece()
}

@MainActor
final class SystemGameHaptics: GameHaptics {
    private let placeGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let removeGenerator = UIImpactFeedbackGenerator(style: .soft)

    init() {}

    func prepare() {
        placeGenerator.prepare()
        removeGenerator.prepare()
    }

    func playPlacePiece() {
        placeGenerator.impactOccurred(intensity: 0.9)
        placeGenerator.prepare()
    }

    func playRemovePiece() {
        removeGenerator.impactOccurred(intensity: 0.75)
        removeGenerator.prepare()
    }
}
