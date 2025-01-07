import XCTest
@testable import BundleProtocolv7

final class ErrorTests: XCTestCase {
    func testCanonicalBlockError() {
        let error = BPv7Error.canonicalBlockError("Invalid block type")
        XCTAssertEqual(error.errorDescription, "Canonical Block Error: Invalid block type")
    }
    
    func testPrimaryBlockError() {
        let error = BPv7Error.primaryBlockError("Missing destination")
        XCTAssertEqual(error.errorDescription, "Primary Block Error: Missing destination")
    }
    
    func testEndpointIdError() {
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid EID format"])
        let error = BPv7Error.endpointIdError(underlyingError)
        XCTAssertEqual(error.errorDescription, "Endpoint ID Error: Invalid EID format")
    }
    
    func testDtnTimeError() {
        let error = BPv7Error.dtnTimeError("Invalid timestamp")
        XCTAssertEqual(error.errorDescription, "DTN Time Error: Invalid timestamp")
    }
    
    func testCrcError() {
        let error = BPv7Error.crcError("Checksum mismatch")
        XCTAssertEqual(error.errorDescription, "CRC Error: Checksum mismatch")
    }
    
    func testBundleError() {
        let error = BPv7Error.bundleError("Invalid bundle structure")
        XCTAssertEqual(error.errorDescription, "Bundle Error: Invalid bundle structure")
    }
    
    func testBundleControlFlagsError() {
        let error = BPv7Error.bundleControlFlagsError("Invalid flag combination")
        XCTAssertEqual(error.errorDescription, "Bundle Control Flags Error: Invalid flag combination")
    }
    
    func testBlockControlFlagsError() {
        let error = BPv7Error.blockControlFlagsError("Unsupported flag")
        XCTAssertEqual(error.errorDescription, "Block Control Flags Error: Unsupported flag")
    }
    
    func testJsonDecodeError() {
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])
        let error = BPv7Error.jsonDecodeError(underlyingError)
        XCTAssertEqual(error.errorDescription, "JSON Decode Error: Invalid JSON")
    }
    
    func testCborDecodeError() {
        let underlyingError = NSError(domain: "test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid CBOR"])
        let error = BPv7Error.cborDecodeError(underlyingError)
        XCTAssertEqual(error.errorDescription, "CBOR Decode Error: Invalid CBOR")
    }
    
    func testErrorList() {
        let errorList: ErrorList = [
            .bundleError("First error"),
            .crcError("Second error")
        ]
        XCTAssertEqual(errorList.count, 2)
        XCTAssertEqual(errorList[0].errorDescription, "Bundle Error: First error")
        XCTAssertEqual(errorList[1].errorDescription, "CRC Error: Second error")
    }
} 