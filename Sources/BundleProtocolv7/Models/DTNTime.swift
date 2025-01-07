#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

/// Represents DTN time as milliseconds since DTN Epoch (2000-01-01 00:00:00 +0000 UTC)
public struct DTNTime: Sendable {
    public let milliseconds: UInt
    
    /// Constants for epoch conversions
    public static let secondsFrom1970To2000: UInt = 946_684_800
    public static let millisecondsFrom1970To2000: UInt = 946_684_800_000
    public static let dtnTimeEpoch: UInt = 0
    
    public init(milliseconds: UInt = 0) {
        self.milliseconds = milliseconds
    }
    
    /// Creates DTN time from a Date
    public init(date: Date) {
        let dtnEpoch = Date(timeIntervalSince1970: TimeInterval(Self.secondsFrom1970To2000)) // 2000-01-01 00:00:00 UTC
        let milliseconds = UInt(date.timeIntervalSince(dtnEpoch) * 1000)
        self.init(milliseconds: milliseconds)
    }
    
    /// Convert to Unix timestamp (in seconds)
    public var unixTimestamp: UInt {
        (milliseconds + Self.millisecondsFrom1970To2000) / 1000
    }
    
    /// Convert to human readable RFC3339 compliant time string
    public var rfc3339String: String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTimestamp))
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: date)
    }
    
    /// Get current time as DTNTime
    public static func now() -> DTNTime {
        let currentTimeMillis = UInt(Date().timeIntervalSince1970 * 1000)
        return DTNTime(milliseconds: currentTimeMillis - millisecondsFrom1970To2000)
    }
} 