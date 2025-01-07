#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

public struct CreationTimestamp: Sendable {
    public let time: DTNTime
    public let sequenceNumber: UInt
    
    public init(time: DTNTime, sequenceNumber: UInt) {
        self.time = time
        self.sequenceNumber = sequenceNumber
    }
} 