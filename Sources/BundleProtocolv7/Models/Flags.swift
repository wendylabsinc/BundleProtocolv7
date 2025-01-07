import Foundation

/// Type alias for block control flags
public typealias BlockControlFlagsType = UInt8

/// Block Control Flags implementation
@frozen public struct BlockControlFlags: OptionSet, Sendable {
    public let rawValue: BlockControlFlagsType
    
    public init(rawValue: BlockControlFlagsType) {
        self.rawValue = rawValue
    }
    
    /// This block must be replicated in every fragment
    public static let blockReplicate = BlockControlFlags(rawValue: 0x01)
    
    /// Transmit status report if block can't be processed
    public static let blockStatusReport = BlockControlFlags(rawValue: 0x02)
    
    /// Delete bundle if block can't be processed
    public static let blockDeleteBundle = BlockControlFlags(rawValue: 0x04)
    
    /// Discard block if it can't be processed
    public static let blockRemove = BlockControlFlags(rawValue: 0x10)
    
    /// Reserved fields mask
    public static let blockCFReservedFields = BlockControlFlags(rawValue: 0xF0)
}

/// Protocol for block validation
public protocol BlockValidation {
    var flags: BlockControlFlags { get }
    mutating func set(_ flags: BlockControlFlags)
    func validate() throws
    func contains(_ flags: BlockControlFlags) -> Bool
}

extension BlockValidation {
    public func validate() throws {
        if flags.contains(.blockCFReservedFields) {
            throw BPv7Error.blockControlFlagsError("Given flag contains reserved bits")
        }
    }
    
    public func contains(_ flags: BlockControlFlags) -> Bool {
        return self.flags.contains(flags)
    }
}

extension BlockControlFlagsType: BlockValidation {
    public var flags: BlockControlFlags {
        return BlockControlFlags(rawValue: self)
    }
    
    public mutating func set(_ flags: BlockControlFlags) {
        self = flags.rawValue
    }
}

/// Type alias for bundle control flags
public typealias BundleControlFlagsType = UInt64

/// Bundle Control Flags implementation
@frozen public struct BundleControlFlags: OptionSet, Sendable {
    public let rawValue: BundleControlFlagsType
    
    public init(rawValue: BundleControlFlagsType) {
        self.rawValue = rawValue
    }
    
    /// Request reporting of bundle deletion
    public static let bundleStatusRequestDeletion = BundleControlFlags(rawValue: 0x040000)
    
    /// Request reporting of bundle delivery
    public static let bundleStatusRequestDelivery = BundleControlFlags(rawValue: 0x020000)
    
    /// Request reporting of bundle forwarding
    public static let bundleStatusRequestForward = BundleControlFlags(rawValue: 0x010000)
    
    /// Request reporting of bundle reception
    public static let bundleStatusRequestReception = BundleControlFlags(rawValue: 0x004000)
    
    /// Status time requested in reports
    public static let bundleRequestStatusTime = BundleControlFlags(rawValue: 0x000040)
    
    /// Acknowledgment by application is requested
    public static let bundleRequestUserApplicationAck = BundleControlFlags(rawValue: 0x000020)
    
    /// Bundle must not be fragmented
    public static let bundleMustNotFragmented = BundleControlFlags(rawValue: 0x000004)
    
    /// ADU is an administrative record
    public static let bundleAdministrativeRecordPayload = BundleControlFlags(rawValue: 0x000002)
    
    /// The bundle is a fragment
    public static let bundleIsFragment = BundleControlFlags(rawValue: 0x000001)
    
    /// Reserved fields mask
    public static let bundleCFReservedFields = BundleControlFlags(rawValue: 0xE218)
}

/// Protocol for bundle validation
public protocol BundleValidation {
    var flags: BundleControlFlags { get }
    mutating func set(_ flags: BundleControlFlags)
    func validate() throws
    func contains(_ flags: BundleControlFlags) -> Bool
}

extension BundleValidation {
    public func validate() throws {
        var errors: ErrorList = []
        
        if flags.contains(.bundleCFReservedFields) {
            errors.append(BPv7Error.bundleControlFlagsError("Given flag contains reserved bits"))
        }
        
        if flags.contains(.bundleIsFragment) && flags.contains(.bundleMustNotFragmented) {
            errors.append(BPv7Error.bundleControlFlagsError(
                "Both 'bundle is a fragment' and 'bundle must not be fragmented' flags are set"
            ))
        }
        
        let adminRecCheck = !flags.contains(.bundleAdministrativeRecordPayload) ||
            (!flags.contains(.bundleStatusRequestReception) &&
             !flags.contains(.bundleStatusRequestForward) &&
             !flags.contains(.bundleStatusRequestDelivery) &&
             !flags.contains(.bundleStatusRequestDeletion))
        
        if !adminRecCheck {
            errors.append(BPv7Error.bundleControlFlagsError(
                "\"payload is administrative record => no status report request flags\" failed"
            ))
        }
        
        if !errors.isEmpty {
            throw errors[0] // Throwing first error as Swift doesn't support throwing multiple errors
        }
    }
    
    public func contains(_ flags: BundleControlFlags) -> Bool {
        return self.flags.contains(flags)
    }
}

extension BundleControlFlagsType: BundleValidation {
    public var flags: BundleControlFlags {
        return BundleControlFlags(rawValue: self)
    }
    
    public mutating func set(_ flags: BundleControlFlags) {
        self = flags.rawValue
    }
}
