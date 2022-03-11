@testable import CourierCore
@testable import CourierMQTT
import Foundation

class MockAppVersionProvider: IAppVersionProvider {

    var invokedAppVersionGetter = false
    var invokedAppVersionGetterCount = 0
    var stubbedAppVersion: String! = ""

    var appVersion: String {
        invokedAppVersionGetter = true
        invokedAppVersionGetterCount += 1
        return stubbedAppVersion
    }
}
