"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[553],{3905:(e,t,n)=>{n.d(t,{Zo:()=>s,kt:()=>m});var r=n(7294);function o(e,t,n){return t in e?Object.defineProperty(e,t,{value:n,enumerable:!0,configurable:!0,writable:!0}):e[t]=n,e}function i(e,t){var n=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);t&&(r=r.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),n.push.apply(n,r)}return n}function a(e){for(var t=1;t<arguments.length;t++){var n=null!=arguments[t]?arguments[t]:{};t%2?i(Object(n),!0).forEach((function(t){o(e,t,n[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(n)):i(Object(n)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(n,t))}))}return e}function l(e,t){if(null==e)return{};var n,r,o=function(e,t){if(null==e)return{};var n,r,o={},i=Object.keys(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||(o[n]=e[n]);return o}(e,t);if(Object.getOwnPropertySymbols){var i=Object.getOwnPropertySymbols(e);for(r=0;r<i.length;r++)n=i[r],t.indexOf(n)>=0||Object.prototype.propertyIsEnumerable.call(e,n)&&(o[n]=e[n])}return o}var p=r.createContext({}),u=function(e){var t=r.useContext(p),n=t;return e&&(n="function"==typeof e?e(t):a(a({},t),e)),n},s=function(e){var t=u(e.components);return r.createElement(p.Provider,{value:t},e.children)},c={inlineCode:"code",wrapper:function(e){var t=e.children;return r.createElement(r.Fragment,{},t)}},d=r.forwardRef((function(e,t){var n=e.components,o=e.mdxType,i=e.originalType,p=e.parentName,s=l(e,["components","mdxType","originalType","parentName"]),d=u(n),m=o,f=d["".concat(p,".").concat(m)]||d[m]||c[m]||i;return n?r.createElement(f,a(a({ref:t},s),{},{components:n})):r.createElement(f,a({ref:t},s))}));function m(e,t){var n=arguments,o=t&&t.mdxType;if("string"==typeof e||o){var i=n.length,a=new Array(i);a[0]=d;var l={};for(var p in t)hasOwnProperty.call(t,p)&&(l[p]=t[p]);l.originalType=e,l.mdxType="string"==typeof e?e:o,a[1]=l;for(var u=2;u<i;u++)a[u]=n[u];return r.createElement.apply(null,a)}return r.createElement.apply(null,n)}d.displayName="MDXCreateElement"},7784:(e,t,n)=>{n.r(t),n.d(t,{assets:()=>p,contentTitle:()=>a,default:()=>c,frontMatter:()=>i,metadata:()=>l,toc:()=>u});var r=n(7462),o=(n(7294),n(3905));const i={},a=void 0,l={unversionedId:"Installation",id:"Installation",title:"Installation",description:"Courier supports minimum deployment target of iOS 11. Cocoapods is used for dependency management. It is separated into these modules:",source:"@site/docs/Installation.md",sourceDirName:".",slug:"/Installation",permalink:"/courier-iOS/docs/Installation",draft:!1,editUrl:"https://github.com/gojek/courier-iOS/edit/main/docs/docs/Installation.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Introduction",permalink:"/courier-iOS/docs/Introduction"},next:{title:"Sample App",permalink:"/courier-iOS/docs/Sample App"}},p={},u=[],s={toc:u};function c(e){let{components:t,...n}=e;return(0,o.kt)("wrapper",(0,r.Z)({},s,n,{components:t,mdxType:"MDXLayout"}),(0,o.kt)("p",null,"Courier supports minimum deployment target of ",(0,o.kt)("inlineCode",{parentName:"p"},"iOS 11"),". Cocoapods is used for dependency management. It is separated into these modules:"),(0,o.kt)("ul",null,(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"CourierCore"),": Contains public APIs such as protocols and data types for Courier. Other modules have basic dependency on this module. You can use this module if you want to implement the interface in your project without adding Courier implementation in your project."),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"CourierMQTT"),": Contains implementation of ",(0,o.kt)("inlineCode",{parentName:"li"},"CourierClient")," and ",(0,o.kt)("inlineCode",{parentName:"li"},"CourierSession")," using ",(0,o.kt)("inlineCode",{parentName:"li"},"MQTT"),". This module has dependency to ",(0,o.kt)("inlineCode",{parentName:"li"},"MQTTClientGJ"),"(A forked version of open source library ",(0,o.kt)("a",{parentName:"li",href:"https://github.com/novastone-media/MQTT-Client-Framework"},"MQTT-Client-Framework")," with several adjustment and fixes."),(0,o.kt)("li",{parentName:"ul"},(0,o.kt)("inlineCode",{parentName:"li"},"CourierProtobuf"),": Contains implementation of ",(0,o.kt)("inlineCode",{parentName:"li"},"ProtobufMessageAdapter")," using ",(0,o.kt)("inlineCode",{parentName:"li"},"Protofobuf"),". It has dependency to ",(0,o.kt)("inlineCode",{parentName:"li"},"SwiftProtobuf")," library, this is ",(0,o.kt)("inlineCode",{parentName:"li"},"optional")," and can be used if you are using protobuf for data serialization.")),(0,o.kt)("pre",null,(0,o.kt)("code",{parentName:"pre",className:"language-ruby"},"// Podfile\ntarget 'Example-App' do\n  use_frameworks!\n  pod 'CourierCore'\n  pod 'CourierMQTT'\n  pod 'CourierProtobuf' # Optional, if you want to use Protobuf Message Adapter\nend\n")))}c.isMDXComponent=!0}}]);