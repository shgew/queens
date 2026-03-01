import Foundation
import Testing

@testable import Queens

struct DateElapsedTimeTests {
  @Test func zeroDuration() {
    let date = Date.now
    #expect(date.formattedElapsedTime(to: date) == "00:00")
  }

  @Test func negativeDurationClampsToZero() {
    let start = Date.now
    let earlier = start.addingTimeInterval(-60)
    #expect(start.formattedElapsedTime(to: earlier) == "00:00")
  }

  @Test func subHourUsesMinuteSecondFormat() {
    let start = Date.now
    let end = start.addingTimeInterval(125) // 2 minutes 5 seconds
    #expect(start.formattedElapsedTime(to: end) == "02:05")
  }

  @Test func hourPlusDurationUsesHourMinuteSecondFormat() {
    let start = Date.now
    let end = start.addingTimeInterval(3661) // 1:01:01
    #expect(start.formattedElapsedTime(to: end) == "1:01:01")
  }

  @Test func exactOneHourBoundaryUsesHourFormat() {
    let start = Date.now
    let end = start.addingTimeInterval(3600)
    #expect(start.formattedElapsedTime(to: end) == "1:00:00")
  }
}
