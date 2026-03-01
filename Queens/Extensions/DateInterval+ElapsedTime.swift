import Foundation

extension Date {
	func formattedElapsedTime(to endDate: Date) -> String {
		let elapsed = Duration.seconds(
			max(0, endDate.timeIntervalSince(self))
		)
		let pattern: Duration.TimeFormatStyle.Pattern
		if elapsed >= .seconds(3600) {
			pattern = .hourMinuteSecond
		} else {
			pattern = .minuteSecond(padMinuteToLength: 2)
		}
		return elapsed.formatted(.time(pattern: pattern))
	}
}
