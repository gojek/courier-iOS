import Foundation
import XCTest
import MQTTClientGJ
@testable import CourierCore
@testable import CourierMQTT

class MQTTPersistenceFactoryTests: XCTestCase {
    
    func testMakePersistenceWithInMemoryPersistent() {
        let factory = MQTTPersistenceFactory(isDatabasePersistent: false, inMemoryPersistent: true)
        let persistence = factory.makePersistence()
        
        XCTAssertTrue(persistence is MQTTInMemoryPersistence, "Should create MQTTInMemoryPersistence when inMemoryPersistent is true")
        XCTAssertEqual(persistence.maxWindowSize, 16)
        XCTAssertEqual(persistence.maxMessages, 5000)
    }
    
    func testMakePersistenceWithDatabasePersistent() {
        let factory = MQTTPersistenceFactory(isDatabasePersistent: true, inMemoryPersistent: false)
        let persistence = factory.makePersistence()
        
        XCTAssertTrue(persistence is MQTTCoreDataPersistence, "Should create MQTTCoreDataPersistence when isDatabasePersistent is true")
        XCTAssertEqual(persistence.persistent, true)
        XCTAssertEqual(persistence.maxWindowSize, 16)
        XCTAssertEqual(persistence.maxSize, 128 * 1024 * 1024)
        XCTAssertEqual(persistence.maxMessages, 5000)
    }
    
    func testMakePersistenceWithCoreDataInMemory() {
        let factory = MQTTPersistenceFactory(isDatabasePersistent: false, inMemoryPersistent: false)
        let persistence = factory.makePersistence()
        
        XCTAssertTrue(persistence is MQTTCoreDataPersistence, "Should create MQTTCoreDataPersistence when both flags are false")
        XCTAssertEqual(persistence.persistent, false, "Core Data should use in-memory store")
        XCTAssertEqual(persistence.maxWindowSize, 16)
        XCTAssertEqual(persistence.maxSize, 128 * 1024 * 1024)
        XCTAssertEqual(persistence.maxMessages, 5000)
    }
    
    func testMakePersistenceInMemoryTakesPrecedence() {
        let factory = MQTTPersistenceFactory(isDatabasePersistent: true, inMemoryPersistent: true)
        let persistence = factory.makePersistence()
        
        XCTAssertTrue(persistence is MQTTInMemoryPersistence, "inMemoryPersistent should take precedence over isDatabasePersistent")
        XCTAssertEqual(persistence.maxWindowSize, 16)
        XCTAssertEqual(persistence.maxMessages, 5000)
    }
    
    func testDefaultInitialization() {
        let factory = MQTTPersistenceFactory()
        let persistence = factory.makePersistence()
        
        XCTAssertTrue(persistence is MQTTCoreDataPersistence, "Default should create MQTTCoreDataPersistence")
        XCTAssertEqual(persistence.persistent, false, "Default Core Data should use in-memory store")
    }
}
