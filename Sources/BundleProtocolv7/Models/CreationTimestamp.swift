#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif
import Atomics

/// Timestamp when a bundle was created, consisting of the DTNTime and a sequence number.
public struct CreationTimestamp: Sendable, CustomStringConvertible {
    public let time: DTNTime
    public let sequenceNumber: UInt
    
    // Atomic storage for sequence number generation
    private static let lastCreationTime = ManagedAtomic<UInt>(0)
    private static let lastSequenceNumber = ManagedAtomic<UInt>(0)
    
    public init(time: DTNTime = .init(), sequenceNumber: UInt = 0) {
        self.time = time
        self.sequenceNumber = sequenceNumber
    }
    
    /// Create a new timestamp with automatic sequence counting
    public static func now() -> CreationTimestamp {
        let currentTime = DTNTime.now()
        
        // Compare and set the last creation time atomically
        let oldTime = lastCreationTime.exchange(currentTime.milliseconds, ordering: .sequentiallyConsistent)
        if currentTime.milliseconds != oldTime {
            lastSequenceNumber.store(0, ordering: .sequentiallyConsistent)
        }
        
        let seqNo = lastSequenceNumber.loadThenWrappingIncrement(ordering: .sequentiallyConsistent)
        return CreationTimestamp(time: currentTime, sequenceNumber: seqNo)
    }
    
    public var description: String {
        "\(time.rfc3339String) \(sequenceNumber)"
    }
} 