"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[421],{3905:function(e,t,n){n.d(t,{Zo:function(){return l},kt:function(){return N}});var i=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function s(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);t&&(i=i.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,i)}return n}function r(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?s(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):s(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function M(e,t){if(null==e)return{};var n,i,o=function(e,t){if(null==e)return{};var n,i,o={},s=Object.keys(e);for(i=0;i<s.length;i++)n=s[i],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var s=Object.getOwnPropertySymbols(e);for(i=0;i<s.length;i++)n=s[i],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var a=i.createContext({}),u=function(e){var t=i.useContext(a),n=t;return e&&(n="function"==typeof e?e(t):r(r({},t),e)),n},l=function(e){var t=u(e.components);return i.createElement(a.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return i.createElement(i.Fragment,{},t)}},L=i.forwardRef((function(e,t){var n=e.components,o=e.mdxType,s=e.originalType,a=e.parentName,l=M(e,["components","mdxType","originalType","parentName"]),L=u(n),N=o,w=L["".concat(a,".").concat(N)]||L[N]||c[N]||s;return n?i.createElement(w,r(r({ref:t},l),{},{components:n})):i.createElement(w,r({ref:t},l))}));function N(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var s=n.length,r=new Array(s);r[0]=L;var M={};for(var a in t)hasOwnProperty.call(t,a)&&(M[a]=t[a]);M.originalType=e,M.mdxType="string"==typeof e?e:o,r[1]=M;for(var u=2;u<s;u++)r[u]=n[u];return i.createElement.apply(null,r)}return i.createElement.apply(null,n)}L.displayName="MDXCreateElement"},6527:function(e,t,n){n.r(t),n.d(t,{assets:function(){return l},contentTitle:function(){return a},default:function(){return N},frontMatter:function(){return M},metadata:function(){return u},toc:function(){return c}});var i=n(7462),o=n(3366),s=(n(7294),n(3905)),r=["components"],M={},a=void 0,u={unversionedId:"README",id:"README",title:"README",description:"image banner",source:"@site/docs/README.md",sourceDirName:".",slug:"/",permalink:"/courier-iOS/docs/",draft:!1,editUrl:"https://github.com/gojek/courier-iOS/edit/main/docs/docs/README.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",next:{title:"Courier iOS - Contribution Guidelines",permalink:"/courier-iOS/docs/CONTRIBUTION"}},l={},c=[{value:"Overview",id:"overview",level:2},{value:"Getting Started",id:"getting-started",level:2},{value:"Sample App",id:"sample-app",level:3},{value:"Installation",id:"installation",level:3},{value:"Implement IConnectionServiceProvider to provide ConnectOptions for Authentication",id:"implement-iconnectionserviceprovider-to-provide-connectoptions-for-authentication",level:3},{value:"Configure and Create MQTT CourierClient Instance with CourierClientFactory",id:"configure-and-create-mqtt-courierclient-instance-with-courierclientfactory",level:3},{value:"Managing Connection Lifecycle in CourierClient",id:"managing-connection-lifecycle-in-courierclient",level:3},{value:"QoS level in MQTT",id:"qos-level-in-mqtt",level:3},{value:"Subscribe to topics from Broker",id:"subscribe-to-topics-from-broker",level:3},{value:"Receive Message from Subscribed Topic",id:"receive-message-from-subscribed-topic",level:3},{value:"Unsubscribe from topics",id:"unsubscribe-from-topics",level:3},{value:"Send Message to Broker",id:"send-message-to-broker",level:3},{value:"Listen to Courier internal events",id:"listen-to-courier-internal-events",level:3},{value:"Contribution Guidelines",id:"contribution-guidelines",level:2},{value:"License",id:"license",level:2}],L={toc:c};function N(e){var t=e.components,M=(0,o.Z)(e,r);return(0,s.kt)("wrapper",(0,i.Z)({},L,M,{components:t,mdxType:"MDXLayout"}),(0,s.kt)("p",null,(0,s.kt)("img",{alt:"image banner",src:n(8698).Z+"#gh-light-mode-only",width:"1959",height:"526"}),"\n",(0,s.kt)("img",{alt:"image banner",src:n(7890).Z+"#gh-dark-mode-only",width:"1959",height:"526"})),(0,s.kt)("h2",{id:"overview"},"Overview"),(0,s.kt)("p",null,"Courier is a library for creating long running connections using ",(0,s.kt)("a",{parentName:"p",href:"https://mqtt.org"},"MQTT")," which is the industry standard for IoT Messaging. Long running connection is a persistent connection established between client & server for bi-directional communication. A long running connection is maintained for as long as possible with the help of keepalive packets for instant updates. This also saves battery and data on mobile devices."),(0,s.kt)("h2",{id:"getting-started"},"Getting Started"),(0,s.kt)("p",null,"Setup Courier to subscribe, send, and receive message with bi-directional long running connection between iOS device and broker."),(0,s.kt)("h3",{id:"sample-app"},"Sample App"),(0,s.kt)("p",null,"You can run the sample App that connects to ",(0,s.kt)("a",{parentName:"p",href:"https://broker.mqttdashboard.com"},"HiveMQ")," public broker. Select ",(0,s.kt)("inlineCode",{parentName:"p"},"Chat-Example")," from the scheme."),(0,s.kt)("h3",{id:"installation"},"Installation"),(0,s.kt)("p",null,"Courier uses Cocoapods for adding it as a dependency to a project in a ",(0,s.kt)("inlineCode",{parentName:"p"},"Podfile"),". It is separated into 5 modules:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"CourierCore"),": Contains public APIs such as protocols and data types for Courier. Other modules have basic dependency on this module. You can use this module if you want to implement the interface in your project without adding Courier implementation in your project."),(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"CourierMQTT"),": Contains implementation of ",(0,s.kt)("inlineCode",{parentName:"li"},"CourierClient")," and ",(0,s.kt)("inlineCode",{parentName:"li"},"CourierSession")," using ",(0,s.kt)("inlineCode",{parentName:"li"},"MQTT"),". This module has dependency to ",(0,s.kt)("inlineCode",{parentName:"li"},"MQTTClientGJ"),"."),(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"MQTTClientGJ"),": A forked version of open source library ",(0,s.kt)("a",{parentName:"li",href:"https://github.com/novastone-media/MQTT-Client-Framework"},"MQTT-Client-Framework"),". It add several features such as connect and inactivity timeout. It also fixes race condition crashes in ",(0,s.kt)("inlineCode",{parentName:"li"},"MQTTSocketEncoder")," and ",(0,s.kt)("inlineCode",{parentName:"li"},"Connack")," status 5 not completing the decode before ",(0,s.kt)("inlineCode",{parentName:"li"},"MQTTTransportDidClose")," got invoked bugs."),(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"CourierProtobuf"),": Contains implementation of ",(0,s.kt)("inlineCode",{parentName:"li"},"ProtobufMessageAdapter")," using ",(0,s.kt)("inlineCode",{parentName:"li"},"Protofobuf"),". It has dependency to ",(0,s.kt)("inlineCode",{parentName:"li"},"SwiftProtobuf")," library, this is ",(0,s.kt)("inlineCode",{parentName:"li"},"optional")," and can be used if you are using protobuf for data serialization.")),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-ruby"},"// Podfile\ntarget 'Example-App' do\n  use_frameworks!\n  pod 'CourierCore'\n  pod 'CourierMQTT'\n  pod 'CourierProtobuf'\nend\n")),(0,s.kt)("h3",{id:"implement-iconnectionserviceprovider-to-provide-connectoptions-for-authentication"},"Implement IConnectionServiceProvider to provide ConnectOptions for Authentication"),(0,s.kt)("p",null,"To connect to MQTT broker you need to implement IConnectionServiceProvider. First you need to implement ",(0,s.kt)("inlineCode",{parentName:"p"},"IConnectionServiceProvider/clientId")," to return an unique string to identify your client. This must be unique for each device that connect to broker."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"var clientId: String {\n    UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString\n}\n")),(0,s.kt)("p",null,"Next, you need to implement ",(0,s.kt)("inlineCode",{parentName:"p"},"IConnectionServiceProvider/getConnectOptions(completion:)")," method. You need to provide ",(0,s.kt)("inlineCode",{parentName:"p"},"ConnectOptions")," instance that will be used to make connection to the broker. This method provides an escaping closure, in case you need to retrieve the credential from remote API asynchronously. "),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"func getConnectOptions(completion: @escaping (Result<ConnectOptions, AuthError>) -> Void) {\n    executeNetworkRequest { (response: ConnectOptions) in\n        completion(.success(connectOptions))\n    } failure: { _, _, error in\n        completion(.failure(error))\n    }\n}\n")),(0,s.kt)("p",null,"Here are the data that you need to provide in ConnectOptions."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"/// IP Host address of the broker\npublic let host: String\n/// Port of the broker\npublic let port: UInt16\n/// Keep Alive interval used to ping the broker over time to maintain the long run connection\npublic let keepAlive: UInt16\n/// Unique Client ID used by broker to identify connected clients\npublic let clientId: String\n/// Username of the client\npublic let username: String\n/// Password of the client used for authentication by the broker\npublic let password: String\n/// Tells broker whether to clear the previous session by the clients\npublic let isCleanSession: Bool\n")),(0,s.kt)("h3",{id:"configure-and-create-mqtt-courierclient-instance-with-courierclientfactory"},"Configure and Create MQTT CourierClient Instance with CourierClientFactory"),(0,s.kt)("p",null,"Next, we need to create instance of CourierClient that uses MQTT as its implementation. Initialize ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierClientFactory")," instance and invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierClientFactory/makeMQTTClient(config:)"),". We need to pass instance MQTTClientConfig with several parameters that we can customize. "),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"let clientFactory = CourierClientFactory()\nlet courierClient = clientFactory.makeMQTTClient(\n    config: MQTTClientConfig(\n        authService: HiveMQAuthService(),\n        messageAdapters: [\n            JSONMessageAdapter(),\n            ProtobufMessageAdapter()\n        ],\n        autoReconnectInterval: 1,\n        maxAutoReconnectInterval: 30\n    )\n)\n")),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"MQTTClientConfig/messageAdapters"),": we need to pass array of ",(0,s.kt)("inlineCode",{parentName:"li"},"MessageAdapter"),". This will be used for serialization when receiving from broker and sending message to the broker. ",(0,s.kt)("inlineCode",{parentName:"li"},"CourierMQTT")," provides built in message adapters for JSON ",(0,s.kt)("inlineCode",{parentName:"li"},"(JSONMessageAdapter)")," and Plist ",(0,s.kt)("inlineCode",{parentName:"li"},"(PlistMessageAdapter)")," format that conforms to ",(0,s.kt)("inlineCode",{parentName:"li"},"Codable")," protocol. You can only use one of them because both implements to Codable to avoid any conflict. To use protobuf, please import ",(0,s.kt)("inlineCode",{parentName:"li"},"CourierProtobuf")," and pass ",(0,s.kt)("inlineCode",{parentName:"li"},"ProtobufMessageAdapter"),"."),(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"MQTTClientConfig/authService"),": we need to pass our implementation of IConnectionServiceProvider protocol for providing the ConnectOptions to the client."),(0,s.kt)("li",{parentName:"ul"},(0,s.kt)("inlineCode",{parentName:"li"},"MQTTClientConfig/autoReconnectInterval")," The interval used to make reconnection to broker in case of connection lost. This will be multiplied by 2 for each time until it successfully make the connection. The upper limit is based on ",(0,s.kt)("inlineCode",{parentName:"li"},"MQTTClientConfig/maxAutoReconnectInterval"),".")),(0,s.kt)("h3",{id:"managing-connection-lifecycle-in-courierclient"},"Managing Connection Lifecycle in CourierClient"),(0,s.kt)("p",null,"To connect to the broker, you simply need to invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"connect")," method"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"courierClient.connect()\n")),(0,s.kt)("p",null,"To disconnect, you just need to invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"disconnect")," method"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"courierClient.disconnect()\n")),(0,s.kt)("p",null,"To get the ConnectionState, you can access the CourierSession/connectionState property"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"courierClient.connectionState\n")),(0,s.kt)("p",null,"You can also subscribe the ",(0,s.kt)("inlineCode",{parentName:"p"},"ConnectionState")," publisher using the ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/connectionStatePublisher")," property. The observable API that Courier provide is very similar to ",(0,s.kt)("inlineCode",{parentName:"p"},"Apple Combine")," although it is implemented internally using ",(0,s.kt)("inlineCode",{parentName:"p"},"RxSwift")," so we can support ",(0,s.kt)("inlineCode",{parentName:"p"},"iOS 12"),"."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"courierClient.connectionStatePublisher\n    .sink { [weak self] self?.handleConnectionStateEvent($0) }\n    .store(in: &cancellables)\n")),(0,s.kt)("p",null,"As MQTT supports QoS 1 and QoS 2 message to ensure deliverability when there is no internet connection and user reconnected back to broker, we also persists those message in local cache. To disconnect and remove all of this cache, you can invoke."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"courierClient.destroy()\n")),(0,s.kt)("p",null,"There are several things that you need to keep in mind when using Courier:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"Courier will always disconnect when the app goes to background as iOS doesn't support long run socket connection in background."),(0,s.kt)("li",{parentName:"ul"},"Courier will always automatically reconnect when the app goes to foreground if there is a topic to subscribe."),(0,s.kt)("li",{parentName:"ul"},"Courier handles reconnection in case of bad/lost internet connection using Reachability framework."),(0,s.kt)("li",{parentName:"ul"},"Courier will persist QoS > 0 messages in case there are no active subscription to Observable/Publisher using configurable TTL.")),(0,s.kt)("h3",{id:"qos-level-in-mqtt"},"QoS level in MQTT"),(0,s.kt)("p",null,"The Quality of Service (QoS) level is an agreement between the sender of a message and the receiver of a message that defines the guarantee of delivery for a specific message. There are 3 QoS levels in MQTT:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"At most once (0)"),(0,s.kt)("li",{parentName:"ul"},"At least once (1)"),(0,s.kt)("li",{parentName:"ul"},"Exactly once (2).")),(0,s.kt)("p",null,"When you talk about QoS in MQTT, you need to consider the two sides of message delivery:"),(0,s.kt)("ul",null,(0,s.kt)("li",{parentName:"ul"},"Message delivery form the publishing client to the broker."),(0,s.kt)("li",{parentName:"ul"},"Message delivery from the broker to the subscribing client.")),(0,s.kt)("p",null,"You can read more about the detail of QoS in MQTT from ",(0,s.kt)("a",{parentName:"p",href:"https://www.hivemq.com/blog/mqtt-essentials-part-6-mqtt-quality-of-service-levels/"},"HiveMQ")," site."),(0,s.kt)("h3",{id:"subscribe-to-topics-from-broker"},"Subscribe to topics from Broker"),(0,s.kt)("p",null,"To subscribe to a topic from the broker. we can invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/subscribe(_:)")," and pass a tuple containing the topic string and QoS enum."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},'courierClient.subscribe(("chat/user1", QoS.zero))\n')),(0,s.kt)("p",null,"You can also subscribe to multiple topics, invoking ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/subscribe(_:)")," and pass an array containing tuples of topic string and QoS enum"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},'courierClient.subscribe([\n    ("chat/user1", QoS.zero),\n    ("order/1234", QoS.one),\n    ("order/123456", QoS.two),\n])\n')),(0,s.kt)("h3",{id:"receive-message-from-subscribed-topic"},"Receive Message from Subscribed Topic"),(0,s.kt)("p",null,"After you have subscribed to the topic, you need to subscribe to a message publisher passing the associated topic using ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/messagePublisher(topic:)"),". This method uses ",(0,s.kt)("inlineCode",{parentName:"p"},"Generic")," for serializing the binary data to a type. Make sure you have provided the associated MessageAdapter that can decode the data to the type. "),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},'courierClient.messagePublisher(topic: topic)\n    .sink { [weak self] (note: Note) in\n        self?.messages.insert(Message(id: UUID().uuidString, name: "Protobuf: \\(note.title)", timestamp: Date()), at: 0)\n    }.store(in: &cancellables)\n')),(0,s.kt)("p",null,"This method returns AnyPublisher which you can chain with operators such as ",(0,s.kt)("inlineCode",{parentName:"p"},"AnyPublisher/filter(predicate:)")," or ",(0,s.kt)("inlineCode",{parentName:"p"},"AnyPublisher/map(transform:)"),"."),(0,s.kt)("p",null,"The observable API that Courier provide is very similar to Apple Combine although it is implemented internally using RxSwift so we can support iOS 12, only the ",(0,s.kt)("inlineCode",{parentName:"p"},"filter")," and ",(0,s.kt)("inlineCode",{parentName:"p"},"map")," operators are supported."),(0,s.kt)("h3",{id:"unsubscribe-from-topics"},"Unsubscribe from topics"),(0,s.kt)("p",null,"To unsubscribe from a topic. we can invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/unsubscribe(_:)")," and pass a topic string."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},'courierClient.unsubscribe("chat/user1")\n')),(0,s.kt)("p",null,"You can also subscribe to multiple topics, invoking ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/unsubscribe(_:)")," and pass an array containing tuples of topic string and QoS enum"),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},'courierClient.unsubscribe([\n    "chat/user1",\n    "order/"\n])\n')),(0,s.kt)("h3",{id:"send-message-to-broker"},"Send Message to Broker"),(0,s.kt)("p",null,"To send the message to the broker, first make sure you have provided a ",(0,s.kt)("inlineCode",{parentName:"p"},"MessageAdapter")," that is able to encode your object to the binary data format. For example, if you have a data struct that you want to send as JSON. Make sure, it conforms to ",(0,s.kt)("inlineCode",{parentName:"p"},"Encodable")," protocol and pass ",(0,s.kt)("inlineCode",{parentName:"p"},"JSONMessageAdapter")," in ",(0,s.kt)("inlineCode",{parentName:"p"},"MQTTClientConfig")," when creating the ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierClient")," instance."),(0,s.kt)("p",null,"You simply need to invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierSession/publishMessage(_:topic:qos:)")," passing the topic string and QoS enum. This is a ",(0,s.kt)("inlineCode",{parentName:"p"},"throwing")," function which can throw in case it fails to encode to data."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},'let message = Message(\n    id: UUID().uuidString,\n    name: message,\n    timestamp: Date()\n)\n        \ntry? courierService?.publishMessage(\n    message,\n    topic: "chat/1234",\n    qos: QoS.zero\n)\n')),(0,s.kt)("h3",{id:"listen-to-courier-internal-events"},"Listen to Courier internal events"),(0,s.kt)("p",null,"To listen to Courier system events such on ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierEvent/connectionSuccess"),", ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierEvent/connectionAttempt"),", and many more casess declared in ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierEvent")," enum, you can implement the ",(0,s.kt)("inlineCode",{parentName:"p"},"ICourierEventHandler")," protocol and implement ",(0,s.kt)("inlineCode",{parentName:"p"},"ICourierEventHandler/onEvent(_:)")," method. This method will be invoked for any courier system events."),(0,s.kt)("p",null,"Finally, make sure to have strong reference to the instance, and invoke ",(0,s.kt)("inlineCode",{parentName:"p"},"CourierEventManager/addEventHandler(_:)")," passing the instance."),(0,s.kt)("pre",null,(0,s.kt)("code",{parentName:"pre",className:"language-swift"},"courierClient.addEventHandler(analytics)\n")),(0,s.kt)("h2",{id:"contribution-guidelines"},"Contribution Guidelines"),(0,s.kt)("p",null,"Read our ",(0,s.kt)("a",{parentName:"p",href:"/courier-iOS/docs/CONTRIBUTION"},"contribution guide")," to learn about our development process, how to propose bugfixes and improvements, and how to build and test your changes to Courier iOS library."),(0,s.kt)("h2",{id:"license"},"License"),(0,s.kt)("p",null,"All Courier modules except MQTTClientGJ are ",(0,s.kt)("a",{parentName:"p",href:"LICENSE"},"MIT Licensed"),". MQTTClientGJ is ",(0,s.kt)("a",{parentName:"p",href:"LICENSE.MQTTClientGJ"},"Eclipse Licensed"),"."))}N.isMDXComponent=!0},8698:function(e,t){t.Z="data:image/svg+xml;base64,PHN2ZyBpZD0iTGF5ZXJfMSIgZGF0YS1uYW1lPSJMYXllciAxIiB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxOTU4LjkyIDUyNiI+PGRlZnM+PHN0eWxlPi5jbHMtMXtmaWxsOiMwMGFhMTM7fS5jbHMtMntmaWxsOiNmZmY7fTwvc3R5bGU+PC9kZWZzPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTU1OS4xNywzMjQuNjRBOTYuNCw5Ni40LDAsMSwxLDQ4MS42MiwxNzFhOTUuNyw5NS43LDAsMCwxLDc2Ljg1LDM4LjIsMTkuMzEsMTkuMzEsMCwwLDEtMTUuNDIsMzEsMTMuNzgsMTMuNzgsMCwwLDEtMTEuNTYtNiw1OS45MSw1OS45MSwwLDAsMC0xMDkuNjUsMjkuMzhBNTkuNCw1OS40LDAsMCwwLDQzOCwzMDguMzdhNTkuOTEsNTkuOTEsMCwwLDAsOTEuODktNS40NSwxNy4yLDE3LjIsMCwwLDEsMTMuOTItNi42Mkg1NDVBMTcuMzEsMTcuMzEsMCwwLDEsNTYwLjc4LDMwNiwxNy41NiwxNy41NiwwLDAsMSw1NTkuMTcsMzI0LjY0WiIvPjxyZWN0IGNsYXNzPSJjbHMtMSIgeD0iMjI5LjY3IiB5PSIxMTMuMjYiIHdpZHRoPSI1MS42IiBoZWlnaHQ9IjI4LjAyIiByeD0iMTQuMDEiLz48cmVjdCBjbGFzcz0iY2xzLTEiIHg9IjE0NS41OSIgeT0iMTY5LjMiIHdpZHRoPSI1MS42IiBoZWlnaHQ9IjI4LjAyIiByeD0iMTQuMDEiLz48cmVjdCBjbGFzcz0iY2xzLTEiIHg9IjExNS43NCIgeT0iMzM3LjQyIiB3aWR0aD0iNTEuNiIgaGVpZ2h0PSIyOC4wMiIgcng9IjE0LjAxIi8+PHJlY3QgY2xhc3M9ImNscy0xIiB4PSIyMTcuNjUiIHk9IjM5My40NiIgd2lkdGg9IjUxLjYiIGhlaWdodD0iMjguMDIiIHJ4PSIxNC4wMSIvPjxwYXRoIGNsYXNzPSJjbHMtMiIgZD0iTTU1OS4xNywzMjQuNjRBOTYuNCw5Ni40LDAsMSwxLDQ4MS42MiwxNzFhOTUuNyw5NS43LDAsMCwxLDc2Ljg1LDM4LjIsMTkuMzEsMTkuMzEsMCwwLDEtMTUuNDIsMzEsMTMuNzgsMTMuNzgsMCwwLDEtMTEuNTYtNiw1OS45MSw1OS45MSwwLDAsMC0xMDkuNjUsMjkuMzhBNTkuNCw1OS40LDAsMCwwLDQzOCwzMDguMzdhNTkuOTEsNTkuOTEsMCwwLDAsOTEuODktNS40NSwxNy4yLDE3LjIsMCwwLDEsMTMuOTItNi42Mkg1NDVBMTcuMzEsMTcuMzEsMCwwLDEsNTYwLjc4LDMwNiwxNy41NiwxNy41NiwwLDAsMSw1NTkuMTcsMzI0LjY0WiIvPjxwYXRoIGNsYXNzPSJjbHMtMSIgZD0iTTQ4Mi43NiwxMTMuMjZjLS43MywwLTUuMjksMC02LDBhMi41MywyLjUzLDAsMCwwLS4zLDBIMzE1LjZhMTQsMTQsMCwwLDAtMTQsMTVjLjUsNy40NCw3LDEzLjA1LDE0LjQ4LDEzLjA1SDM1NGExMy44NSwxMy44NSwwLDAsMSwxMC4yNiwyMy4xM2wtLjI4LjMxYTEzLjc4LDEzLjc4LDAsMCwxLTEwLjI2LDQuNTdoLTEyMmExNCwxNCwwLDAsMC0xNCwxNS4xMWMuNTYsNy4zOSw3LjEsMTIuOTEsMTQuNTEsMTIuOTFoODguMzFhMTMuODgsMTMuODgsMCwwLDEsMTMsMTguNTljMCwuMS0uMDcuMTktLjEuMjlhMTMuODIsMTMuODIsMCwwLDEtMTMsOS4xNUgyNjUuNzRhMTQsMTQsMCwwLDAtMTQsMTUuMTFjLjU3LDcuMzksNy4xLDEyLjkxLDE0LjUxLDEyLjkxaDQ0Ljg5YTEzLjYsMTMuNiwwLDAsMSwxMy41NSwxMy43MXYuNTZhMTMuNjMsMTMuNjMsMCwwLDEtMTMuNTUsMTMuNzZIMTU1LjU0YTE0LDE0LDAsMSwwLDAsMjhIMzIwLjMyYTEzLjgsMTMuOCwwLDAsMSwxMyw5LjE4bC4xLjI4YTEzLjg4LDEzLjg4LDAsMCwxLTEzLDE4LjU3aC0xMTlhMTQsMTQsMCwxLDAsMCwyOGgxNTJhMTMuNzgsMTMuNzgsMCwwLDEsMTAuMyw0LjYxbC4yNy4zMWExMy44NSwxMy44NSwwLDAsMS0xMC4yOSwyMy4xMUgzMDAuMjdhMTQsMTQsMCwxLDAsMCwyOEg0NzAuMDhjMi45NC4xOSw5LjcuMjYsMTIuNjguMjZhMTU0LjI0LDE1NC4yNCwwLDAsMCwwLTMwOC40OFptNzYuNDEsMjExLjM4QTk2LjQsOTYuNCwwLDEsMSw0ODEuNjIsMTcxYTk1LjcsOTUuNywwLDAsMSw3Ni44NSwzOC4yLDE5LjMxLDE5LjMxLDAsMCwxLTE1LjQyLDMxLDEzLjc4LDEzLjc4LDAsMCwxLTExLjU2LTYsNTkuOTEsNTkuOTEsMCwwLDAtMTA5LjY1LDI5LjM4QTU5LjQsNTkuNCwwLDAsMCw0MzgsMzA4LjM3YTU5LjkxLDU5LjkxLDAsMCwwLDkxLjg5LTUuNDUsMTcuMiwxNy4yLDAsMCwxLDEzLjkyLTYuNjJINTQ1QTE3LjMxLDE3LjMxLDAsMCwxLDU2MC43OCwzMDYsMTcuNTYsMTcuNTYsMCwwLDEsNTU5LjE3LDMyNC42NFoiLz48cGF0aCBkPSJNNjk1Ljc3LDI3MC4zMWMwLTYzLjg1LDQ2LjE2LTEwOS40LDExMC4zLTEwOS40LDUwLjY1LDAsODksMjcuODcsOTkuMjEsNzIuODNsLTQzLjE2LDEwLjc5Yy03LjUtMjcuNTctMjcuODgtNDMuNDYtNTYtNDMuNDYtMzguMzcsMC02NC40NCwyOC4xNy02NC40NCw2OS4yNHMyNi4wNyw2OS4yMyw2NC40NCw2OS4yM2MyOS4zNywwLDUwLjk1LTE3LjA4LDU2LjY1LTQ3LjM1bDQzLjQ2LDEwLjE5Yy04LjY5LDQ4LjI1LTQ4LDc3LjMzLTEwMC4xMSw3Ny4zM0M3NDEuOTMsMzc5LjcxLDY5NS43NywzMzQuMTUsNjk1Ljc3LDI3MC4zMVoiLz48cGF0aCBkPSJNOTIyLjA2LDI5NS43OGMwLTQ3LjM1LDM3LjQ2LTgzLjkyLDg5LjYxLTgzLjkyLDUyLjQ2LDAsODkuNjIsMzYuNTcsODkuNjIsODMuOTJzLTM3LjE2LDgzLjkzLTg5LjYyLDgzLjkzQzk1OS41MiwzNzkuNzEsOTIyLjA2LDM0My4xNCw5MjIuMDYsMjk1Ljc4Wm0xMzQuODcsMGMwLTI1Ljc3LTE3LjY4LTQ1LTQ1LjI2LTQ1cy00NS4yNSwxOS4xOS00NS4yNSw0NSwxNy42OCw0NSw0NS4yNSw0NVMxMDU2LjkzLDMyMS41NiwxMDU2LjkzLDI5NS43OFoiLz48cGF0aCBkPSJNMTEyMy40NywzMDcuMTdWMjE2LjM2aDQ0LjM2djg0LjIyYzAsMjQuODgsMTMuNDksMzksMzkuMjYsMzksMjQuNTgsMCw0MS4zNy0xNi4xOCw0MS4zNy0zOVYyMTYuMzZoNDQuMzZWMzc1LjIxSDEyNTB2LTE1aC0uNmMtMTMuMTksMTIuNTgtMzEuNDgsMTkuNDgtNTMuNjUsMTkuNDhDMTE1MC40NSwzNzkuNzEsMTEyMy40NywzNTMsMTEyMy40NywzMDcuMTdaIi8+PHBhdGggZD0iTTEzMjIuNzksMzc1LjIxVjIxNi4zNmg0MS42NnYxNS4yOGguNmMxMS42OS0xMiwyNy41Ny0xOC4yOCw0Ni43NS0xOC4yOGE4OS41Niw4OS41NiwwLDAsMSwyNi4wOCw0LjE5bC05LjI5LDM5Ljg3YTc2LjcsNzYuNywwLDAsMC0yMy4wOC0zLjNjLTIzLjY4LDAtMzguMzYsMTUuNTktMzguMzYsNDguNTZ2NzIuNTNaIi8+PHBhdGggZD0iTTE0NTMuMTYsMTkwLjI4VjE0NS45MkgxNDk5djQ0LjM2Wm0uOSwxODQuOTNWMjE2LjM2aDQ0LjM2VjM3NS4yMVoiLz48cGF0aCBkPSJNMTUyMS44LDI5Ni4wOGMwLTQ4Ljg1LDM2LTg0LjIyLDg2LjMyLTg0LjIyLDUzLjM1LDAsODYuMzIsMzcuNzcsODYuMzIsODUuNDJ2MTIuNTlIMTU2NS41NmMxLjUsMjAuNjgsMTguMjgsMzMuODcsNDUsMzMuODcsMTkuNzgsMCwzMy41Ny03Ljc5LDQ4Ljg1LTIzLjY4TDE2ODcsMzQ3LjY0Yy0xOC4yOSwyMC4wOC00MiwzMi4wNy03Ni4xMywzMi4wN0MxNTU1LjA3LDM3OS43MSwxNTIxLjgsMzQ2LjQ0LDE1MjEuOCwyOTYuMDhabTEyOS40OC0xNy4zOGMtMi4xLTE4LjU4LTE4LjU4LTMwLjg3LTQyLjI2LTMwLjg3LTI0LDAtNDAuNDcsMTIuMjktNDIuODYsMzAuODdaIi8+PHBhdGggZD0iTTE3MTguMTEsMzc1LjIxVjIxNi4zNmg0MS42NnYxNS4yOGguNmMxMS42OS0xMiwyNy41OC0xOC4yOCw0Ni43Ni0xOC4yOGE4OS42Miw4OS42MiwwLDAsMSwyNi4wOCw0LjE5bC05LjI5LDM5Ljg3YTc2Ljc1LDc2Ljc1LDAsMCwwLTIzLjA4LTMuM2MtMjMuNjgsMC0zOC4zNywxNS41OS0zOC4zNyw0OC41NnY3Mi41M1oiLz48L3N2Zz4="},7890:function(e,t){t.Z="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4KPHN2ZyBpZD0iTGF5ZXJfMSIgZGF0YS1uYW1lPSJMYXllciAxIiB2aWV3Qm94PSIwIDAgMTk1OC45MiA1MjYiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyI+CiAgPGRlZnM+CiAgICA8c3R5bGU+LmNscy0xe2ZpbGw6IzAwYWExMzt9LmNscy0ye2ZpbGw6I2ZmZjt9PC9zdHlsZT4KICA8L2RlZnM+CiAgPHBhdGggY2xhc3M9ImNscy0xIiBkPSJNNTU5LjE3LDMyNC42NEE5Ni40LDk2LjQsMCwxLDEsNDgxLjYyLDE3MWE5NS43LDk1LjcsMCwwLDEsNzYuODUsMzguMiwxOS4zMSwxOS4zMSwwLDAsMS0xNS40MiwzMSwxMy43OCwxMy43OCwwLDAsMS0xMS41Ni02LDU5LjkxLDU5LjkxLDAsMCwwLTEwOS42NSwyOS4zOEE1OS40LDU5LjQsMCwwLDAsNDM4LDMwOC4zN2E1OS45MSw1OS45MSwwLDAsMCw5MS44OS01LjQ1LDE3LjIsMTcuMiwwLDAsMSwxMy45Mi02LjYySDU0NUExNy4zMSwxNy4zMSwwLDAsMSw1NjAuNzgsMzA2LDE3LjU2LDE3LjU2LDAsMCwxLDU1OS4xNywzMjQuNjRaIi8+CiAgPHJlY3QgY2xhc3M9ImNscy0xIiB4PSIyMjkuNjciIHk9IjExMy4yNiIgd2lkdGg9IjUxLjYiIGhlaWdodD0iMjguMDIiIHJ4PSIxNC4wMSIvPgogIDxyZWN0IGNsYXNzPSJjbHMtMSIgeD0iMTQ1LjU5IiB5PSIxNjkuMyIgd2lkdGg9IjUxLjYiIGhlaWdodD0iMjguMDIiIHJ4PSIxNC4wMSIvPgogIDxyZWN0IGNsYXNzPSJjbHMtMSIgeD0iMTE1Ljc0IiB5PSIzMzcuNDIiIHdpZHRoPSI1MS42IiBoZWlnaHQ9IjI4LjAyIiByeD0iMTQuMDEiLz4KICA8cmVjdCBjbGFzcz0iY2xzLTEiIHg9IjIxNy42NSIgeT0iMzkzLjQ2IiB3aWR0aD0iNTEuNiIgaGVpZ2h0PSIyOC4wMiIgcng9IjE0LjAxIi8+CiAgPHBhdGggY2xhc3M9ImNscy0yIiBkPSJNNTU5LjE3LDMyNC42NEE5Ni40LDk2LjQsMCwxLDEsNDgxLjYyLDE3MWE5NS43LDk1LjcsMCwwLDEsNzYuODUsMzguMiwxOS4zMSwxOS4zMSwwLDAsMS0xNS40MiwzMSwxMy43OCwxMy43OCwwLDAsMS0xMS41Ni02LDU5LjkxLDU5LjkxLDAsMCwwLTEwOS42NSwyOS4zOEE1OS40LDU5LjQsMCwwLDAsNDM4LDMwOC4zN2E1OS45MSw1OS45MSwwLDAsMCw5MS44OS01LjQ1LDE3LjIsMTcuMiwwLDAsMSwxMy45Mi02LjYySDU0NUExNy4zMSwxNy4zMSwwLDAsMSw1NjAuNzgsMzA2LDE3LjU2LDE3LjU2LDAsMCwxLDU1OS4xNywzMjQuNjRaIi8+CiAgPHBhdGggY2xhc3M9ImNscy0xIiBkPSJNNDgyLjc2LDExMy4yNmMtLjczLDAtNS4yOSwwLTYsMGEyLjUzLDIuNTMsMCwwLDAtLjMsMEgzMTUuNmExNCwxNCwwLDAsMC0xNCwxNWMuNSw3LjQ0LDcsMTMuMDUsMTQuNDgsMTMuMDVIMzU0YTEzLjg1LDEzLjg1LDAsMCwxLDEwLjI2LDIzLjEzbC0uMjguMzFhMTMuNzgsMTMuNzgsMCwwLDEtMTAuMjYsNC41N2gtMTIyYTE0LDE0LDAsMCwwLTE0LDE1LjExYy41Niw3LjM5LDcuMSwxMi45MSwxNC41MSwxMi45MWg4OC4zMWExMy44OCwxMy44OCwwLDAsMSwxMywxOC41OWMwLC4xLS4wNy4xOS0uMS4yOWExMy44MiwxMy44MiwwLDAsMS0xMyw5LjE1SDI2NS43NGExNCwxNCwwLDAsMC0xNCwxNS4xMWMuNTcsNy4zOSw3LjEsMTIuOTEsMTQuNTEsMTIuOTFoNDQuODlhMTMuNiwxMy42LDAsMCwxLDEzLjU1LDEzLjcxdi41NmExMy42MywxMy42MywwLDAsMS0xMy41NSwxMy43NkgxNTUuNTRhMTQsMTQsMCwxLDAsMCwyOEgzMjAuMzJhMTMuOCwxMy44LDAsMCwxLDEzLDkuMThsLjEuMjhhMTMuODgsMTMuODgsMCwwLDEtMTMsMTguNTdoLTExOWExNCwxNCwwLDEsMCwwLDI4aDE1MmExMy43OCwxMy43OCwwLDAsMSwxMC4zLDQuNjFsLjI3LjMxYTEzLjg1LDEzLjg1LDAsMCwxLTEwLjI5LDIzLjExSDMwMC4yN2ExNCwxNCwwLDEsMCwwLDI4SDQ3MC4wOGMyLjk0LjE5LDkuNy4yNiwxMi42OC4yNmExNTQuMjQsMTU0LjI0LDAsMCwwLDAtMzA4LjQ4Wm03Ni40MSwyMTEuMzhBOTYuNCw5Ni40LDAsMSwxLDQ4MS42MiwxNzFhOTUuNyw5NS43LDAsMCwxLDc2Ljg1LDM4LjIsMTkuMzEsMTkuMzEsMCwwLDEtMTUuNDIsMzEsMTMuNzgsMTMuNzgsMCwwLDEtMTEuNTYtNiw1OS45MSw1OS45MSwwLDAsMC0xMDkuNjUsMjkuMzhBNTkuNCw1OS40LDAsMCwwLDQzOCwzMDguMzdhNTkuOTEsNTkuOTEsMCwwLDAsOTEuODktNS40NSwxNy4yLDE3LjIsMCwwLDEsMTMuOTItNi42Mkg1NDVBMTcuMzEsMTcuMzEsMCwwLDEsNTYwLjc4LDMwNiwxNy41NiwxNy41NiwwLDAsMSw1NTkuMTcsMzI0LjY0WiIvPgogIDxwYXRoIGQ9Ik02OTUuNzcsMjcwLjMxYzAtNjMuODUsNDYuMTYtMTA5LjQsMTEwLjMtMTA5LjQsNTAuNjUsMCw4OSwyNy44Nyw5OS4yMSw3Mi44M2wtNDMuMTYsMTAuNzljLTcuNS0yNy41Ny0yNy44OC00My40Ni01Ni00My40Ni0zOC4zNywwLTY0LjQ0LDI4LjE3LTY0LjQ0LDY5LjI0czI2LjA3LDY5LjIzLDY0LjQ0LDY5LjIzYzI5LjM3LDAsNTAuOTUtMTcuMDgsNTYuNjUtNDcuMzVsNDMuNDYsMTAuMTljLTguNjksNDguMjUtNDgsNzcuMzMtMTAwLjExLDc3LjMzQzc0MS45MywzNzkuNzEsNjk1Ljc3LDMzNC4xNSw2OTUuNzcsMjcwLjMxWiIgc3R5bGU9ImZpbGw6IHJnYigyNTUsIDI1NSwgMjU1KTsiLz4KICA8cGF0aCBkPSJNOTIyLjA2LDI5NS43OGMwLTQ3LjM1LDM3LjQ2LTgzLjkyLDg5LjYxLTgzLjkyLDUyLjQ2LDAsODkuNjIsMzYuNTcsODkuNjIsODMuOTJzLTM3LjE2LDgzLjkzLTg5LjYyLDgzLjkzQzk1OS41MiwzNzkuNzEsOTIyLjA2LDM0My4xNCw5MjIuMDYsMjk1Ljc4Wm0xMzQuODcsMGMwLTI1Ljc3LTE3LjY4LTQ1LTQ1LjI2LTQ1cy00NS4yNSwxOS4xOS00NS4yNSw0NSwxNy42OCw0NSw0NS4yNSw0NVMxMDU2LjkzLDMyMS41NiwxMDU2LjkzLDI5NS43OFoiIHN0eWxlPSJmaWxsOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ii8+CiAgPHBhdGggZD0iTTExMjMuNDcsMzA3LjE3VjIxNi4zNmg0NC4zNnY4NC4yMmMwLDI0Ljg4LDEzLjQ5LDM5LDM5LjI2LDM5LDI0LjU4LDAsNDEuMzctMTYuMTgsNDEuMzctMzlWMjE2LjM2aDQ0LjM2VjM3NS4yMUgxMjUwdi0xNWgtLjZjLTEzLjE5LDEyLjU4LTMxLjQ4LDE5LjQ4LTUzLjY1LDE5LjQ4QzExNTAuNDUsMzc5LjcxLDExMjMuNDcsMzUzLDExMjMuNDcsMzA3LjE3WiIgc3R5bGU9ImZpbGw6IHJnYigyNTUsIDI1NSwgMjU1KTsiLz4KICA8cGF0aCBkPSJNMTMyMi43OSwzNzUuMjFWMjE2LjM2aDQxLjY2djE1LjI4aC42YzExLjY5LTEyLDI3LjU3LTE4LjI4LDQ2Ljc1LTE4LjI4YTg5LjU2LDg5LjU2LDAsMCwxLDI2LjA4LDQuMTlsLTkuMjksMzkuODdhNzYuNyw3Ni43LDAsMCwwLTIzLjA4LTMuM2MtMjMuNjgsMC0zOC4zNiwxNS41OS0zOC4zNiw0OC41NnY3Mi41M1oiIHN0eWxlPSJmaWxsOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ii8+CiAgPHBhdGggZD0iTTE0NTMuMTYsMTkwLjI4VjE0NS45MkgxNDk5djQ0LjM2Wm0uOSwxODQuOTNWMjE2LjM2aDQ0LjM2VjM3NS4yMVoiIHN0eWxlPSJmaWxsOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ii8+CiAgPHBhdGggZD0iTTE1MjEuOCwyOTYuMDhjMC00OC44NSwzNi04NC4yMiw4Ni4zMi04NC4yMiw1My4zNSwwLDg2LjMyLDM3Ljc3LDg2LjMyLDg1LjQydjEyLjU5SDE1NjUuNTZjMS41LDIwLjY4LDE4LjI4LDMzLjg3LDQ1LDMzLjg3LDE5Ljc4LDAsMzMuNTctNy43OSw0OC44NS0yMy42OEwxNjg3LDM0Ny42NGMtMTguMjksMjAuMDgtNDIsMzIuMDctNzYuMTMsMzIuMDdDMTU1NS4wNywzNzkuNzEsMTUyMS44LDM0Ni40NCwxNTIxLjgsMjk2LjA4Wm0xMjkuNDgtMTcuMzhjLTIuMS0xOC41OC0xOC41OC0zMC44Ny00Mi4yNi0zMC44Ny0yNCwwLTQwLjQ3LDEyLjI5LTQyLjg2LDMwLjg3WiIgc3R5bGU9ImZpbGw6IHJnYigyNTUsIDI1NSwgMjU1KTsiLz4KICA8cGF0aCBkPSJNMTcxOC4xMSwzNzUuMjFWMjE2LjM2aDQxLjY2djE1LjI4aC42YzExLjY5LTEyLDI3LjU4LTE4LjI4LDQ2Ljc2LTE4LjI4YTg5LjYyLDg5LjYyLDAsMCwxLDI2LjA4LDQuMTlsLTkuMjksMzkuODdhNzYuNzUsNzYuNzUsMCwwLDAtMjMuMDgtMy4zYy0yMy42OCwwLTM4LjM3LDE1LjU5LTM4LjM3LDQ4LjU2djcyLjUzWiIgc3R5bGU9ImZpbGw6IHJnYigyNTUsIDI1NSwgMjU1KTsiLz4KPC9zdmc+"}}]);