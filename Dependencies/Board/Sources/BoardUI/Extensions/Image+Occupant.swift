import Board
import SwiftUI

extension Image {
  /// Creates an image for the given board occupant from the module's asset
  /// catalog.
  ///
  /// The image is resolved from `Pieces/{side}{piece}` where side is
  /// `"w"` or `"b"` and piece is `"q"`.
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
