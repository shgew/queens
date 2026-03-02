import Foundation
import Testing

@testable import Queens

struct BestTimesTests {
  let userDefaults: MockUserDefaults
  let store: BestTimesStore

  init() {
    self.userDefaults = MockUserDefaults()
    store = BestTimesStore(userDefaults: userDefaults, keyPrefix: "test.bestTimes")
  }

  @Test func `returns nil for unseen size`() {
    let result = store.bestTime(for: 4)
    #expect(result == nil)
  }

  @Test func `records first time`() {
    let isNew = store.record(time: 10.0, for: 4)

    #expect(isNew)
    #expect(store.bestTime(for: 4) == 10.0)
  }

  @Test func `faster time becomes new best`() {
    store.record(time: 10.0, for: 4)
    let isNew = store.record(time: 7.0, for: 4)

    #expect(isNew)
    #expect(store.bestTime(for: 4) == 7.0)
  }

  @Test func `slower time is ignored`() {
    store.record(time: 10.0, for: 4)
    let isNew = store.record(time: 15.0, for: 4)

    #expect(!isNew)
    #expect(store.bestTime(for: 4) == 10.0)
  }

  @Test func `equal time does not replace existing`() {
    store.record(time: 10.0, for: 4)
    let isNew = store.record(time: 10.0, for: 4)

    #expect(!isNew)
    #expect(store.bestTime(for: 4) == 10.0)
  }

  @Test func `different sizes are independent`() {
    store.record(time: 10.0, for: 4)
    store.record(time: 20.0, for: 8)

    #expect(store.bestTime(for: 4) == 10.0)
    #expect(store.bestTime(for: 8) == 20.0)
  }
}
