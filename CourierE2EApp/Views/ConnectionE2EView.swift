//
//  ConnectionE2EView.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 16/06/22.
//

import SwiftUI
import CourierMQTTChuck

struct ConnectionE2EView: View {
    
    @StateObject var connectionVM: ConnectionE2EObservableObject
    @Environment(\.presentationMode) var presentationMode
    @State var showChuckView = false


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
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Chuck") {
                    self.showChuckView = true
                }
            }
        }
        .sheet(isPresented: $showChuckView, content: {
            NavigationView {
                MQTTChuckView(logger: connectionVM.logger)
            }
        })
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
                Text("Topic: chat/\(connectionVM.username)/send")
                
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
        Section("Subscription") {
            Text("chat/\(connectionVM.roomCode)/receive")
        }
    }
    
    var messagesSection: some View {
        Section {
            DisclosureGroup {
                if connectionVM.messageList.count > 8 {
                    Button("Clear All", role: .destructive) {
                        connectionVM.removellMessages()
                    }
                }
                
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
                .onDelete { connectionVM.removeMessage(indexSet: $0) }
            } label: {
                Text("Messages (\(String(connectionVM.messageList.count)))")
                    .font(.headline)
            }
        }
    }
}
