//
//  ConnectionObservableObject.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 13/06/22.
//

import SwiftUI
import CourierCore
import CourierMQTT
import CourierProtobuf

final class ConnectionObservableObject: ObservableObject {
    
    private let courierClient: CourierClient
    let connectionServiceProvider: ConnectionServiceProvider
    @Published var connectionColor = Color.red
    
    @Published var isConnected = false
    @Published var publishTopic = ""
    @Published var publishQoS = 0
    @Published var publishMessage = ""
    
    @Published var subscribeTopic = ""
    @Published var subscribeQoS = 0
    
    @Published var subscriptionList: [SubscribeData] = []
    @Published var messageList: [MessageData] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(connectionserviceProvider: ConnectionServiceProvider) {
        self.connectionServiceProvider = connectionserviceProvider
        
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
        self.courierClient.addEventHandler(self)
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
        if publishTopic.isEmpty {
            return
        }
        
        if publishMessage.isEmpty {
            return
        }
        
        if QoS(rawValue: publishQoS) == nil {
            return
        }
        
        guard let data = publishMessage.data(using: .utf8) else {
            return
        }
        
        do {
            try courierClient.publishMessage(data, topic: publishTopic, qos: QoS(rawValue: publishQoS)!)
            publishMessage = ""
        } catch {
            throw error
        }
    }
    
    func subscribe() throws {
        if subscribeTopic.isEmpty {
            return
        }
        
        if QoS(rawValue: subscribeQoS) == nil {
            return
        }

        courierClient.subscribe((subscribeTopic, QoS(rawValue: subscribeQoS)!))
        
        let topic = subscribeTopic
        let qos = subscribeQoS
        courierClient.messagePublisher(topic: subscribeTopic)
            .sink { [weak self] in
                self?.handleMessageReceiveEvent(.success($0), topic: topic, qos: qos)
            }.store(in: &cancellables)
        
        subscriptionList.insert(SubscribeData(topic: subscribeTopic, qos: subscribeQoS), at: 0)
        subscribeTopic = ""
    }
    
    func unsubscribe(indexSet: IndexSet) {
        indexSet.forEach {
            courierClient.unsubscribe(subscriptionList[$0].topic)
        }
        subscriptionList.remove(atOffsets: indexSet)
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

extension ConnectionObservableObject: ICourierEventHandler {
    
    func onEvent(_ event: CourierEvent) {
        switch event {
        case .connectionSuccess:
            if connectionServiceProvider.isCleanSession {
                subscriptionList.forEach {
                    courierClient.subscribe(($0.topic, QoS(rawValue: $0.qos) ?? .zero))
                }
            }
        default: break
        }
    }
    
}
