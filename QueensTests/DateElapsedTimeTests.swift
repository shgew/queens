import Foundation
import Testing

@testable import Queens

struct DateElapsedTimeTests {
  @Test func `zero duration`() {
    let date = Date.now
    #expect(date.formattedElapsedTime(to: date) == "00:00")
  }

  @Test func `negative duration clamps to zero`() {
    let start = Date.now
    let earlier = start.addingTimeInterval(-60)
    #expect(start.formattedElapsedTime(to: earlier) == "00:00")
  }

  @Test func `sub-hour uses minute second format`() {
    let start = Date.now
    let end = start.addingTimeInterval(125)  // 2 minutes 5 seconds
    #expect(start.formattedElapsedTime(to: end) == "02:05")
  }

  @Test func `hour-plus duration uses hour minute second format`() {
    let start = Date.now
    let end = start.addingTimeInterval(3661)  // 1:01:01
    #expect(start.formattedElapsedTime(to: end) == "1:01:01")
  }

  @Test func `exact one hour boundary uses hour format`() {
    let start = Date.now
    let end = start.addingTimeInterval(3600)
    #expect(start.formattedElapsedTime(to: end) == "1:00:00")
  }
}
