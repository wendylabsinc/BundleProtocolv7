import Foundation

/// Represents all possible errors that can occur in the BPv7 implementation
public enum BPv7Error: LocalizedError {
    case canonicalBlockError(String)
    case primaryBlockError(String)
    case endpointIdError(Error)
    case dtnTimeError(String)
    case crcError(String)
    case bundleError(String)
    case bundleControlFlagsError(String)
    case blockControlFlagsError(String)
    case jsonDecodeError(Error)
    case cborDecodeError(Error)
    
    public var errorDescription: String? {
        switch self {
        case .canonicalBlockError(let message):
            return "Canonical Block Error: \(message)"
        case .primaryBlockError(let message):
            return "Primary Block Error: \(message)"
        case .endpointIdError(let error):
            return "Endpoint ID Error: \(error.localizedDescription)"
        case .dtnTimeError(let message):
            return "DTN Time Error: \(message)"
        case .crcError(let message):
            return "CRC Error: \(message)"
        case .bundleError(let message):
            return "Bundle Error: \(message)"
        case .bundleControlFlagsError(let message):
            return "Bundle Control Flags Error: \(message)"
        case .blockControlFlagsError(let message):
            return "Block Control Flags Error: \(message)"
        case .jsonDecodeError(let error):
            return "JSON Decode Error: \(error.localizedDescription)"
        case .cborDecodeError(let error):
            return "CBOR Decode Error: \(error.localizedDescription)"
        }
    }
}

/// A type alias for a list of BPv7 errors
public typealias ErrorList = [BPv7Error]
