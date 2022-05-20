import CourierCore
import UIKit

final class HiveMQAuthService: IConnectionServiceProvider {

  var extraIdProvider: (() -> String?)?

  var clientId: String {
      let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
      return "\(deviceId)|\(username)"
  }

  private let username = "123456"

  func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {
      let connectOptions = ConnectOptions(
          host: "broker.mqttdashboard.com",
          port: 1883,
          keepAlive: 60,
          clientId: clientId,
          username: username,
          password: "",
          isCleanSession: false,
          userProperties: ["service": "hivemq", "type": "public"]
      )

      completion(.success(connectOptions))
  }
}
