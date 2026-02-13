import Foundation
import XCTest
@testable import CourierCore
@testable import CourierMQTT

class MQTTConfigurationTests: XCTestCase {
    
    func testDefaultConfiguration() {
        let config = MQTTConfiguration(
            eventHandler: MockCourierEventHandler(),
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isMQTTPersistentEnabled: false,
            isMQTTMemoryPersistentEnabled: false,
            messagePersistenceTTLSeconds: 0,
            messageCleanupInterval: 0
        )
        
        XCTAssertEqual(config.isMQTTPersistentEnabled, false)
        XCTAssertEqual(config.isMQTTMemoryPersistentEnabled, false)
    }
    
    func testConfigurationWithInMemoryPersistence() {
        let config = MQTTConfiguration(
            eventHandler: MockCourierEventHandler(),
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isMQTTPersistentEnabled: false,
            isMQTTMemoryPersistentEnabled: true,
            messagePersistenceTTLSeconds: 0,
            messageCleanupInterval: 0
        )
        
        XCTAssertEqual(config.isMQTTPersistentEnabled, false)
        XCTAssertEqual(config.isMQTTMemoryPersistentEnabled, true)
    }
    
    func testConfigurationWithDatabasePersistence() {
        let config = MQTTConfiguration(
            eventHandler: MockCourierEventHandler(),
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isMQTTPersistentEnabled: true,
            isMQTTMemoryPersistentEnabled: false,
            messagePersistenceTTLSeconds: 0,
            messageCleanupInterval: 0
        )
        
        XCTAssertEqual(config.isMQTTPersistentEnabled, true)
        XCTAssertEqual(config.isMQTTMemoryPersistentEnabled, false)
    }
    
    func testConfigurationWithBothPersistenceFlags() {
        let config = MQTTConfiguration(
            eventHandler: MockCourierEventHandler(),
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isMQTTPersistentEnabled: true,
            isMQTTMemoryPersistentEnabled: true,
            messagePersistenceTTLSeconds: 0,
            messageCleanupInterval: 0
        )
        
        XCTAssertEqual(config.isMQTTPersistentEnabled, true)
        XCTAssertEqual(config.isMQTTMemoryPersistentEnabled, true)
    }
}
