import XCTest
@testable import CourierCore
@testable import CourierMQTT
class ConnectionStateTests: XCTestCase {

    var sut: ConnectionState!
    var mockClient: MockMQTTClient!

    override func setUp() {
        mockClient = MockMQTTClient()
    }

    func testConnecting() {
        mockClient.stubbedIsConnecting = true
        sut = ConnectionState(client: mockClient)
        XCTAssertEqual(sut, .connecting)
    }

    func testConnected() {
        mockClient.stubbedIsConnected = true
        sut = ConnectionState(client: mockClient)
        XCTAssertEqual(sut, .connected)
    }

    func testDisconnected() {
        mockClient.stubbedIsConnected = false
        mockClient.stubbedIsConnecting = false
        sut = ConnectionState(client: mockClient)
        XCTAssertEqual(sut, .disconnected)
    }
}
