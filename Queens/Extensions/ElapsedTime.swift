import Foundation

extension Date {
  func formattedElapsedTime(to endDate: Date) -> String {
    endDate.timeIntervalSince(self).formattedElapsedTime()
  }
}

extension TimeInterval {
  func formattedElapsedTime() -> String {
    let elapsed = Duration.seconds(max(0, self))
    let pattern: Duration.TimeFormatStyle.Pattern
    if elapsed >= .seconds(3600) {
      pattern = .hourMinuteSecond
    } else {
      pattern = .minuteSecond(padMinuteToLength: 2)
    }
    return elapsed.formatted(.time(pattern: pattern))
  }
}
