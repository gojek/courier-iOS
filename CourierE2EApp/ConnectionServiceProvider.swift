//
//  ConnectionServiceProvider.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 13/06/22.
//

import Foundation
import CourierCore

class ConnectionServiceProvider: IConnectionServiceProvider {
    
    let ipAddress: String
    let port: Int
    
    let clientId: String
    let username: String?
    let password: String?
    
    let isCleanSession: Bool
    let pingInterval: Int
    
    var extraIdProvider: (() -> String?)? = nil
    
    init(ipAddress: String,
        port: Int,
        clientId: String,
        username: String? = nil,
        password: String? = nil,
        isCleanSession: Bool,
        pingInterval: Int) {
        self.ipAddress = ipAddress
        self.port = port
        self.clientId = clientId
        self.username = username
        self.password = password
        self.isCleanSession = isCleanSession
        self.pingInterval = pingInterval
    }
    
    func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {
        completion(.success(.init(
            host: ipAddress,
            port: UInt16(port),
            keepAlive: UInt16(pingInterval),
            clientId: clientId,
            username: username ?? "",
            password: password ?? "",
            isCleanSession: isCleanSession
        )))
    }
}
