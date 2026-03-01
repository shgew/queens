import Foundation
import OSLog

private final class LogBundleToken: NSObject {}

/// Convenience logging helpers used across Queens modules.
public extension Logger {
  /// Creates a logger scoped to the Queens subsystem and a category.
  ///
  /// - Parameter category: The logical area this logger writes under.
  /// - Returns: A configured logger for Queens logging.
  static func queens(category: LoggingCategory) -> Logger {
    Logger(
      subsystem: Bundle.main.bundleIdentifier
        ?? Bundle(for: LogBundleToken.self).bundleIdentifier
        ?? "com.glebshevchenko.Queens",
      category: category.rawValue
    )
  }
}
