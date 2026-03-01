import Board

/// The N-Queens problem: place *N* queens on an *N*×*N* board so that no two
/// queens share the same row, column, or diagonal.
public struct NQueensProblem: Problem {
	/// Describes the violations found during evaluation.
	public struct Diagnostic: Sendable, Equatable {
		/// Positions whose queens participate in at least one conflict.
		///
		/// An empty set in the ``Evaluation/unsolved(_:)`` case means
		/// there are no conflicts yet but not enough queens have been placed.
		public let conflicts: Set<Position>
	}

	public init() {}

	/// Evaluates whether the board is a valid N-Queens solution.
	///
	/// - Parameters:
	///   - board: A board of size 32 or smaller.
	///   - moves: The move history used to reach this board state.
	/// - Returns: ``Evaluation/solved`` when exactly *N* non-conflicting queens
	///   are placed, or ``Evaluation/unsolved(_:)`` with the conflicting
	///   positions otherwise.
	public func evaluate(
		on board: Board,
		moves: [Move]
	) -> Evaluation<Diagnostic> {
		let conflicts = computeConflicts(on: board)
		if conflicts.isEmpty && board.occupiedSquares.count == board.size {
			return .solved
		}
		return .unsolved(Diagnostic(conflicts: conflicts))
	}

	/// Returns the set of queen positions involved in at least one conflict.
	///
	/// Uses bitmask tracking across rows, columns, diagonals, and
	/// anti-diagonals for O(*n*) detection where *n* is the number of queens.
	private func computeConflicts(on board: Board) -> Set<Position> {
		precondition(board.size <= 32, "Board size must be at most 32")

		var queens: [Position] = []
		queens.reserveCapacity(board.occupiedSquares.count)
		for (position, occupant) in board.occupiedSquares where occupant.piece == .queen {
			queens.append(position)
		}
		guard queens.count > 1 else { return [] }

		let diagonalOffset = board.size - 1

		var seenRows: UInt64 = 0
		var seenColumns: UInt64 = 0
		var seenDiagonals: UInt64 = 0
		var seenAntiDiagonals: UInt64 = 0

		var duplicateRows: UInt64 = 0
		var duplicateColumns: UInt64 = 0
		var duplicateDiagonals: UInt64 = 0
		var duplicateAntiDiagonals: UInt64 = 0

		for position in queens {
			let rowBit = UInt64(1) << UInt64(position.row)
			let columnBit = UInt64(1) << UInt64(position.column)
			let diagonalIndex = position.row - position.column + diagonalOffset
			let antiDiagonalIndex = position.row + position.column

			if (seenRows & rowBit) != 0 {
				duplicateRows |= rowBit
			} else {
				seenRows |= rowBit
			}

			if (seenColumns & columnBit) != 0 {
				duplicateColumns |= columnBit
			} else {
				seenColumns |= columnBit
			}

			let diagonalBit = UInt64(1) << UInt64(diagonalIndex)
			if (seenDiagonals & diagonalBit) != 0 {
				duplicateDiagonals |= diagonalBit
			} else {
				seenDiagonals |= diagonalBit
			}

			let antiDiagonalBit = UInt64(1) << UInt64(antiDiagonalIndex)
			if (seenAntiDiagonals & antiDiagonalBit) != 0 {
				duplicateAntiDiagonals |= antiDiagonalBit
			} else {
				seenAntiDiagonals |= antiDiagonalBit
			}
		}

		var result: Set<Position> = []
		result.reserveCapacity(queens.count)
		for position in queens {
			let rowBit = UInt64(1) << UInt64(position.row)
			let columnBit = UInt64(1) << UInt64(position.column)
			let diagonalBit =
				UInt64(1) << UInt64(position.row - position.column + diagonalOffset)
			let antiDiagonalBit = UInt64(1) << UInt64(position.row + position.column)
			if (duplicateRows & rowBit) != 0
				|| (duplicateColumns & columnBit) != 0
				|| (duplicateDiagonals & diagonalBit) != 0
				|| (duplicateAntiDiagonals & antiDiagonalBit) != 0
			{
				result.insert(position)
			}
		}

		return result
	}
}
