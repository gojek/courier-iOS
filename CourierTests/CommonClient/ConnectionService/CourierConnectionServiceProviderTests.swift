






@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

import XCTest

class CourierConnectionServiceProviderTests: XCTestCase {

    var sut: CourierConnectionServiceProvider!
    var mockCourierConfig: MockCourierConfig!
    private let userDefaultsKey = "Courier.AuthResponseCache"
    private let userDefaults = UserDefaults.standard

    override func setUp() {
        mockCourierConfig = MockCourierConfig()
    }

    func testGetClientIdWithoutExtraIdProvider() {
        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { url, sucess, failure in },
            courierConfig: mockCourierConfig, extraIdProvider: nil
        )
        XCTAssertEqual(sut.clientId, "device_id:jane")
    }

    func testGetClientIdWithExtraIDProvider() {
        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { url, sucess, failure in },
            courierConfig: mockCourierConfig,
            extraIdProvider: { "HAL-3000"}
        )

        XCTAssertEqual(sut.clientId, "device_id:jane:HAL-3000")
    }

    func testGetClientIdWithBlankExtraIDProviderString() {
        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { url, sucess, failure in },
            courierConfig: mockCourierConfig,
            extraIdProvider: { ""}
        )

        XCTAssertEqual(sut.clientId, "device_id:jane")
    }


    func testGetConnectOptionsSuccess() {
        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { _, success, _ in
                let req = URLRequest(url: URL(string: "https:
                let response = HTTPURLResponse(url: req.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                success(req, response, Self.stubAuthResponseData)
            },
            courierConfig: mockCourierConfig,
            extraIdProvider: { ""}
        )

        mockCourierConfig.stubbedPingInterval = 20
        mockCourierConfig.stubbedIsCleanSessionEnabled = true

        sut.getConnectOptions { result in
            if case .success(let response) = result {
                let stubResponse = Self.stubAuthResponse
                XCTAssertEqual(response.host, stubResponse.broker.host)
                XCTAssertEqual(Int(response.port), stubResponse.broker.port)
                XCTAssertEqual(response.password, stubResponse.token)
                XCTAssertEqual(response.keepAlive, 20)
                XCTAssertEqual(response.isCleanSession, true)
                XCTAssertEqual(response.username, "jane")
                XCTAssertEqual(response.clientId, self.sut.clientId)
            } else {
                XCTAssertTrue(false)
            }
        }
    }

    func testGetConnectOptionsAuthFailure() {
        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { _, _, failure in
                let req = URLRequest(url: URL(string: "https:
                let response = HTTPURLResponse(url: req.url!, statusCode: 400, httpVersion: nil, headerFields: nil)

                failure(response, Self.stubAuthResponseData, CourierError.httpError.asNSError)
            },
            courierConfig: mockCourierConfig,
            extraIdProvider: { ""}
        )

        sut.getConnectOptions { result in
            if case .failure(let error) = result {
                if case .httpError(let statusCode) = error {
                    XCTAssertEqual(statusCode, 400)
                } else {
                    XCTAssertTrue(false)
                }
            } else {
                XCTAssertTrue(false)
            }
        }
    }

    func testAuthResponseNoOp() {
        var providerInvokedCount = 0

        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { _, success, _ in
                let req = URLRequest(url: URL(string: "https:
                let response = HTTPURLResponse(url: req.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                providerInvokedCount += 1
                success(req, response, Self.stubAuthResponseData)
            },
            courierConfig: mockCourierConfig,
            tokenCachingMechanismRawValue: 0,
            extraIdProvider: { "" }
        )

        XCTAssertNil(sut.cachedAuthResponse)
        sut.getConnectOptions { _ in }
        XCTAssertEqual(providerInvokedCount, 1)
        XCTAssertNil(sut.cachedAuthResponse)
        sut.getConnectOptions { _ in }
        XCTAssertEqual(providerInvokedCount, 2)
    }

    func testAuthResponseInMemoryCaching() {
        var providerInvokedCount = 0

        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { _, success, _ in
                let req = URLRequest(url: URL(string: "https:
                let response = HTTPURLResponse(url: req.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                providerInvokedCount += 1
                success(req, response, Self.stubAuthResponseData)
            },
            courierConfig: mockCourierConfig,
            tokenCachingMechanismRawValue: 1,
            extraIdProvider: { "" }
        )

        XCTAssertNil(sut.cachedAuthResponse)
        sut.getConnectOptions { _ in }
        XCTAssertEqual(providerInvokedCount, 1)
        XCTAssertNotNil(sut.cachedAuthResponse)
        sut.getConnectOptions { _ in }
        XCTAssertEqual(providerInvokedCount, 1)
    }

    func testAuthResponseDiskBasedCachingEnabled() {
        var providerInvokedCount = 0

        userDefaults.set(try! JSONEncoder().encode(Self.stubAuthResponse), forKey: userDefaultsKey)

        sut = .init(
            deviceIdProvider: { "device_id" },
            userIdProvider: { "jane" },
            connectionServiceURLProvider: { _, success, _ in
                let req = URLRequest(url: URL(string: "https:
                let response = HTTPURLResponse(url: req.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                providerInvokedCount += 1
                success(req, response, Self.stubAuthResponseData)
            },
            courierConfig: mockCourierConfig,
            tokenCachingMechanismRawValue: 2,
            userDefaults: userDefaults,
            userDefaultsKey: userDefaultsKey,
            extraIdProvider: { "" }
        )

        XCTAssertNotNil(sut.cachedAuthResponse)
        sut.getConnectOptions { _ in }
        XCTAssertEqual(providerInvokedCount, 0)
    }

    override func tearDown() {
        userDefaults.removeObject(forKey: userDefaultsKey)
    }
}


extension CourierConnectionServiceProviderTests {

    static var stubAuthResponseData: Data {
        let dict: [String: Any] = [
            "broker": [
                "host": "xx.yy.zz",
                "port": 443,
            ],
            "expiry_in_sec": 3600,
            "token": "secret"
        ]

        return try! JSONSerialization.data(withJSONObject: dict, options: [])
    }

    static var stubAuthResponse: AuthResponse {
        let data = stubAuthResponseData
        return try! JSONDecoder().decode(AuthResponse.self, from: data)
    }
}

