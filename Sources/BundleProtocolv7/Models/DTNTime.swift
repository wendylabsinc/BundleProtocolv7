#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

/// Represents DTN time as milliseconds since DTN Epoch (2000-01-01 00:00:00 +0000 UTC)
public struct DTNTime: Sendable {
    public let milliseconds: UInt
    
    public init(milliseconds: UInt = 0) {
        self.milliseconds = milliseconds
    }
    
    /// Creates DTN time from a Date
    public init(date: Date) {
        let dtnEpoch = Date(timeIntervalSince1970: 946684800) // 2000-01-01 00:00:00 UTC
        let milliseconds = UInt(date.timeIntervalSince(dtnEpoch) * 1000)
        self.init(milliseconds: milliseconds)
    }
} 