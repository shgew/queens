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

    @Test func toggleIgnoredWhenIdle() throws {
        var game = Game()
        try game.toggleQueen(at: Position(row: 0, column: 0))
        #expect(game.board.queens.isEmpty)
    }

    @Test func togglePlacesDuringPlay() throws {
        var game = Game()
        game.start()
        try game.toggleQueen(at: Position(row: 0, column: 1))
        #expect(game.board.queens.count == 1)
    }

    @Test func winsOnCorrectSolution() throws {
        var game = Game(size: 4)
        game.start()
        try game.toggleQueen(at: Position(row: 0, column: 1))
        try game.toggleQueen(at: Position(row: 1, column: 3))
        try game.toggleQueen(at: Position(row: 2, column: 0))
        try game.toggleQueen(at: Position(row: 3, column: 2))
        #expect(game.phase == .won)
    }

    @Test func resetGoesBackToIdle() throws {
        var game = Game()
        game.start()
        try game.toggleQueen(at: Position(row: 0, column: 1))
        game.reset()
        #expect(game.phase == .idle)
        #expect(game.board.queens.isEmpty)
    }
}
