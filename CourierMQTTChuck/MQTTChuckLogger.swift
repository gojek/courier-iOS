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

public protocol MQTTChuckLoggerDelegate {
    func mqttChuckLoggerDidUpdateLogs(_ logs: [MQTTChuckLog])
}

public class MQTTChuckLogger {
    
    private var _logs = [MQTTChuckLog]()
    private let logsQueue = DispatchQueue(label: "com.courier.mqtt.chuck.logs", attributes: .concurrent)
    
    public var logs: [MQTTChuckLog] {
        return logsQueue.sync {
            return _logs
        }
    }
    
    public var delegate: MQTTChuckLoggerDelegate?
    public var dataStringParser: ((Data) -> String?)?
    public var logsMaxSize = 250
    
    public init() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMQTTChuckNotification), name: mqttChuckNotification, object: nil)
        CourierMQTTChuck.isEnabled = true
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
        var dataString: String?
        
        if let data = data {
            if let dataStringParser = dataStringParser,
               let string = dataStringParser(data) {
                dataString = string
            } else if let string = String(data: data, encoding: .utf8) {
                dataString = string
            } else {
                dataString = (data as NSData).description
            }
        }
        
        var log = MQTTChuckLog(
            commandType: type.debugDescription,
            qos: "\(qos)",
            messageId: Int(mid),
            sending: sending, received: received,
            dup: dup, retained: retained,
            dataLength: data?.count,
            dataString: dataString)
        
        if let connectOptions = userInfo["connectOptions"] as? [String: Any] {
            log.host = connectOptions["host"] as? String
            log.port = connectOptions["port"] as? Int
            log.keepAlive = connectOptions["keepAlive"] as? Int
            log.clientId = connectOptions["clientId"] as? String
            log.isCleanSession = connectOptions["isCleanSession"] as? Bool
            log.userProperties = connectOptions["userProperties"] as? [String: String]
            log.alpn = connectOptions["alpn"] as? [String]
            log.scheme = connectOptions["scheme"] as? String
        }
        
        logsQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            
            self._logs.append(log)
            if self._logs.count >= self.logsMaxSize {
                self._logs.removeFirst(10)
            }
            
            let currentLogs = self._logs
            DispatchQueue.main.async {
                self.delegate?.mqttChuckLoggerDidUpdateLogs(currentLogs)
            }
        }
    }
    
    public func clearLogs() {
        logsQueue.async(flags: .barrier) { [weak self] in
            guard let self else { return }
            self._logs = []
            let currentLogs = self._logs
            DispatchQueue.main.async {
                self.delegate?.mqttChuckLoggerDidUpdateLogs(currentLogs)
            }
        }
    }
    
    deinit {
        CourierMQTTChuck.isEnabled = false
    }
    
}
