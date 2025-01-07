#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

public enum CRCType: UInt, Sendable {
    case none = 0
    case crc16 = 1  // X-25 CRC-16
    case crc32 = 2  // CRC32C (Castagnoli)
}

public struct CRC: Sendable {
    public let type: CRCType
    public let value: Data?
    
    public init(type: CRCType, value: Data? = nil) {
        self.type = type
        self.value = value
    }
} 