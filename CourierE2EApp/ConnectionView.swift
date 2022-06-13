//
//  ConnectionView.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 13/06/22.
//

import SwiftUI

struct ConnectionView: View {
    
    @StateObject var connectionVM: ConnectionObservableObject
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        List {
            connectionSection
            subscriptionSection
            publishSection
            messagesSection
        }
        .navigationTitle(connectionVM.connectionServiceProvider.ipAddress)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Disconnect", role: .destructive) {
                    connectionVM.disconnect()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear { connectionVM.connect() }
        .onDisappear { connectionVM.disconnect() }
    }
    
    var connectionSection: some View {
        Section {
            DisclosureGroup {
                Text("IP: \(connectionVM.connectionServiceProvider.ipAddress)")
                Text("Port: \(String(connectionVM.connectionServiceProvider.port))")
                Text("ClientID: \(connectionVM.connectionServiceProvider.clientId)")
                if let username = connectionVM.connectionServiceProvider.username {
                    Text("Username: \(username)")
                }
                if let password = connectionVM.connectionServiceProvider.password {
                    Text("Password: \(password)")
                }
                
            } label: {
                HStack {
                    Text("Connection")
                        .font(.headline)
                    
                    Circle()
                        .foregroundColor(connectionVM.connectionColor)
                        .frame(width: 15, height: 15)
                }
            }
        }
    }
    
    var publishSection: some View {
        Section {
            DisclosureGroup {
                HStack {
                    Text("Topic:")
                    TextField("Enter topic", text: $connectionVM.publishTopic)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                }
                
                HStack {
                    Text("QoS")
                    Picker(selection: $connectionVM.publishQoS) {
                        ForEach(0..<3) { index in
                            Text(String(index)).tag(index)
                        }
                    } label: {
                        Text("QoS")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                VStack(alignment: .leading) {
                    Text("Message:")
                    TextEditor(text: $connectionVM.publishMessage)
                        .frame(maxWidth: .infinity, minHeight: 50, maxHeight: 150)
                }
                Button("Publish") { try? connectionVM.publish() }
                
            } label: {
                Text("Publish")
                    .font(.headline)
            }
        }
        
    }
    
    var subscriptionSection: some View {
        Section {
            DisclosureGroup {
                DisclosureGroup {
                    HStack {
                        Text("Topic:")
                        TextField("Enter topic", text: $connectionVM.subscribeTopic)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                    }
                    
                    HStack {
                        Text("QoS")
                        Picker(selection: $connectionVM.subscribeQoS) {
                            ForEach(0..<3) { index in
                                Text(String(index)).tag(index)
                            }
                        } label: {
                            Text("QoS")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    Button("Subscribe") { try? connectionVM.subscribe() }
                  
                } label: {
                    Text("Add new topic subscription")
                        .font(.subheadline)
                        .foregroundColor(.accentColor)
                }
                
                ForEach(connectionVM.subscriptionList) { topicData in
                    HStack {
                        Text("Topic: \(topicData.topic)")
                        Text("QoS: \(String(topicData.qos))")
                    }
                }
                .onDelete { connectionVM.unsubscribe(indexSet: $0) }
            } label: {
                Text("Subscriptions (\(String(connectionVM.subscriptionList.count)))")
                    .font(.headline)
            }
        }
    }
    
    var messagesSection: some View {
        Section {
            DisclosureGroup {
                ForEach(connectionVM.messageList) { messageData in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(messageData.timestamp, style: .time)
                            Text("Topic: \(messageData.topic)")
                            Text("QoS: \(String(messageData.qos))")
                        }.font(.caption)
                        
                        Text(messageData.message)
                    }
                }
            } label: {
                Text("Messages (\(String(connectionVM.messageList.count)))")
                    .font(.headline)
            }
        }
    }
}

struct ConnectionView_Previews: PreviewProvider {
    static var previews: some View {
        ConnectionView(connectionVM: .init(
            connectionserviceProvider: .init(
                ipAddress: "broker.mqttdashboard.com",
                port: 1883,
                clientId: UUID().uuidString,
                isCleanSession: true,
                pingInterval: 60)
        ))
    }
}
