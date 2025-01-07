#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

public struct EndpointID: Sendable {
    public enum Scheme: UInt, Sendable {
        case dtn = 1
        case ipn = 2
    }
    
    public let scheme: Scheme
    public let ssp: String // Scheme-specific part
    
    public init(scheme: Scheme, ssp: String) {
        self.scheme = scheme
        self.ssp = ssp
    }
    
    /// Creates a null endpoint ID
    public static let null = EndpointID(scheme: .dtn, ssp: "none")
} 