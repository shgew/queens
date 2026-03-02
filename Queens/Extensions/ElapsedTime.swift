import Foundation

extension TimeInterval {
  func formattedElapsedTime(fractionalSecondsLength: Int = 2) -> String {
    Duration
      .seconds(max(self, 0))
      .formatted(
        .time(
          pattern: .minuteSecond(
            padMinuteToLength: 2,
            fractionalSecondsLength: fractionalSecondsLength
          )
        )
      )
  }
}
