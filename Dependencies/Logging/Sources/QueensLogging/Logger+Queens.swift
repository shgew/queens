import Foundation
import OSLog

private final class LogBundleToken: NSObject {}

public extension Logger {
  static func queens(category: LoggingCategory) -> Logger {
    Logger(
      subsystem: Bundle.main.bundleIdentifier
        ?? Bundle(for: LogBundleToken.self).bundleIdentifier
        ?? "com.glebshevchenko.Queens",
      category: category.rawValue
    )
  }
}
