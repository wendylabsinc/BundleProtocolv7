#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

// Block type constants
public extension UInt {
    static let payloadBlock: UInt = 1
    static let integrityBlock: UInt = 2
    static let confidentialityBlock: UInt = 3
    static let manifestBlock: UInt = 4
    static let flowLabelBlock: UInt = 6
    static let previousNodeBlock: UInt = 6
    static let bundleAgeBlock: UInt = 7
    static let hopCountBlock: UInt = 10
}

public enum CanonicalData: Sendable, Equatable {
    case hopCount(limit: UInt8, count: UInt8)
    case data(Data)
    case bundleAge(UInt64)
    case previousNode(EndpointID)
    case unknown(Data)
    case decodingError
}

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
    private var data: CanonicalData
    
    public init(
        blockType: UInt,
        blockNumber: UInt,
        controlFlags: ControlFlags,
        crc: CRC,
        data: CanonicalData
    ) {
        self.blockType = blockType
        self.blockNumber = blockNumber
        self.controlFlags = controlFlags
        self.crc = crc
        self.data = data
    }
    
    public static func new() -> CanonicalBlock {
        return CanonicalBlock(
            blockType: .payloadBlock,
            blockNumber: 0,
            controlFlags: [],
            crc: CRC(type: .none),
            data: .data(Data())
        )
    }
    
    public func validate() throws {
        let errors: ErrorList = []
        
        // Add validation logic here
        
        try validateExtension()
        
        if !errors.isEmpty {
            throw errors[0]
        }
    }
    
    private func validateExtension() throws {
        switch data {
        case .data:
            if blockType != .payloadBlock {
                throw BPv7Error.canonicalBlockError("Payload data not matching payload type")
            }
            if blockNumber != 1 {
                throw BPv7Error.canonicalBlockError("Payload Block's block number is not one")
            }
        case .bundleAge:
            if blockType != .bundleAgeBlock {
                throw BPv7Error.canonicalBlockError("Payload data not matching payload type")
            }
        case .hopCount:
            if blockType != .hopCountBlock {
                throw BPv7Error.canonicalBlockError("Payload data not matching payload type")
            }
        case .previousNode(_):
            if blockType != .previousNodeBlock {
                throw BPv7Error.canonicalBlockError("Payload data not matching payload type")
            }
            // Add endpoint validation if needed
        case .unknown:
            break // Nothing to check as content is unknown
        case .decodingError:
            throw BPv7Error.canonicalBlockError("Unknown data")
        }
    }
    
    public func getData() -> CanonicalData {
        return data
    }
    
    public mutating func setData(_ newData: CanonicalData) {
        data = newData
    }
    
    public func getPayloadData() -> Data? {
        if case .data(let data) = data {
            return data
        }
        return nil
    }
    
    public func getHopCount() -> (limit: UInt8, count: UInt8)? {
        if blockType == .hopCountBlock {
            if case .hopCount(let limit, let count) = data {
                return (limit, count)
            }
        }
        return nil
    }
    
    public mutating func increaseHopCount() -> Bool {
        if var hopCount = getHopCount() {
            hopCount.count += 1
            data = .hopCount(limit: hopCount.limit, count: hopCount.count)
            return true
        }
        return false
    }
    
    public func isHopCountExceeded() -> Bool {
        if let (limit, count) = getHopCount() {
            return count > limit
        }
        return false
    }
    
    public mutating func updateBundleAge(_ age: UInt64) -> Bool {
        if getBundleAge() != nil {
            data = .bundleAge(age)
            return true
        }
        return false
    }
    
    public func getBundleAge() -> UInt64? {
        if blockType == .bundleAgeBlock {
            if case .bundleAge(let age) = data {
                return age
            }
        }
        return nil
    }
    
    public mutating func updatePreviousNode(_ nodeId: EndpointID) -> Bool {
        if getPreviousNode() != nil {
            data = .previousNode(nodeId)
            return true
        }
        return false
    }
    
    public func getPreviousNode() -> EndpointID? {
        if blockType == .previousNodeBlock {
            if case .previousNode(let eid) = data {
                return eid
            }
        }
        return nil
    }
}

// Helper functions to create specific block types
public func newHopCountBlock(blockNumber: UInt, controlFlags: CanonicalBlock.ControlFlags, limit: UInt8) -> CanonicalBlock {
    return CanonicalBlock(
        blockType: .hopCountBlock,
        blockNumber: blockNumber,
        controlFlags: controlFlags,
        crc: CRC(type: .none),
        data: .hopCount(limit: limit, count: 0)
    )
}

public func newPayloadBlock(controlFlags: CanonicalBlock.ControlFlags, data: Data) -> CanonicalBlock {
    return CanonicalBlock(
        blockType: .payloadBlock,
        blockNumber: 1,
        controlFlags: controlFlags,
        crc: CRC(type: .none),
        data: .data(data)
    )
}

public func newPreviousNodeBlock(blockNumber: UInt, controlFlags: CanonicalBlock.ControlFlags, prev: EndpointID) -> CanonicalBlock {
    return CanonicalBlock(
        blockType: .previousNodeBlock,
        blockNumber: blockNumber,
        controlFlags: controlFlags,
        crc: CRC(type: .none),
        data: .previousNode(prev)
    )
}

public func newBundleAgeBlock(blockNumber: UInt, controlFlags: CanonicalBlock.ControlFlags, timeInMillis: UInt64) -> CanonicalBlock {
    return CanonicalBlock(
        blockType: .bundleAgeBlock,
        blockNumber: blockNumber,
        controlFlags: controlFlags,
        crc: CRC(type: .none),
        data: .bundleAge(timeInMillis)
    )
} 