import SwiftUI
  import CourierCore
  import CourierCommonClient
  import CourierMQTT
  import CourierProtobuf

  class CourierObservableObject: ObservableObject {

    @Published var messages: [Message] = []
    @Published var connectedState = "Not Connected"
    @Published var availabilityState = "Initial"
    @Published var qos = QoS.two

    let topic = "chat/room/public/test"

    private var courierService: CourierClient!
    private var cancellables = Set<AnyCancellable>()
    private var courierAvailability: CourierAvailability!
    private var analytics: CourierAnalyticsService!

    func connect() {
        let clientFactory = CourierClientFactory()
        let courierClient = clientFactory.makeMQTTClient(
            config: MQTTClientConfig(
                authService: HiveMQAuthService(),
                messageAdapters: [
                    JSONMessageAdapter()

                ],
                isUsernameModificationEnabled: true,
                autoReconnectInterval: 1,
                maxAutoReconnectInterval: 30,
                disableMQTTReconnectOnAuthFailure: true,
                connectTimeoutPolicy: ConnectTimeoutPolicy(isEnabled: true),
                idleActivityTimeoutPolicy: IdleActivityTimeoutPolicy(isEnabled: true),
                countryCodeProvider: { "ID" }
            )
        )

        analytics = CourierAnalyticsService { name, properties in
            print("Send: \(name) with properties: \(String(describing: properties))")
        } clickstreamAnalyticsManagerProvider: { _, _ in

        }

        courierClient.addEventHandler(analytics!)
        courierClient.connect()
        courierClient.subscribe((topic, qos))
        courierClient.messagePublisher(topic: topic)
            .sink { [weak self] (message: String) in
                guard let self = self else { return }
                self.messages.insert(Message(id: UUID().uuidString, name: "Text Adapter: \(message)", timestamp: Date()), at: 0)
            }.store(in: &cancellables)

        courierClient.messagePublisher(topic: topic)
            .sink { [weak self] (message: Message) in
                guard let self = self else { return }
                self.handleMessageReceiveEvent(.success(message))
            }.store(in: &cancellables)

        courierClient.messagePublisher(topic: topic)
            .sink { [weak self] (note: Note) in
                guard let self = self else { return }
                self.messages.insert(Message(id: UUID().uuidString, name: "Protobuf: \(note.title)", timestamp: Date()), at: 0)
            }.store(in: &cancellables)

        courierClient.connectionStatePublisher
            .sink { [weak self] (connection) in
                guard let self = self else { return }
                self.handleConnectionStateEvent(connection)
            }.store(in: &cancellables)

        let courierAvailability = CourierAvailability(
            courierEventManager: courierClient, availabilityPoliciesFactory: AvailabilityPoliciesFactory(
                connectionServiceFallbackPolicyConfig: CourierAvailabilityPolicyConfig(policyEnabled: true, fallbackDelaySeconds: 5, isShadowMode: false),
                courierFallbackPolicyConfig: CourierAvailabilityPolicyConfig(policyEnabled: true, fallbackDelaySeconds: 5, isShadowMode: false),
                connectionStatusPolicyConfig: CourierAvailabilityPolicyConfig(policyEnabled: true, fallbackDelaySeconds: 5, isShadowMode: false))
        )

        courierAvailability.publisher
            .sink { [weak self] (availability) in
                guard let self = self else { return }
                self.handleAvailabilityEvent(availability)
            }.store(in: &cancellables)

        self.courierService = courierClient
        self.courierAvailability = courierAvailability

    }

    func send(message: String) {
        let message = Message(
            id: UUID().uuidString,
            name: message,
            timestamp: Date()
        )

        try? courierService?.publishMessage(
            message,
            topic: topic,
            qos: qos
        )
    }

    func sendNoteProto(message: String) {
        var note = Note()
        note.title = message

        try? courierService.publishMessage(
            note,
            topic: topic,
            qos: qos)
    }

    private func disconnect() {

    }

    deinit {
        disconnect()
    }

    private func handleMessageReceiveEvent(_ message: Result<Message, NSError>) {
        switch message {
        case let .success(message):
            messages.insert(message, at: 0)
        case let .failure(error):
            if error.domain == ServerError.Domain {
                messages.insert(.init(id: UUID().uuidString, name: error.localizedDescription, timestamp: .init()), at: 0)
            } else {
                messages.insert(.init(id: UUID().uuidString, name: "An error has been occured", timestamp: .init()), at: 0)
            }
        }
    }

    private func handleConnectionStateEvent(_ connectionState: ConnectionState) {
        switch connectionState {
        case .connected:
            self.connectedState = "Connected"
        case .connecting:
            self.connectedState = "Connecting"
        case .disconnected:
            self.connectedState = "Disconnected"
        }
    }

    private func handleAvailabilityEvent(_ availabilityEvent: AvailabilityEvent?) {
        switch availabilityEvent {
        case .connectionServiceAvailable:
            self.availabilityState = "Auth Service Available"
        case .connectionServiceUnavailable:
            self.availabilityState = "Auth Service Unavailable"
        case .courierAvailable:
            self.availabilityState = "Courier Available"
        case .courierConnected:
            self.availabilityState = "Courier Connected"
        case .courierDisconnected:
            self.availabilityState = "Courier Disconnected"
        case .courierIdle:
            self.availabilityState = "Courier Idle"
        case .courierNotIdle:
            self.availabilityState = "Courier Not Idle"
        case .courierUnavailable:
            self.availabilityState = "Courier Unavailable"
        default:
            self.availabilityState = "Unknown"
        }
    }

    private func handleErrorStream(_ error: Error) {
        print(error.localizedDescription)
    }

  }
