@testable import CourierMQTT

import Foundation
import UIKit

class MockAppStateObserver: IAppStateObserver {

    var invokedStateGetter = false
    var invokedStateGetterCount = 0
    var stubbedState: UIApplication.State!

    var state: UIApplication.State {
        invokedStateGetter = true
        invokedStateGetterCount += 1
        return stubbedState
    }
}
