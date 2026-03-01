import Foundation
import SwiftData
import Testing

@testable import Queens

struct BestTimesTests {
  let container: ModelContainer
  let store: BestTimesStore

  init() {
    container = Self.makeInMemoryContainer()
    store = BestTimesStore(modelContainer: container)
  }

  @Test func `returns nil for unseen size`() async {
    let result = await store.bestTime(for: 4)
    #expect(result == nil)
  }

  @Test func `records first time`() async {
    let isNew = await store.record(time: 10.0, for: 4)

    #expect(isNew)
    #expect(await store.bestTime(for: 4) == 10.0)
  }

  @Test func `faster time becomes new best`() async {
    await store.record(time: 10.0, for: 4)
    let isNew = await store.record(time: 7.0, for: 4)

    #expect(isNew)
    #expect(await store.bestTime(for: 4) == 7.0)
    #expect(fetchTimes(for: 4).count == 2)
  }

  @Test func `slower time is kept when top list has room`() async {
    await store.record(time: 10.0, for: 4)
    let isNew = await store.record(time: 15.0, for: 4)

    #expect(!isNew)
    #expect(await store.bestTime(for: 4) == 10.0)
    #expect(fetchTimes(for: 4).count == 2)
  }

  @Test func `equal time does not replace existing`() async {
    await store.record(time: 10.0, for: 4)
    let isNew = await store.record(time: 10.0, for: 4)

    #expect(!isNew)
  }

  @Test func `different sizes are independent`() async {
    await store.record(time: 10.0, for: 4)
    await store.record(time: 20.0, for: 8)

    #expect(await store.bestTime(for: 4) == 10.0)
    #expect(await store.bestTime(for: 8) == 20.0)
  }

  @Test func `keeps only top ten times per size`() async {
    for time in stride(from: 20.0, through: 1.0, by: -1.0) {
      _ = await store.record(time: time, for: 4)
    }

    let savedTimes = fetchTimes(for: 4)
    #expect(savedTimes.count == 10)
    #expect(savedTimes.first == 1.0)
    #expect(savedTimes.last == 10.0)
  }

  @Test func `drops slower non-qualifying time when top ten full`() async {
    for time in stride(from: 10.0, through: 1.0, by: -1.0) {
      _ = await store.record(time: time, for: 4)
    }
    let isNew = await store.record(time: 99.0, for: 4)

    #expect(!isNew)
    #expect(fetchTimes(for: 4).count == 10)
    #expect(fetchTimes(for: 4).last == 10.0)
  }
}

extension BestTimesTests {
  private static func makeInMemoryContainer() -> ModelContainer {
    do {
      let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
      return try ModelContainer(for: BestTimeRecord.self, configurations: configuration)
    } catch {
      fatalError("Failed to create in-memory SwiftData container for tests: \(error)")
    }
  }

  private func fetchTimes(for boardSize: Int) -> [TimeInterval] {
    let context = ModelContext(container)
    let descriptor = FetchDescriptor<BestTimeRecord>(
      predicate: #Predicate { record in
        record.boardSize == boardSize
      },
      sortBy: [
        SortDescriptor(\.time, order: .forward)
      ]
    )

    do {
      return try context.fetch(descriptor).map(\.time)
    } catch {
      Issue.record("Failed to fetch top times for test: \(error)")
      return []
    }
  }
}
