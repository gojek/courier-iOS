import Foundation

struct CocoaMQTTConnectionFactory: IMQTTConnectionFactory {

    let clientFactory: ICocoaMQTTClientFactory

    init(clientFactory: ICocoaMQTTClientFactory = CocoaMQTTClientFactory()) {
        self.clientFactory = clientFactory
    }

    func makeConnection(connectionConfig: ConnectionConfig) -> IMQTTConnection {
        CocoaMQTTConnection(connectionConfig: connectionConfig, clientFactory: clientFactory)
    }
}
