import CourierCore
import Foundation
import MQTTClientGJ

extension CocoaMQTTConnection {

    /// Posts a packet-level log to the MQTTChuck inspector, mirroring the v3
    /// framework's `logToMQTTChuck`. The v5 stack has no `sending:`/`received:`
    /// low-level hooks, so the connection emits these from the CocoaMQTT delegate
    /// callbacks instead. The `userInfo` shape matches what `MQTTChuckLogger`
    /// decodes, so the in-app inspector works identically across v3 and v5.
    func logToMQTTChuck(
        sending: Bool,
        type: MQTTCommandType,
        qos: QoS = .zero,
        mid: UInt16,
        data: Data? = nil
    ) {
        Task(priority: .background) {
            let isEnabled = await CourierMQTTChuck.shared.isEnabled()
            guard isEnabled else { return }
            self.postMQTTChuckNotification(sending: sending, type: type, qos: qos, mid: mid, data: data)
        }
    }

    private func postMQTTChuckNotification(
        sending: Bool,
        type: MQTTCommandType,
        qos: QoS,
        mid: UInt16,
        data: Data?
    ) {
        var userInfo: [String: Any] = [
            "type": type.rawValue,
            "qos": UInt8(qos.type),
            "retained": false,
            "duped": false,
            "mid": mid,
            "sending": sending,
            "received": !sending,
        ]

        if let data = data {
            userInfo["data"] = data
        }

        if let connectOptions = self.connectOptions {
            var connectOptionsInfo: [String: Any] = [
                "host": connectOptions.host,
                "port": Int(connectOptions.port),
                "keepAlive": Int(connectOptions.keepAlive),
                "clientId": connectOptions.clientId,
                "isCleanSession": connectOptions.isCleanSession,
            ]
            if let userProperties = connectOptions.userProperties {
                connectOptionsInfo["userProperties"] = userProperties
            }
            if let alpn = connectOptions.alpn {
                connectOptionsInfo["alpn"] = alpn
            }
            if let scheme = connectOptions.scheme {
                connectOptionsInfo["scheme"] = scheme
            }
            userInfo["connectOptions"] = connectOptionsInfo
        }

        NotificationCenter.default.post(name: mqttChuckNotification, object: nil, userInfo: userInfo)
    }
}
