import Foundation
@testable import CourierCore
@testable import CourierMQTT
class MockMQTTConnectionFactory: IMQTTConnectionFactory {

    var invokedMakeConnection = false
    var invokedMakeConnectionCount = 0
    var invokedMakeConnectionParameters: (connectionConfig: ConnectionConfig, Void)?
    var invokedMakeConnectionParametersList = [(connectionConfig: ConnectionConfig, Void)]()
    var stubbedMakeConnectionResult: IMQTTConnection!

    func makeConnection(connectionConfig: ConnectionConfig) -> IMQTTConnection {
        invokedMakeConnection = true
        invokedMakeConnectionCount += 1
        invokedMakeConnectionParameters = (connectionConfig, ())
        invokedMakeConnectionParametersList.append((connectionConfig, ()))
        return stubbedMakeConnectionResult
    }
}
