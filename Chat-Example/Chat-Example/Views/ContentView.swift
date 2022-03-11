import SwiftUI
  import CourierCore

  struct ContentView: View {

    @State var messageText = ""
    @ObservedObject var courierVM = CourierObservableObject()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Host: broker.mqttdashboard.com:1883")
                    Text("Topic: \(courierVM.topic)")

                    Text("MQTT Connection: \(courierVM.connectedState)")

                    HStack {
                        Text("QoS")
                        Picker(selection: self.$courierVM.qos, label: Text("QoS"), content: {
                            Text("0").tag(QoS.zero)
                            Text("1").tag(QoS.one)
                            Text("2").tag(QoS.two)
                        })
                        .pickerStyle(SegmentedPickerStyle())

                    }

                }

                .padding(.horizontal)

                Divider()

                HStack {
                    TextField("Message", text: $messageText)
                    Button("Send") {

                        courierVM.send(message: messageText)
                        messageText = ""
                    }

                }
                .padding(.horizontal)

                Divider()

                List(courierVM.messages) { message in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(message.name)
                            Text(message.timestamp, style: .time)
                                .font(.caption)
                        }
                        Spacer()
                        Text("QoS \(courierVM.qos.rawValue)")
                    }

                }
            }
            .navigationTitle("Chatterz")
            .onAppear {
                courierVM.connect()
            }
        }
    }
  }

  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
  }
