import Testing

@testable import Engine

@Test func `sum is good`() async throws {
    #expect(1 + 2 == 3)
}
