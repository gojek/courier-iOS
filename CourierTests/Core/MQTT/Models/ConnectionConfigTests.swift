import Foundation
import XCTest
@testable import CourierCore
@testable import CourierMQTT

class ConnectionConfigTests: XCTestCase {
    
    func testConnectionConfigWithInMemoryPersistence() {
        let config = ConnectionConfig(
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            eventHandler: MockCourierEventHandler(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isDatabasePersistent: false,
            inMemoryPersistent: true
        )
        
        XCTAssertEqual(config.isDatabasePersistent, false)
        XCTAssertEqual(config.inMemoryPersistent, true)
    }
    
    func testConnectionConfigWithDatabasePersistence() {
        let config = ConnectionConfig(
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            eventHandler: MockCourierEventHandler(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isDatabasePersistent: true,
            inMemoryPersistent: false
        )
        
        XCTAssertEqual(config.isDatabasePersistent, true)
        XCTAssertEqual(config.inMemoryPersistent, false)
    }
    
    func testConnectionConfigWithCoreDataInMemory() {
        let config = ConnectionConfig(
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            eventHandler: MockCourierEventHandler(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isDatabasePersistent: false,
            inMemoryPersistent: false
        )
        
        XCTAssertEqual(config.isDatabasePersistent, false)
        XCTAssertEqual(config.inMemoryPersistent, false)
    }
    
    func testConnectionConfigWithBothPersistenceFlags() {
        let config = ConnectionConfig(
            connectRetryTimePolicy: ConnectRetryTimePolicy(),
            eventHandler: MockCourierEventHandler(),
            authFailureHandler: MockAuthFailureHandler(),
            connectTimeoutPolicy: ConnectTimeoutPolicy(),
            idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(),
            isDatabasePersistent: true,
            inMemoryPersistent: true
        )
        
        XCTAssertEqual(config.isDatabasePersistent, true)
        XCTAssertEqual(config.inMemoryPersistent, true)
    }
}
