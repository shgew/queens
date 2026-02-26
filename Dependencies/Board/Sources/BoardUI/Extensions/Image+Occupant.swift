import Board
import SwiftUI

extension Image {
    init(of occupant: Occupant) {
        let side =
            switch occupant.side {
            case .white: "w"
            case .black: "b"
            }
        let piece =
            switch occupant.piece {
            case .queen: "q"
            }
        self.init("Pieces/\(side)\(piece)", bundle: .module)
    }
}
