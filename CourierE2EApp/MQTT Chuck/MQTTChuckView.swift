//
//  MQTTChuckView.swift
//  CourierE2EApp
//
//  Created by Alfian Losari on 10/04/23.
//

import SwiftUI

struct MQTTChuckView: View {
    
    @StateObject var vm = MQTTChuckViewModel()
    
    
    var body: some View {
        List {
            ForEach(vm.logs) { log in
                HStack(alignment: .top) {
                    if log.sending {
                        Image(systemName: "arrow.up.message.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.multicolor)
                            .foregroundColor(.accentColor)
                    } else {
                        Image(systemName: "arrow.down.message.fill")
                            .imageScale(.large)
                            .symbolRenderingMode(.multicolor)
                            .foregroundColor(Color(uiColor: .systemGreen))
                    }
                    
                    VStack(alignment: .leading) {
                        Text(log.commandType.uppercased()).font(.headline)
                        HStack(alignment: .top) {
                            Text(vm.dateFormatter.string(from: log.timestamp))
                            Spacer()

                            if let dataLength = log.dataLength {
                                Text("\(dataLength) B")
                            } else {
                                Text("-")
                            }
                            
                            
                           
                            
                        }
                        
                        DisclosureGroup("Details") {
                            Text("Message ID: \(log.messageId)")
                            
                            Text("Dup: \(String(log.dup)) - retained: \(String(log.retained))")
                            
                            
                            if let dataString = log.dataString, !dataString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                Text("data: \(dataString.debugDescription)")
                            } else {
                                Text("data: N/A")
                            }
                        }
                        
                        
                    }
                    
                }
                
            }
        }
        .navigationTitle("Courier MQTT Chuck")
    }
}

struct MQTTChuckView_Previews: PreviewProvider {
    static var previews: some View {
        MQTTChuckView()
    }
}
