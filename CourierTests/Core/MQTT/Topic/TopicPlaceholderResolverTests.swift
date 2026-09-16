import Foundation
import XCTest
@testable import CourierCore
@testable import CourierMQTT

class TopicPlaceholderResolverTests: XCTestCase {

    private let resolver = TopicPlaceholderResolver()

    private func connectOptions(username: String = "john", clientId: String = "region:john:device") -> ConnectOptions {
        ConnectOptions(
            host: "localhost",
            port: 1883,
            clientId: clientId,
            username: username,
            password: ""
        )
    }

    func testReturnsTopicUnchangedWhenItHasNoPlaceholder() throws {
        let resolved = try resolver.resolve(
            topic: "chat/room/inbox",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "chat/room/inbox")
    }

    func testResolvesUsernamePlaceholder() throws {
        let resolved = try resolver.resolve(
            topic: "chat/%u/inbox",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "chat/john/inbox")
    }

    func testResolvesClientIdPlaceholder() throws {
        let resolved = try resolver.resolve(
            topic: "chat/%c/inbox",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "chat/region:john:device/inbox")
    }

    func testResolvesSplitClientIdPlaceholderUsingZeroBasedPartIndex() throws {
        let resolved = try resolver.resolve(
            topic: "chat/(%c,:,1)/inbox",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "chat/john/inbox")
    }

    func testResolvesSplitPlaceholderForFirstPart() throws {
        let resolved = try resolver.resolve(
            topic: "(%c,:,0)/inbox",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "region/inbox")
    }

    func testResolvesSplitUsernamePlaceholder() throws {
        let resolved = try resolver.resolve(
            topic: "chat/(%u,@,0)/inbox",
            connectOptions: connectOptions(username: "john@gojek.com")
        )

        XCTAssertEqual(resolved, "chat/john/inbox")
    }

    func testDoesNotCorruptSplitPlaceholderWhenPlainPlaceholderAlsoPresent() throws {
        let resolved = try resolver.resolve(
            topic: "(%c,:,1)/%c",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "john/region:john:device")
    }

    func testResolvesMultipleSplitPlaceholdersInSingleTopic() throws {
        let resolved = try resolver.resolve(
            topic: "(%c,:,0)/(%c,:,2)",
            connectOptions: connectOptions()
        )

        XCTAssertEqual(resolved, "region/device")
    }

    func testThrowsWhenSplitPartIndexIsOutOfBounds() {
        XCTAssertThrowsError(
            try resolver.resolve(
                topic: "chat/(%c,:,3)/inbox",
                connectOptions: connectOptions()
            )
        ) { error in
            XCTAssertEqual(
                error as? TopicPlaceholderError,
                .invalidPartIndex(placeholder: "%c", delimiter: ":", partIndex: 3, partsCount: 3)
            )
        }
    }

    func testThrowsWhenPlaceholderIsUnsupported() {
        XCTAssertThrowsError(
            try resolver.resolve(
                topic: "chat/(%x,:,0)/inbox",
                connectOptions: connectOptions()
            )
        ) { error in
            XCTAssertEqual(error as? TopicPlaceholderError, .unsupportedPlaceholder("%x"))
        }
    }
}
