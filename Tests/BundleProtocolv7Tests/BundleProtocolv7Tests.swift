import Testing
#if canImport(Darwin)
import Foundation // Use full Foundation on macOS/iOS/watchOS/tvOS
#else
import FoundationEssential // Use FoundationEssential on other platforms
#endif

@testable import BundleProtocolv7

final class BundleProtocolv7Tests {
    
    @Test func testDTNTime() throws {
        let time = DTNTime(milliseconds: 1000)
        #expect(time.milliseconds == 1000)
        
        let date = Date(timeIntervalSince1970: 946684800 + 1) // DTN epoch + 1 second
        let dtnTime = DTNTime(date: date)
        #expect(dtnTime.milliseconds == 1000)
    }
    
    @Test func testEndpointID() throws {
        let nullEndpoint = EndpointID.null
        #expect(nullEndpoint.scheme == .dtn)
        #expect(nullEndpoint.ssp == "none")
        
        let endpoint = EndpointID(scheme: .ipn, ssp: "1.1")
        #expect(endpoint.scheme == .ipn)
        #expect(endpoint.ssp == "1.1")
    }
    
    @Test func testBundleControlFlags() throws {
        var flags = Bundle.ControlFlags()
        #expect(flags.isEmpty)
        
        flags.insert(.isFragment)
        #expect(flags.contains(.isFragment))
        #expect(!flags.contains(.isAdminRecord))
        
        flags.insert([.isAdminRecord, .mustNotFragment])
        #expect(flags.contains(.isAdminRecord))
        #expect(flags.contains(.mustNotFragment))
    }
    
    @Test func testCanonicalBlock() throws {
        let block = CanonicalBlock(
            blockType: 1,
            blockNumber: 1,
            controlFlags: [.mustBeReplicatedInEveryFragment],
            crc: CRC(type: .none),
            data: Data([1, 2, 3])
        )
        
        #expect(block.blockType == 1)
        #expect(block.blockNumber == 1)
        #expect(block.controlFlags.contains(.mustBeReplicatedInEveryFragment))
        #expect(block.crc.type == .none)
        #expect(block.data == Data([1, 2, 3]))
    }
}
