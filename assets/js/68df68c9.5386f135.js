"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[721],{3905:(e,n,r)=>{r.d(n,{Zo:()=>l,kt:()=>g});var t=r(7294);function o(e,n,r){return n in e?Object.defineProperty(e,n,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[n]=r,e}function a(e,n){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var t=Object.getOwnPropertySymbols(e);n&&(t=t.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),r.push.apply(r,t)}return r}function s(e){for(var n=1;n<arguments.length;n++){var r=null!=arguments[n]?arguments[n]:{};n%2?a(Object(r),!0).forEach((function(n){o(e,n,r[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(r,n))}))}return e}function i(e,n){if(null==e)return{};var r,t,o=function(e,n){if(null==e)return{};var r,t,o={},a=Object.keys(e);for(t=0;t<a.length;t++)r=a[t],n.indexOf(r)>=0||(o[r]=e[r]);return o}(e,n);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(t=0;t<a.length;t++)r=a[t],n.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(o[r]=e[r])}return o}var d=t.createContext({}),c=function(e){var n=t.useContext(d),r=n;return e&&(r="function"==typeof e?e(n):s(s({},n),e)),r},l=function(e){var n=c(e.components);return t.createElement(d.Provider,{value:n},e.children)},p="mdxType",u={inlineCode:"code",wrapper:function(e){var n=e.children;return t.createElement(t.Fragment,{},n)}},f=t.forwardRef((function(e,n){var r=e.components,o=e.mdxType,a=e.originalType,d=e.parentName,l=i(e,["components","mdxType","originalType","parentName"]),p=c(r),f=o,g=p["".concat(d,".").concat(f)]||p[f]||u[f]||a;return r?t.createElement(g,s(s({ref:n},l),{},{components:r})):t.createElement(g,s({ref:n},l))}));function g(e,n){var r=arguments,o=n&&n.mdxType;if("string"==typeof e||o){var a=r.length,s=new Array(a);s[0]=f;var i={};for(var d in n)hasOwnProperty.call(n,d)&&(i[d]=n[d]);i.originalType=e,i[p]="string"==typeof e?e:o,s[1]=i;for(var c=2;c<a;c++)s[c]=r[c];return t.createElement.apply(null,s)}return t.createElement.apply(null,r)}f.displayName="MDXCreateElement"},2045:(e,n,r)=>{r.r(n),r.d(n,{assets:()=>d,contentTitle:()=>s,default:()=>p,frontMatter:()=>a,metadata:()=>i,toc:()=>c});var t=r(7462),o=(r(7294),r(3905));const a={},s=void 0,i={unversionedId:"Message Adapter",id:"Message Adapter",title:"Message Adapter",description:"To serialize and deserialize received and published messages, Courier uses MessageAdapter. With this, you don't need to handle the serialization and deserialization process when publishing and receiving messages from broker",source:"@site/docs/Message Adapter.md",sourceDirName:".",slug:"/Message Adapter",permalink:"/courier-iOS/docs/Message Adapter",draft:!1,editUrl:"https://github.com/gojek/courier-iOS/edit/main/docs/docs/Message Adapter.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Configuring Client",permalink:"/courier-iOS/docs/Configuring Client"},next:{title:"Connection Lifeycle",permalink:"/courier-iOS/docs/Connection Lifeycle"}},d={},c=[{value:"Create your own Message Adapter",id:"create-your-own-message-adapter",level:3}],l={toc:c};function p(e){let{components:n,...r}=e;return(0,o.kt)("wrapper",(0,t.Z)({},l,r,{components:n,mdxType:"MDXLayout"}),(0,o.kt)("p",null,"To serialize and deserialize received and published messages, Courier uses MessageAdapter. With this, you don't need to handle the serialization and deserialization process when publishing and receiving messages from broker "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-swift"},"// Using type inference, the client will use the provided message adapter to deserialize the byte array data into Message model\ncourierClient.messagePublisher(topic: topic)\n        .sink { (message: Message) in\n            // Process decoded message\n        }.store(in: &cancellables)\n")),(0,o.kt)("p",null,"Out of the box, Courier already provides ",(0,o.kt)("inlineCode",{parentName:"p"},"JSONMessageAdapter")," which can be used to decode and encode JSON data to Swift model that conforms to ",(0,o.kt)("inlineCode",{parentName:"p"},"Codable")," protocol."),(0,o.kt)("p",null,"All you need to do is to pass this to ",(0,o.kt)("inlineCode",{parentName:"p"},"MQTTClientConfig/messageAdapters")," parameter, by default it uses ",(0,o.kt)("inlineCode",{parentName:"p"},"JSONMessageAdapter"),". The config accepts multiple type of MessageAdapter as you can see in example below. "),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-swift"},"let courierClient = clientFactory.makeMQTTClient(\n    config: MQTTClientConfig(\n        //...\n        messageAdapters: [\n            JSONMessageAdapter(),\n            ProtobufMessageAdapter()\n        ],\n        //...\n    )\n)\n")),(0,o.kt)("p",null,"If you are using protobuf format, you can also add ",(0,o.kt)("inlineCode",{parentName:"p"},"CourierProtobuf")," dependency to your ",(0,o.kt)("inlineCode",{parentName:"p"},"Podfile")," and pass ",(0,o.kt)("inlineCode",{parentName:"p"},"ProtobufMessageAdapter")),(0,o.kt)("h3",{id:"create-your-own-message-adapter"},"Create your own Message Adapter"),(0,o.kt)("p",null,"You can also provide your own Message Adapter by conforming ",(0,o.kt)("inlineCode",{parentName:"p"},"MessageAdapter")," protocol and implement both ",(0,o.kt)("inlineCode",{parentName:"p"},"fromMessage")," and ",(0,o.kt)("inlineCode",{parentName:"p"},"toMessage")," method. You can take a look on how JSONMessageAdapter implementation below."),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-swift"},"/// A protocol used to decode and encode message using JSON format\npublic struct JSONMessageAdapter: MessageAdapter {\n\n    private let jsonDecoder: JSONDecoder\n    private let jsonEncoder: JSONEncoder\n\n    public init(jsonDecoder: JSONDecoder = JSONDecoder(),\n                jsonEncoder: JSONEncoder = JSONEncoder()) {\n        self.jsonDecoder = jsonDecoder\n        self.jsonEncoder = jsonEncoder\n    }\n    \n    public func fromMessage<T>(_ message: Data) throws -> T {\n        if let decodableType = T.self as? Decodable.Type,\n           let value = try decodableType.init(data: message, jsonDecoder: jsonDecoder) as? T {\n            return value\n        }\n        throw CourierError.decodingError.asNSError\n    }\n    \n    public func toMessage<T>(data: T) throws -> Data {\n        guard !(data is Data) else {\n            throw CourierError.encodingError.asNSError\n        }\n        \n        if let encodable = data as? Encodable {\n            return try encodable.encode(jsonEncoder: jsonEncoder)\n        }\n        throw CourierError.encodingError.asNSError\n    }\n}\n\n\nfileprivate extension Decodable {\n    \n    init(data: Data, jsonDecoder: JSONDecoder) throws {\n        self = try jsonDecoder.decode(Self.self, from: data)\n    }\n}\n\nfileprivate extension Encodable {\n    \n    func encode(jsonEncoder: JSONEncoder) throws -> Data {\n        try jsonEncoder.encode(self)\n    }\n    \n}\n")))}p.isMDXComponent=!0}}]);