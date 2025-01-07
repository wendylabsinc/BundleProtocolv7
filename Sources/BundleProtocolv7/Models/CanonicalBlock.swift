#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

public struct CanonicalBlock: Sendable {
    public struct ControlFlags: OptionSet, Sendable {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let mustBeReplicatedInEveryFragment = ControlFlags(rawValue: 1 << 0)
        public static let statusReportRequested = ControlFlags(rawValue: 1 << 1)
        public static let deleteBundleIfCannotProcess = ControlFlags(rawValue: 1 << 2)
        public static let discardBlockIfCannotProcess = ControlFlags(rawValue: 1 << 4)
    }
    
    public let blockType: UInt
    public let blockNumber: UInt
    public let controlFlags: ControlFlags
    public let crc: CRC
    public let data: Data
    
    public init(
        blockType: UInt,
        blockNumber: UInt,
        controlFlags: ControlFlags,
        crc: CRC,
        data: Data
    ) {
        self.blockType = blockType
        self.blockNumber = blockNumber
        self.controlFlags = controlFlags
        self.crc = crc
        self.data = data
    }
} 