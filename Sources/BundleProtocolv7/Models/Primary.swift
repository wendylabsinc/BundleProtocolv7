#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

public struct PrimaryBlock: Sendable {
    public let version: UInt = 7
    public let bundleControlFlags: Bundle.ControlFlags
    public let crc: CRC
    public let destination: EndpointID
    public let source: EndpointID
    public let reportTo: EndpointID
    public let creationTimestamp: CreationTimestamp
    public let lifetime: UInt // in milliseconds
    public let fragmentOffset: UInt?
    public let totalDataLength: UInt?
    
    public init(
        bundleControlFlags: Bundle.ControlFlags = [],
        crc: CRC = CRC(type: .none),
        destination: EndpointID,
        source: EndpointID,
        reportTo: EndpointID,
        creationTimestamp: CreationTimestamp,
        lifetime: UInt,
        fragmentOffset: UInt? = nil,
        totalDataLength: UInt? = nil
    ) {
        self.bundleControlFlags = bundleControlFlags
        self.crc = crc
        self.destination = destination
        self.source = source
        self.reportTo = reportTo
        self.creationTimestamp = creationTimestamp
        self.lifetime = lifetime
        self.fragmentOffset = fragmentOffset
        self.totalDataLength = totalDataLength
    }
    
    public static func new() -> PrimaryBlock {
        return PrimaryBlock(
            destination: .null,
            source: .null,
            reportTo: .null,
            creationTimestamp: CreationTimestamp(time: DTNTime(), sequenceNumber: 0),
            lifetime: 0
        )
    }
    
    public var hasFragmentation: Bool {
        bundleControlFlags.contains(.isFragment)
    }
    
    public func isLifetimeExceeded() -> Bool {
        guard creationTimestamp.time.milliseconds != 0 else {
            return false
        }
        
        let now = DTNTime(date: Date())
        return creationTimestamp.time.milliseconds + lifetime <= now.milliseconds
    }
    
    public func validate() throws {
        var errors: ErrorList = []
        
        if version != 7 {
            errors.append(.primaryBlockError("Wrong version, \(version) instead of 7"))
        }
        
        // Add more validation as needed
        
        if !errors.isEmpty {
            throw errors[0] // For now just throw the first error
        }
    }
}

// Builder pattern implementation
public struct PrimaryBlockBuilder {
    private var bundleControlFlags: Bundle.ControlFlags = []
    private var crc: CRC = CRC(type: .none)
    private var destination: EndpointID = .null
    private var source: EndpointID = .null
    private var reportTo: EndpointID = .null
    private var creationTimestamp = CreationTimestamp(time: DTNTime(), sequenceNumber: 0)
    private var lifetime: UInt = 0
    private var fragmentOffset: UInt?
    private var totalDataLength: UInt?
    
    public init() {}
    
    public func bundleControlFlags(_ flags: Bundle.ControlFlags) -> PrimaryBlockBuilder {
        var builder = self
        builder.bundleControlFlags = flags
        return builder
    }
    
    public func crc(_ crc: CRC) -> PrimaryBlockBuilder {
        var builder = self
        builder.crc = crc
        return builder
    }
    
    public func destination(_ dest: EndpointID) -> PrimaryBlockBuilder {
        var builder = self
        builder.destination = dest
        return builder
    }
    
    public func source(_ source: EndpointID) -> PrimaryBlockBuilder {
        var builder = self
        builder.source = source
        return builder
    }
    
    public func reportTo(_ reportTo: EndpointID) -> PrimaryBlockBuilder {
        var builder = self
        builder.reportTo = reportTo
        return builder
    }
    
    public func creationTimestamp(_ timestamp: CreationTimestamp) -> PrimaryBlockBuilder {
        var builder = self
        builder.creationTimestamp = timestamp
        return builder
    }
    
    public func lifetime(_ lifetime: UInt) -> PrimaryBlockBuilder {
        var builder = self
        builder.lifetime = lifetime
        return builder
    }
    
    public func fragmentOffset(_ offset: UInt) -> PrimaryBlockBuilder {
        var builder = self
        builder.fragmentOffset = offset
        return builder
    }
    
    public func totalDataLength(_ length: UInt) -> PrimaryBlockBuilder {
        var builder = self
        builder.totalDataLength = length
        return builder
    }
    
    public func build() throws -> PrimaryBlock {
        if destination == .null {
            throw BPv7Error.primaryBlockError("No destination endpoint was provided")
        }
        
        return PrimaryBlock(
            bundleControlFlags: bundleControlFlags,
            crc: crc,
            destination: destination,
            source: source,
            reportTo: reportTo,
            creationTimestamp: creationTimestamp,
            lifetime: lifetime,
            fragmentOffset: fragmentOffset,
            totalDataLength: totalDataLength
        )
    }
}

// Helper function similar to Rust's new_primary_block
public func newPrimaryBlock(
    destination: String,
    source: String,
    creationTimestamp: CreationTimestamp,
    lifetime: UInt
) throws -> PrimaryBlock {
    // Note: In a real implementation, you'd need to parse the endpoint strings
    let destEid = EndpointID(scheme: .dtn, ssp: destination)
    let srcEid = EndpointID(scheme: .dtn, ssp: source)
    
    return PrimaryBlock(
        destination: destEid,
        source: srcEid,
        reportTo: srcEid,
        creationTimestamp: creationTimestamp,
        lifetime: lifetime
    )
}
