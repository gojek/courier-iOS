import Foundation
@testable import CourierCore
@testable import CourierMQTT
@testable import CourierCommonClient

class MockCourierAnalyticsManager: ICourierAnalyticsManager {

    var invokedSend = false
    var invokedSendCount = 0
    var invokedSendParameters: (name: String, properties: [String: Any]?, source: CourierAnalyticsService.Source)?
    var invokedSendParametersList = [(name: String, properties: [String: Any]?, source: CourierAnalyticsService.Source)]()

    func send(_ name: String, properties: [String: Any]?, source: CourierAnalyticsService.Source) {
        invokedSend = true
        invokedSendCount += 1
        invokedSendParameters = (name, properties, source)
        invokedSendParametersList.append((name, properties, source))
    }
}
