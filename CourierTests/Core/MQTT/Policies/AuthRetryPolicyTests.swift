import XCTest
@testable import CourierCore
@testable import CourierMQTT
class AuthRetryPolicyTests: XCTestCase {

    var sut: AuthRetryPolicy!

    override func setUp() {
        sut = AuthRetryPolicy()
    }

    func testShouldRetryWithHTTPErrorNot400To499() {
        let error = AuthError.httpError(statusCode: 500)
        XCTAssertTrue(sut.shouldRetry(error: error))
    }

    func testShouldNotRetryWithHTTPErrorNot400To499After3TimesRetry() {
        let error = AuthError.httpError(statusCode: 500)
        XCTAssertTrue(sut.shouldRetry(error: error))
        XCTAssertEqual(Double(1) * pow(2, Double(1 - 1)), sut.getRetryTime())
        XCTAssertTrue(sut.shouldRetry(error: error))
        XCTAssertEqual(Double(1) * pow(2, Double(2 - 1)), sut.getRetryTime())
        XCTAssertTrue(sut.shouldRetry(error: error))
        XCTAssertEqual(Double(1) * pow(2, Double(3 - 1)), sut.getRetryTime())
        XCTAssertFalse(sut.shouldRetry(error: error))
        sut.resetParams()
    }

    func testShouldNotRetryWithHTTPErrorBetween400To499() {
        let error = AuthError.httpError(statusCode: 499)
        XCTAssertFalse(sut.shouldRetry(error: error))
    }

    func testShouldNotRetryWithoutAuthError() {
        XCTAssertFalse(sut.shouldRetry(error: NSError(domain: "x", code: -1, userInfo: [:])))
    }

    func testResetParams() {
        let error = AuthError.httpError(statusCode: 500)
        XCTAssertTrue(sut.shouldRetry(error: error))
        XCTAssertEqual(Double(1) * pow(2, Double(1 - 1)), sut.getRetryTime())
        sut.resetParams()
        XCTAssertTrue(sut.shouldRetry(error: error))
        XCTAssertEqual(Double(1) * pow(2, Double(1 - 1)), sut.getRetryTime())
    }

}
