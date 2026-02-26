import Testing

@testable import Engine

@Suite("Game")
struct GameTests {
    @Test func startsIdle() {
        let game = Game()
        #expect(game.phase == .idle)
    }

    @Test func startTransitionsToPlaying() {
        var game = Game()
        game.start()
        #expect(game.phase == .playing)
        #expect(game.board.queens.isEmpty)
    }

    @Test func toggleIgnoredWhenIdle() {
        var game = Game()
        game.toggleQueen(at: Position(row: 0, column: 0))
        #expect(game.board.queens.isEmpty)
    }

    @Test func togglePlacesDuringPlay() {
        var game = Game()
        game.start()
        game.toggleQueen(at: Position(row: 0, column: 1))
        #expect(game.board.queens.count == 1)
    }

    @Test func winsOnCorrectSolution() {
        var game = Game(size: 4)
        game.start()
        game.toggleQueen(at: Position(row: 0, column: 1))
        game.toggleQueen(at: Position(row: 1, column: 3))
        game.toggleQueen(at: Position(row: 2, column: 0))
        game.toggleQueen(at: Position(row: 3, column: 2))
        #expect(game.phase == .won)
    }

    @Test func resetGoesBackToIdle() {
        var game = Game()
        game.start()
        game.toggleQueen(at: Position(row: 0, column: 1))
        game.reset()
        #expect(game.phase == .idle)
        #expect(game.board.queens.isEmpty)
    }
}
