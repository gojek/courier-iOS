"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[450],{3905:(e,t,r)=>{r.d(t,{Zo:()=>c,kt:()=>h});var n=r(7294);function i(e,t,r){return t in e?Object.defineProperty(e,t,{value:r,enumerable:!0,configurable:!0,writable:!0}):e[t]=r,e}function a(e,t){var r=Object.keys(e);if(Object.getOwnPropertySymbols){var n=Object.getOwnPropertySymbols(e);t&&(n=n.filter((function(t){return Object.getOwnPropertyDescriptor(e,t).enumerable}))),r.push.apply(r,n)}return r}function o(e){for(var t=1;t<arguments.length;t++){var r=null!=arguments[t]?arguments[t]:{};t%2?a(Object(r),!0).forEach((function(t){i(e,t,r[t])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(r)):a(Object(r)).forEach((function(t){Object.defineProperty(e,t,Object.getOwnPropertyDescriptor(r,t))}))}return e}function l(e,t){if(null==e)return{};var r,n,i=function(e,t){if(null==e)return{};var r,n,i={},a=Object.keys(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||(i[r]=e[r]);return i}(e,t);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);for(n=0;n<a.length;n++)r=a[n],t.indexOf(r)>=0||Object.prototype.propertyIsEnumerable.call(e,r)&&(i[r]=e[r])}return i}var s=n.createContext({}),u=function(e){var t=n.useContext(s),r=t;return e&&(r="function"==typeof e?e(t):o(o({},t),e)),r},c=function(e){var t=u(e.components);return n.createElement(s.Provider,{value:t},e.children)},p="mdxType",m={inlineCode:"code",wrapper:function(e){var t=e.children;return n.createElement(n.Fragment,{},t)}},d=n.forwardRef((function(e,t){var r=e.components,i=e.mdxType,a=e.originalType,s=e.parentName,c=l(e,["components","mdxType","originalType","parentName"]),p=u(r),d=i,h=p["".concat(s,".").concat(d)]||p[d]||m[d]||a;return r?n.createElement(h,o(o({ref:t},c),{},{components:r})):n.createElement(h,o({ref:t},c))}));function h(e,t){var r=arguments,i=t&&t.mdxType;if("string"==typeof e||i){var a=r.length,o=new Array(a);o[0]=d;var l={};for(var s in t)hasOwnProperty.call(t,s)&&(l[s]=t[s]);l.originalType=e,l[p]="string"==typeof e?e:i,o[1]=l;for(var u=2;u<a;u++)o[u]=r[u];return n.createElement.apply(null,o)}return n.createElement.apply(null,r)}d.displayName="MDXCreateElement"},4747:(e,t,r)=>{r.r(t),r.d(t,{assets:()=>s,contentTitle:()=>o,default:()=>p,frontMatter:()=>a,metadata:()=>l,toc:()=>u});var n=r(7462),i=(r(7294),r(3905));const a={},o="Courier iOS - Contribution Guidelines",l={unversionedId:"CONTRIBUTION",id:"CONTRIBUTION",title:"Courier iOS - Contribution Guidelines",description:"Courier iOS is an open-source project.",source:"@site/docs/CONTRIBUTION.md",sourceDirName:".",slug:"/CONTRIBUTION",permalink:"/courier-iOS/docs/CONTRIBUTION",draft:!1,editUrl:"https://github.com/gojek/courier-iOS/edit/main/docs/docs/CONTRIBUTION.md",tags:[],version:"current",frontMatter:{},sidebar:"tutorialSidebar",previous:{title:"Event Handling",permalink:"/courier-iOS/docs/Event Handling"},next:{title:"LICENSE",permalink:"/courier-iOS/docs/LICENSE"}},s={},u=[{value:"Issue Reporting",id:"issue-reporting",level:2},{value:"Pull Requests",id:"pull-requests",level:2}],c={toc:u};function p(e){let{components:t,...r}=e;return(0,i.kt)("wrapper",(0,n.Z)({},c,r,{components:t,mdxType:"MDXLayout"}),(0,i.kt)("h1",{id:"courier-ios---contribution-guidelines"},"Courier iOS - Contribution Guidelines"),(0,i.kt)("p",null,(0,i.kt)("a",{parentName:"p",href:"https://github.com/gojekfarm/courier-iOS"},"Courier iOS")," is an open-source project.\nIt is licensed using the ",(0,i.kt)("a",{parentName:"p",href:"https://opensource.org/licenses/MIT"},"MIT License"),".\nWe appreciate pull requests; here are our guidelines:"),(0,i.kt)("ol",null,(0,i.kt)("li",{parentName:"ol"},(0,i.kt)("p",{parentName:"li"},(0,i.kt)("a",{parentName:"p",href:"https://github.com/gojekfarm/courier-iOS/issues"},"File an issue"),"\n(if there isn't one already). If your patch\nis going to be large it might be a good idea to get the\ndiscussion started early.  We are happy to discuss it in a\nnew issue beforehand, and you can always email\n",(0,i.kt)("a",{parentName:"p",href:"mailto:foss+tech@go-jek.com"},"foss+tech@go-jek.com")," about future work.")),(0,i.kt)("li",{parentName:"ol"},(0,i.kt)("p",{parentName:"li"},"Please follow ",(0,i.kt)("a",{parentName:"p",href:"https://google.github.io/swift/"},"Swift Coding Conventions"),".")),(0,i.kt)("li",{parentName:"ol"},(0,i.kt)("p",{parentName:"li"},"We ask that you squash all the commits together before\npushing and that your commit message references the bug."))),(0,i.kt)("h2",{id:"issue-reporting"},"Issue Reporting"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Check that the issue has not already been reported."),(0,i.kt)("li",{parentName:"ul"},"Be clear, concise and precise in your description of the problem."),(0,i.kt)("li",{parentName:"ul"},"Open an issue with a descriptive title and a summary in grammatically correct,\ncomplete sentences."),(0,i.kt)("li",{parentName:"ul"},"Include any relevant code to the issue summary.")),(0,i.kt)("h2",{id:"pull-requests"},"Pull Requests"),(0,i.kt)("ul",null,(0,i.kt)("li",{parentName:"ul"},"Please read this ",(0,i.kt)("a",{parentName:"li",href:"http://gun.io/blog/how-to-github-fork-branch-and-pull-request"},"how to GitHub")," blog post."),(0,i.kt)("li",{parentName:"ul"},"Use a topic branch to easily amend a pull request later, if necessary."),(0,i.kt)("li",{parentName:"ul"},"Write ",(0,i.kt)("a",{parentName:"li",href:"http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html"},"good commit messages"),"."),(0,i.kt)("li",{parentName:"ul"},"Use the same coding conventions as the rest of the project."),(0,i.kt)("li",{parentName:"ul"},"Open a ",(0,i.kt)("a",{parentName:"li",href:"https://help.github.com/articles/using-pull-requests"},"pull request")," that relates to ",(0,i.kt)("em",{parentName:"li"},"only")," one subject with a clear title\nand description in grammatically correct, complete sentences.")),(0,i.kt)("p",null,"Much Thanks! \u2764\u2764\u2764"),(0,i.kt)("p",null,"GO-JEK Tech"))}p.isMDXComponent=!0}}]);