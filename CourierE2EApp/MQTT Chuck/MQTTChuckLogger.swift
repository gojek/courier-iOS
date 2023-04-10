//
//  MQTTChuckLogger.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 10/04/23.
//

import Foundation
import CourierCore
import CourierMQTT
import MQTTClientGJ

struct MQTTChuckLog: Identifiable {
    let id = UUID()
    
    let commandType: String
    let qos: String
    let messageId: Int
    let sending: Bool
    let received: Bool
    
    let dup: Bool
    let retained: Bool
    let dataLength: Int?
    let dataString: String?
    
    let timestamp = Date()
}

protocol MQTTChuckLoggerDelegate {
    
    func mqttChuckLoggerDidUpdateLogs(_ logs: [MQTTChuckLog])
}

class MQTTChuckLogger {
    
    static let shared = MQTTChuckLogger()
    private(set) var logs = [MQTTChuckLog]()
    var logsMaxSize = 200
    var delegate: MQTTChuckLoggerDelegate?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMQTTChuckNotification), name: mqttChuckNotification, object: nil)
    }
    
    func setLogsMaxSize(_ size: Int) {
        self.logsMaxSize = size
    }
        
    @objc func didReceiveMQTTChuckNotification(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let rawType = userInfo["type"] as? UInt8,
              let type = MQTTCommandType(rawValue: rawType),
              let rawQoS = userInfo["qos"] as? UInt8,
              let qos = QoS(rawValue: Int(rawQoS)),
              let dup = userInfo["duped"] as? Bool,
              let retained = userInfo["retained"] as? Bool,
              let mid = userInfo["mid"] as? UInt16,
              let sending = userInfo["sending"] as? Bool,
              let received = userInfo["received"] as? Bool
        else {
            return
        }
        
        let data = userInfo["data"] as? Data        
        let log = MQTTChuckLog(
            commandType: type.debugDescription,
            qos: "\(qos)",
            messageId: Int(mid),
            sending: sending, received: received,
            dup: dup, retained: retained,
            dataLength: data?.count,
            dataString: (data != nil) ? String(data: data!, encoding: .utf8) : nil)
        print("MQTT Chuck Logger: \(log)")
        
        logs.append(log)
        if logs.count >= logsMaxSize {
            logs.removeFirst(10)
        }
        delegate?.mqttChuckLoggerDidUpdateLogs(logs)
    }
    
}
