@testable import CourierCore
@testable import CourierMQTT
import Foundation

class MockNetworkTypeProvider: INetworkTypeProvider {

    var invokedNetworkTypeGetter = false
    var invokedNetworkTypeGetterCount = 0
    var stubbedNetworkType: NetworkType!

    var networkType: NetworkType {
        invokedNetworkTypeGetter = true
        invokedNetworkTypeGetterCount += 1
        return stubbedNetworkType
    }

    var invokedNetworkWWANTypeGetter = false
    var invokedNetworkWWANTypeGetterCount = 0
    var stubbedNetworkWWANType: NetworkType!

    var networkWWANType: NetworkType {
        invokedNetworkWWANTypeGetter = true
        invokedNetworkWWANTypeGetterCount += 1
        return stubbedNetworkWWANType
    }
}
