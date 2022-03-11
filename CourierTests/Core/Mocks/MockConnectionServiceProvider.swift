import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockConnectionServiceProvider: IConnectionServiceProvider {

    var invokedClientIdGetter = false
    var invokedClientIdGetterCount = 0
    var stubbedClientId: String! = ""

    var clientId: String {
        invokedClientIdGetter = true
        invokedClientIdGetterCount += 1
        return stubbedClientId
    }

    var invokedExtraIdProviderSetter = false
    var invokedExtraIdProviderSetterCount = 0
    var invokedExtraIdProvider: (() -> String?)?
    var invokedExtraIdProviderList = [(() -> String?)?]()
    var invokedExtraIdProviderGetter = false
    var invokedExtraIdProviderGetterCount = 0
    var stubbedExtraIdProvider: (() -> String?)!

    var extraIdProvider: (() -> String?)? {
        set {
            invokedExtraIdProviderSetter = true
            invokedExtraIdProviderSetterCount += 1
            invokedExtraIdProvider = newValue
            invokedExtraIdProviderList.append(newValue)
        }
        get {
            invokedExtraIdProviderGetter = true
            invokedExtraIdProviderGetterCount += 1
            return stubbedExtraIdProvider
        }
    }

    var invokedGetConnectOptions = false
    var invokedGetConnectOptionsCount = 0
    var stubbedGetConnectOptionsCompletionResult: (Result<ConnectOptions, AuthError>, Void)?

    func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {
        invokedGetConnectOptions = true
        invokedGetConnectOptionsCount += 1
        if let result = stubbedGetConnectOptionsCompletionResult {
            completion(result.0)
        }
    }
}
