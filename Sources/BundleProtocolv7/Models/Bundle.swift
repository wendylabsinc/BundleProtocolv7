#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

public struct Bundle: Sendable {
    public struct ControlFlags: OptionSet, Sendable {
        public let rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        public static let isFragment = ControlFlags(rawValue: 1 << 0)
        public static let isAdminRecord = ControlFlags(rawValue: 1 << 1)
        public static let mustNotFragment = ControlFlags(rawValue: 1 << 2)
        public static let requestAck = ControlFlags(rawValue: 1 << 5)
        public static let statusTimeRequested = ControlFlags(rawValue: 1 << 6)
        public static let requestReceptionReport = ControlFlags(rawValue: 1 << 14)
        public static let requestForwardReport = ControlFlags(rawValue: 1 << 16)
        public static let requestDeliveryReport = ControlFlags(rawValue: 1 << 17)
        public static let requestDeletionReport = ControlFlags(rawValue: 1 << 18)
    }
    
    public let version: UInt = 7
    public let controlFlags: ControlFlags
    public let crc: CRC
    public let destination: EndpointID
    public let sourceNode: EndpointID
    public let reportTo: EndpointID
    public let creationTimestamp: CreationTimestamp
    public let lifetime: UInt
    public let fragmentOffset: UInt?
    public let totalApplicationDataLength: UInt?
    public let blocks: [CanonicalBlock]
    
    public init(
        controlFlags: ControlFlags,
        crc: CRC,
        destination: EndpointID,
        sourceNode: EndpointID,
        reportTo: EndpointID,
        creationTimestamp: CreationTimestamp,
        lifetime: UInt,
        fragmentOffset: UInt? = nil,
        totalApplicationDataLength: UInt? = nil,
        blocks: [CanonicalBlock]
    ) {
        self.controlFlags = controlFlags
        self.crc = crc
        self.destination = destination
        self.sourceNode = sourceNode
        self.reportTo = reportTo
        self.creationTimestamp = creationTimestamp
        self.lifetime = lifetime
        self.fragmentOffset = fragmentOffset
        self.totalApplicationDataLength = totalApplicationDataLength
        self.blocks = blocks
    }
} 