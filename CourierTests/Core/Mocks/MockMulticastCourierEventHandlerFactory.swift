import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockMulticastCourierEventHandlerFactory: IMulticastCourierEventHandlerFactory {

    var invokedMakeHandler = false
    var invokedMakeHandlerCount = 0
    var stubbedMakeHandlerResult: IMulticastCourierEventHandler!

    func makeHandler() -> IMulticastCourierEventHandler {
        invokedMakeHandler = true
        invokedMakeHandlerCount += 1
        return stubbedMakeHandlerResult
    }
}
