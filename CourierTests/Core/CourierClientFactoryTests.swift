@testable import CourierCore
@testable import CourierMQTT
import XCTest

class CourierClientFactoryTests: XCTestCase {
    let sut = CourierClientFactory()

    func testMakeMQTTClient() {
        let config = MQTTClientConfig(
            authService: MockConnectionServiceProvider()
        )

        let client = sut.makeMQTTClient(config: config) as! MQTTCourierClient
        XCTAssertTrue(client.messageAdaptersCoordinator.messageAdapters[0] is JSONMessageAdapter)
        XCTAssertTrue(client.subscriptionStore is DiskSubscriptionStore)
        XCTAssertTrue(client.connectionServiceProvider is MockConnectionServiceProvider)
    }
    
    func testMakeMQTTClientWithInMemoryPersistence() {
        let config = MQTTClientConfig(
            authService: MockConnectionServiceProvider(),
            isMessageInMemoryPersistenceEnabled: true
        )

        let client = sut.makeMQTTClient(config: config) as! MQTTCourierClient
        XCTAssertTrue(client.messageAdaptersCoordinator.messageAdapters[0] is JSONMessageAdapter)
        XCTAssertTrue(client.subscriptionStore is DiskSubscriptionStore)
        XCTAssertTrue(client.connectionServiceProvider is MockConnectionServiceProvider)
    }
    
    func testMakeMQTTClientWithDatabasePersistence() {
        let config = MQTTClientConfig(
            authService: MockConnectionServiceProvider(),
            isMessagePersistenceEnabled: true
        )

        let client = sut.makeMQTTClient(config: config) as! MQTTCourierClient
        XCTAssertTrue(client.messageAdaptersCoordinator.messageAdapters[0] is JSONMessageAdapter)
        XCTAssertTrue(client.subscriptionStore is DiskSubscriptionStore)
        XCTAssertTrue(client.connectionServiceProvider is MockConnectionServiceProvider)
    }
}
