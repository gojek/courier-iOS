//
//  ConnectionE2EObservableObject.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 16/06/22.
//

import SwiftUI
import CourierCore
import CourierMQTT
import CourierProtobuf

struct MessagePayload: Codable {
    let from: String
    let message: String
    let to: String
}

final class ConnectionE2EObservableObject: ObservableObject {
    
    private let courierClient: CourierClient
    let connectionServiceProvider: ConnectionServiceProvider
    let username: String
    let roomCode: String
    
    @Published var connectionColor = Color.red
    
    @Published var isConnected = false
    @Published var publishMessage = ""
    
    @Published var messageList: [MessageData] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(connectionserviceProvider: ConnectionServiceProvider, username: String, roomCode: String) {
        self.connectionServiceProvider = connectionserviceProvider
        self.username = username
        self.roomCode = roomCode
        
        // Configure & Initialize Courier
        let clientFactory = CourierClientFactory()
        self.courierClient = clientFactory.makeMQTTClient(
            config: MQTTClientConfig(
                authService: connectionserviceProvider,
                messageAdapters: [
                    DataMessageAdapter(),
                    JSONMessageAdapter(),
                    TextMessageAdapter()
                    
                ],
                autoReconnectInterval: 1,
                maxAutoReconnectInterval: 30,
                connectTimeoutPolicy: ConnectTimeoutPolicy(isEnabled: true),
                idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(isEnabled: true),
                messagePersistenceTTLSeconds: 86400,
                messageCleanupInterval: 10
            )
        )
        courierClient.addEventHandler(self)
    }
    
    func connect() {
        courierClient.connect()
        courierClient.connectionStatePublisher
            .sink { [weak self] in
                self?.handleConnectionStateEvent($0)
            }.store(in: &cancellables)
    }

    func disconnect() {
        // You can also call destroy() to clear all the persisted message
        courierClient.disconnect()
    }
    
    private func handleConnectionStateEvent(_ connectionState: ConnectionState) {
        switch connectionState {
        case .connected:
            self.connectionColor = .green
        case .connecting:
            self.connectionColor = .orange
        case .disconnected:
            self.connectionColor = .red
        }
    }
    
    // TODO: Add Validation Handling
    func publish() throws {
        if publishMessage.isEmpty {
            return
        }
        
        do {
            try courierClient.publishMessage(MessagePayload(
                from: username,
                message: publishMessage,
                to: roomCode), topic: "chat/\(username)/send", qos: QoS.zero)
            publishMessage = ""
        } catch {
            throw error
        }
    }
    
    func removeMessage(indexSet: IndexSet) {
        messageList.remove(atOffsets: indexSet)
    }
    
    func removellMessages() {
        messageList.removeAll()
    }
    
    private func handleMessageReceiveEvent(_ message: Result<Data, NSError>, topic: String, qos: Int) {
        switch message {
        case let .success(message):
            messageList.insert(MessageData(
                topic: topic,
                qos: qos,
                message: String(data: message, encoding: .utf8) ?? "Failed to decode message to string",
                timestamp: Date()
            ), at: 0)
            
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}

extension ConnectionE2EObservableObject: ICourierEventHandler {
    
    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionSuccess:
            courierClient.subscribe(("chat/\(roomCode)/receive", .zero))
        default: break
        }
    }
}
