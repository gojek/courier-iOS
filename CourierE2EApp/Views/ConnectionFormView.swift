//
//  ConnectionFormView.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 13/06/22.
//

import SwiftUI

enum FormFlow: String, Hashable, CaseIterable, Identifiable {
    case courierE2E = "E2E"
    case mqtt = "Normal"
    
    
    var id: String { self.rawValue }
}

struct ConnectionFormView: View {
    
    @State var formFlow = FormFlow.courierE2E
    
    @State var ipAddress: String = ""
    @State var port: String = "1883"
    
    @State var clientID = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    @State var username = "user_1"
    @State var password = ""
    @State var roomCode = "chat_room"
    
    @State var isCleanSession = true
    @State var pingInterval = "60"
    @State var isErrorShown = false
    @State var errorMessage: String?
    @State var connectionServiceProviderForE2EFlow: ConnectionServiceProvider?
    @State var connectionServiceProviderForNormalFlow: ConnectionServiceProvider?
    
    var headerFlowText: String {
        if formFlow == .courierE2E {
            return "In E2E flow, you need to provide the username and room code to connect. Subscription will be made to \"chat/{room_code}/receive\" topic and published message will be send to \"chat/{username}/send\" topic"
        } else {
            return "Standard MQTT Flow, you can subscribe and publish to any topic(s)"
        }
    }
    
    var body: some View {
        Form {
            List {
                Section {
                    Picker(selection: $formFlow) {
                        ForEach(FormFlow.allCases) { flow in
                            Text(flow.rawValue)
                                .tag(flow)
                        }
                    } label: {
                        Text("Flow")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                } header: {
                    Text("Flow")
                } footer: {
                    Text(headerFlowText)
                }
             

                
                Section {
                    HStack {
                        Text("IP Address:")
                        TextField("Enter Broker IP", text: $ipAddress)
                            .keyboardType(.URL)
                    }
                    
                    HStack {
                        Text("Port:")
                        TextField("Enter Port", text: $port)
                            .keyboardType(.decimalPad)
                    }
                    
                    Button("Use HiveMQ Public Address & Port") {
                        self.ipAddress = "broker.mqttdashboard.com"
                        self.port = "1883"
                    }
                } header: {
                    Text("Connection")
                }
                
                Section("ClientID") {
                    HStack {
                        Text("ClientID:")
                        TextField("Enter ClientID", text: $clientID)
                    }
                    
                    Button("Use Device Vendor UUID") {
                        self.clientID = UIDevice.current.identifierForVendor?.uuidString ?? ""
                        
                    }
                    
                    Button("Use Random Generated UUID") {
                        self.clientID = UUID().uuidString
                    }
                }
                
                Section("Credentials") {
                  
                    HStack {
                        Text("Username:")
                        TextField("Enter Username \(formFlow != .courierE2E ? "(optional)" : "") ", text: $username)
                            .textContentType(.username)
                        
                    }
                    
                    if formFlow != .courierE2E {
                        HStack {
                            Text("Password:")
                            TextField("Enter Password (optional)", text: $password)
                            
                        }
                    }
                    
                    if formFlow == .courierE2E {
                        HStack {
                            Text("Room Code:")
                            TextField("Enter room code", text: $roomCode)

                        }
                    }
                }
                
                Section("Configuration") {
                    Toggle("Clean Session", isOn: $isCleanSession)
                    HStack {
                        Text("Ping Interval:")
                        TextField("Ping Interval", text: $pingInterval)
                    }
                }
            }
        }
        .disableAutocorrection(true)
        .autocapitalization(.none)
        .multilineTextAlignment(.trailing)
        .navigationTitle("Courier")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Connect") { connectButtonTapped() }
            }
            
        }
        .fullScreenCover(item: $connectionServiceProviderForE2EFlow) { provider in
            NavigationView {
                ConnectionE2EView(connectionVM: ConnectionE2EObservableObject(connectionserviceProvider: provider, username: username, roomCode: roomCode))
            }
        }
        .fullScreenCover(item: $connectionServiceProviderForNormalFlow) { provider in
            NavigationView {
                ConnectionView(connectionVM: ConnectionObservableObject(connectionserviceProvider: provider))
            }
        }

        .alert("Error",
               isPresented: $isErrorShown,
               presenting: errorMessage) { _ in Button("OK") {}
        } message: { Text($0) }
    }
    
    func connectButtonTapped() {
        var errorMessages = [String]()
        if ipAddress.isEmpty {
            errorMessages.append("Please fill IP Address field.")
        }
        
        if Int(self.port) == nil {
            errorMessages.append("Port field is not valid")
        }
        
        if clientID.isEmpty {
            errorMessages.append("Please fill ClientID field.")
        }
        
        if formFlow == .courierE2E && username.isEmpty {
            errorMessages.append("Please fill username field.")
        }
        
        if formFlow == .courierE2E && roomCode.isEmpty {
            errorMessages.append("Please fill the room code")
        }
        
        if Int(self.pingInterval) == nil {
            errorMessages.append("Ping interval field is not valid")
        }
        
        if !errorMessages.isEmpty {
            self.errorMessage = errorMessages.joined(separator: "\n")
            isErrorShown = true
            return
        }
        
        startConnect()
    }
    
    func startConnect() {
        let provider = ConnectionServiceProvider(
            ipAddress: ipAddress,
            port: Int(self.port) ?? 1883,
            clientId: self.clientID,
            isCleanSession: self.isCleanSession,
            pingInterval: Int(self.pingInterval) ?? 60)
        switch formFlow {
        case .courierE2E:
            self.connectionServiceProviderForE2EFlow = provider
        case .mqtt:
            self.connectionServiceProviderForNormalFlow = provider
        }
    }
    
}

extension ConnectionServiceProvider: Identifiable {
    var id: String { clientId }
}

struct ConnectionFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ConnectionFormView()
        }
    }
}
