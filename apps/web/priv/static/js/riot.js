/* Riot v3.5.0, @license MIT */
!function(t,e){"object"==typeof exports&&"undefined"!=typeof module?e(exports):"function"==typeof define&&define.amd?define(["exports"],e):e(t.riot=t.riot||{})}(this,function(t){"use strict";function e(t){return Wt.test(t)}function n(t){return typeof t===Ht}function r(t){return t&&typeof t===It}function i(t){return typeof t===Pt}function o(t){return typeof t===Rt}function a(t){return i(t)||null===t||""===t}function s(t){return Array.isArray(t)||t instanceof Array}function u(t,e){var n=Object.getOwnPropertyDescriptor(t,e);return i(t[e])||n&&n.writable}function l(t){return Ft.test(t)}function c(t,e){return Array.prototype.slice.call((e||document).querySelectorAll(t))}function p(t,e){return(e||document).querySelector(t)}function f(){return document.createDocumentFragment()}function h(){return document.createTextNode("")}function d(t){return!!t.ownerSVGElement}function g(t){return"svg"===t?document.createElementNS(Vt,t):document.createElement(t)}function m(t,e){if(i(t.innerHTML)){var n=(new DOMParser).parseFromString(e,"application/xml"),r=t.ownerDocument.importNode(n.documentElement,!0);t.appendChild(r)}else t.innerHTML=e}function v(t,e){t.style.display=e?"":"none",t.hidden=!e}function y(t,e){t.removeAttribute(e)}function _(t){return Object.keys(t).reduce(function(e,n){return e+" "+n+": "+t[n]+";"},"")}function b(t,e){return t.getAttribute(e)}function x(t,e,n){var r=Ut.exec(e);r&&r[1]?t.setAttributeNS($t,r[1],n):t.setAttribute(e,n)}function w(t,e,n){t.insertBefore(e,n.parentNode&&n)}function N(t,e){if(t)for(var n;n=Dt.exec(t);)e(n[1].toLowerCase(),n[2]||n[3]||n[4])}function O(t,e,n){if(t){var r,i=e(t,n);if(!1===i)return;for(t=t.firstChild;t;)r=t.nextSibling,O(t,e,i),t=r}}function C(t,e){for(var n=t?t.length:0,r=0;r<n;++r)e(t[r],r);return t}function j(t,e){return-1!==t.indexOf(e)}function E(t){return t.replace(/-(\w)/g,function(t,e){return e.toUpperCase()})}function T(t,e){return t.slice(0,e.length)===e}function L(t,e,n,r){return Object.defineProperty(t,e,A({value:n,enumerable:!1,writable:!1,configurable:!0},r)),t}function A(t){for(var e,n=arguments,r=1;r<n.length;++r)if(e=n[r])for(var i in e)u(t,i)&&(t[i]=e[i]);return t}function M(t,e,n){var r=this.__.parent,i=this.__.item;if(!i)for(;r&&!i;)i=r.__.item,r=r.__.parent;if(u(n,"currentTarget")&&(n.currentTarget=t),u(n,"target")&&(n.target=n.srcElement),u(n,"which")&&(n.which=n.charCode||n.keyCode),n.item=i,e.call(this,n),!n.preventUpdate){var o=lt(this);o.isMounted&&o.update()}}function S(t,e,n,r){var i,o=M.bind(r,n,e);n[t]=null,i=t.replace(zt,""),j(r.__.listeners,n)||r.__.listeners.push(n),n[kt]||(n[kt]={}),n[kt][t]&&n.removeEventListener(i,n[kt][t]),n[kt][t]=o,n.addEventListener(i,o,!1)}function k(t,e,n){var r,i,a,s;if(t.tag&&t.tagName===n)return void t.tag.update();i="VIRTUAL"===t.dom.tagName,t.tag&&(i&&(a=t.tag.__.head,s=h(),a.parentNode.insertBefore(s,a)),t.tag.unmount(!0)),o(n)&&(t.impl=Nt[n],r={root:t.dom,parent:e,hasImpl:!0,tagName:n},t.tag=ut(t.impl,r,t.dom.innerHTML,e),C(t.attrs,function(e){return x(t.tag.root,e.name,e.value)}),t.tagName=n,t.tag.mount(),i&&mt(t.tag,s||t.tag.root),e.__.onUnmount=function(){var e=t.tag.opts.dataIs,n=t.tag.parent.tags,r=t.tag.__.parent.tags;dt(n,e,t.tag),dt(r,e,t.tag),t.tag.unmount()})}function R(t){return t?(t=t.replace(Ct,""),Kt[t]&&(t=Kt[t]),t):null}function I(t){if(!this.root||!b(this.root,"virtualized")){var e,i,o,s=t.dom,u=R(t.attr),l=j([Mt,St],u),c=t.root&&"VIRTUAL"===t.root.tagName,p=s&&(t.parent||s.parentNode),f="style"===u,h="class"===u;if(t._riot_id)return void(t.isMounted?t.update():(t.mount(),c&&mt(t,t.root)));if(t.update)return t.update();if(o=ee(t.expr,l?A({},Object.create(this.parent),this):this),e=!a(o),(i=r(o))&&(i=!h&&!f,h?o=ee(JSON.stringify(o),this):f&&(o=_(o))),!t.attr||t.isAttrRemoved&&e&&!1!==o||(y(s,t.attr),t.isAttrRemoved=!0),t.bool&&(o=!!o&&u),t.isRtag)return k(t,this,o);if((!t.wasParsedOnce||t.value!==o)&&(t.value=o,t.wasParsedOnce=!0,!i||l)){if(a(o)&&(o=""),!u)return o+="",void(p&&(t.parent=p,"TEXTAREA"===p.tagName?(p.value=o,qt||(s.nodeValue=o)):s.nodeValue=o));n(o)?S(u,o,s,this):l?v(s,u===St?!o:o):(t.bool&&(s[u]=o),"value"===u&&s.value!==o&&(s.value=o),e&&!1!==o&&x(s,u,o),f&&s.hidden&&v(s,!1))}}}function P(t){C(t,I.bind(this))}function H(t,e,n,r){var i=r?Object.create(r):{};return i[t.key]=e,t.pos&&(i[t.pos]=n),i}function $(t,e){for(var n=e.length,r=t.length;n>r;)n--,V.apply(e[n],[e,n])}function V(t,e){t.splice(e,1),this.unmount(),dt(this.parent,this,this.__.tagName,!0)}function U(t){var e=this;C(Object.keys(this.tags),function(n){st.apply(e.tags[n],[n,t])})}function B(t,e,n){n?yt.apply(this,[t,e]):w(t,this.root,e.root)}function z(t,e,n){n?vt.apply(this,[t,e]):w(t,this.root,e.root)}function F(t,e){e?vt.call(this,t):t.appendChild(this.root)}function D(t,e,n){y(t,Lt);var r,i=typeof b(t,At)!==Rt||y(t,At),a=pt(t),u=Nt[a],l=t.parentNode,c=h(),p=ot(t),d=b(t,Tt),g=[],m=[],v=!Nt[a],_="VIRTUAL"===t.tagName;return n=ee.loopKeys(n),n.isLoop=!0,d&&y(t,Tt),l.insertBefore(c,t),l.removeChild(t),n.update=function(){n.value=ee(n.val,e);var l=f(),h=n.value,y=!s(h)&&!o(h),b=c.parentNode;b&&(y?h=(r=h||!1)?Object.keys(h).map(function(t){return H(n,h[t],t)}):[]:r=!1,d&&(h=h.filter(function(t,r){return n.key&&!y?!!ee(d,H(n,t,r,e)):!!ee(d,A(Object.create(e),t))})),C(h,function(o,s){var c=i&&typeof o===It&&!r,f=m.indexOf(o),d=-1===f,y=!d&&c?f:s,x=g[y],w=s>=m.length,N=c&&d||!c&&!x;o=!r&&n.key?H(n,o,s):o,N?((x=new it(u,{parent:e,isLoop:!0,isAnonymous:v,tagName:a,root:t.cloneNode(v),item:o,index:s},t.innerHTML)).mount(),w?F.apply(x,[l||b,_]):z.apply(x,[b,g[s],_]),w||m.splice(s,0,o),g.splice(s,0,x),p&&ht(e.tags,a,x,!0)):y!==s&&c&&(j(h,m[y])&&(B.apply(x,[b,g[s],_]),g.splice(s,0,g.splice(y,1)[0]),m.splice(s,0,m.splice(y,1)[0])),n.pos&&(x[n.pos]=s),!p&&x.tags&&U.call(x,s)),x.__.item=o,x.__.index=s,x.__.parent=e,N||x.update(o)}),$(h,g),m=h.slice(),b.insertBefore(l,c))},n.unmount=function(){C(g,function(t){t.unmount()})},n}function K(t,e,n){var r=this;O(t,function(e,i){var o,a,s,u=e.nodeType,l=i.parent;if(!n&&e===t)return{parent:l};if(3===u&&"STYLE"!==e.parentNode.tagName&&ee.hasExpr(e.nodeValue)&&l.children.push({dom:e,expr:e.nodeValue}),1!==u)return i;var c="VIRTUAL"===e.tagName;if(o=b(e,Lt))return c&&x(e,"loopVirtual",!0),l.children.push(D(e,r,o)),!1;if(o=b(e,Tt))return l.children.push(Object.create(oe).init(e,r,o)),!1;if((a=b(e,Et))&&ee.hasExpr(a))return l.children.push({isRtag:!0,expr:a,dom:e,attrs:[].slice.call(e.attributes)}),!1;if(s=ot(e),c&&(b(e,"virtualized")&&e.parentElement.removeChild(e),s||b(e,"virtualized")||b(e,"loopVirtual")||(s={tmpl:e.outerHTML})),s&&(e!==t||n)){if(!c||b(e,Et)){var p={root:e,parent:r,hasImpl:!0};return l.children.push(ut(s,p,e.innerHTML,r)),!1}x(e,"virtualized",!0);var f=new it({tmpl:e.outerHTML},{root:e,parent:r},e.innerHTML);l.children.push(f)}return W.apply(r,[e,e.attributes,function(t,e){e&&l.children.push(e)}]),{parent:l}},{parent:{children:e}})}function W(t,n,r){var i=this;C(n,function(n){if(!n)return!1;var o,a=n.name,s=e(a);j(jt,a)?o=Object.create(ae).init(t,i,a,n.value):ee.hasExpr(n.value)&&(o={dom:t,expr:n.value,attr:a,bool:s}),r(n,o)})}function q(t,e,n){var r="o"===n[0],i=r?"select>":"table>";if(t.innerHTML="<"+i+e.trim()+"</"+i,i=t.firstChild,r)i.selectedIndex=-1;else{var o=pe[n];o&&1===i.childElementCount&&(i=p(o,i))}return i}function Z(t,e){if(!se.test(t))return t;var n={};return e=e&&e.replace(le,function(t,e,r){return n[e]=n[e]||r,""}).trim(),t.replace(ce,function(t,e,r){return n[e]||r||""}).replace(ue,function(t,n){return e||n||""})}function G(t,e,n){var r=t&&t.match(/^\s*<([-\w]+)/),i=r&&r[1].toLowerCase(),o=g(n?de:he);return t=Z(t,e),fe.test(i)?o=q(o,t,i):m(o,t),o}function Q(t,e){var n=this,r=n.name,i=n.tmpl,o=n.css,a=n.attrs,s=n.onCreate;return Nt[r]||(J(r,i,o,a,s),Nt[r].class=this.constructor),gt(t,r,e,this),o&&Yt.inject(),this}function J(t,e,r,i,o){return n(i)&&(o=i,/^[\w\-]+\s?=/.test(r)?(i=r,r=""):i=""),r&&(n(r)?o=r:Yt.add(r)),t=t.toLowerCase(),Nt[t]={name:t,tmpl:e,attrs:i,fn:o},t}function X(t,e,n,r,i){return n&&Yt.add(n,t),Nt[t]={name:t,tmpl:e,attrs:r,fn:i},t}function Y(t,e,n){function i(t){if(t.tagName){var r,o=b(t,Et);e&&o!==e&&(o=e,x(t,Et,e)),(r=gt(t,o||t.tagName.toLowerCase(),n))&&u.push(r)}else t.length&&C(t,i)}var a,s,u=[];if(Yt.inject(),r(e)&&(n=e,e=0),a=o(t)?(t="*"===t?s=_t():t+_t(t.split(/, */)))?c(t):[]:t,"*"===e){if(e=s||_t(),a.tagName)a=c(e,a);else{var l=[];C(a,function(t){return l.push(c(e,t))}),a=l}e=0}return i(a),u}function tt(t,e,o){if(r(t))return void tt("__"+ve+++"__",t,!0);var a=o?me:ge;if(!e){if(i(a[t]))throw new Error("Unregistered mixin: "+t);return a[t]}a[t]=n(e)?A(e.prototype,a[t]||{})&&e:A(a[t]||{},e)}function et(){return C(wt,function(t){return t.update()})}function nt(t){Nt[t]=null}function rt(t,e,n,r,i){if(!t||!n){var o=!n&&t?this:e||this;C(i,function(t){t.expr&&P.call(o,[t.expr]),r[E(t.name).replace(Ct,"")]=t.expr?t.expr.value:t.value})}}function it(t,e,r){void 0===t&&(t={}),void 0===e&&(e={});var i,a=A({},e.opts),s=e.parent,u=e.isLoop,l=!!e.isAnonymous,c=ie.skipAnonymousTags&&l,p=ft(e.item),f=e.index,h=[],g=[],v=[],_=e.root,b=e.tagName||pt(_),w="virtual"===b,O=!w&&!t.tmpl,E=[];c||ne(this),t.name&&_._tag&&_._tag.unmount(!0),this.isMounted=!1,L(this,"__",{isAnonymous:l,instAttrs:h,innerHTML:r,tagName:b,index:f,isLoop:u,isInline:O,listeners:[],virts:[],tail:null,head:null,parent:null,item:null}),L(this,"_riot_id",++_e),L(this,"root",_),A(this,{opts:a},p),L(this,"parent",s||null),L(this,"tags",{}),L(this,"refs",{}),O||u&&l?i=_:(w||(_.innerHTML=""),i=G(t.tmpl,r,d(_))),L(this,"update",function(t){var e={},r=this.isMounted&&!c;return t=ft(t),A(this,t),rt.apply(this,[u,s,l,e,h]),r&&this.isMounted&&n(this.shouldUpdate)&&!this.shouldUpdate(t,e)?this:(u&&l&&at.apply(this,[this.parent,E]),A(a,e),r&&this.trigger("update",t),P.call(this,v),r&&this.trigger("updated"),this)}.bind(this)),L(this,"mixin",function(){var t=this;return C(arguments,function(e){var r,i,a=[],s=["init","__proto__"];e=o(e)?tt(e):e,r=n(e)?new e:e;var u=Object.getPrototypeOf(r);do{a=a.concat(Object.getOwnPropertyNames(i||r))}while(i=Object.getPrototypeOf(i||r));C(a,function(e){if(!j(s,e)){var i=Object.getOwnPropertyDescriptor(r,e)||Object.getOwnPropertyDescriptor(u,e),o=i&&(i.get||i.set);!t.hasOwnProperty(e)&&o?Object.defineProperty(t,e,i):t[e]=n(r[e])?r[e].bind(t):r[e]}}),r.init&&r.init.bind(t)()}),this}.bind(this)),L(this,"mount",function(){var e=this;_._tag=this,W.apply(s,[_,_.attributes,function(t,n){!l&&ae.isPrototypeOf(n)&&(n.tag=e),t.expr=n,h.push(t)}]),g=[],N(t.attrs,function(t,e){g.push({name:t,value:e})}),W.apply(this,[_,g,function(t,e){e?v.push(e):x(_,t.name,t.value)}]),rt.apply(this,[u,s,l,a,h]);var n=tt(Ot);if(n&&!c)for(var r in n)n.hasOwnProperty(r)&&e.mixin(n[r]);if(t.fn&&t.fn.call(this,a),c||this.trigger("before-mount"),K.apply(this,[i,v,l]),this.update(p),!l&&!O)for(;i.firstChild;)_.appendChild(i.firstChild);if(L(this,"root",_),L(this,"isMounted",!0),!c){if(this.parent){var o=lt(this.parent);o.one(o.isMounted?"updated":"mount",function(){e.trigger("mount")})}else this.trigger("mount");return this}}.bind(this)),L(this,"unmount",function(e){var n,r=this,i=this.root,o=i.parentNode,a=wt.indexOf(this);return c||this.trigger("before-unmount"),N(t.attrs,function(t){T(t,Ct)&&(t=t.slice(Ct.length)),y(_,t)}),this.__.listeners.forEach(function(t){Object.keys(t[kt]).forEach(function(e){t.removeEventListener(e,t[kt][e])})}),-1!==a&&wt.splice(a,1),(o||w)&&(s?(n=lt(s),w?Object.keys(this.tags).forEach(function(t){dt(n.tags,t,r.tags[t])}):(dt(n.tags,b,this),s!==n&&dt(s.tags,b,this))):m(i,""),o&&!e&&o.removeChild(i)),this.__.virts&&C(this.__.virts,function(t){t.parentNode&&t.parentNode.removeChild(t)}),ct(v),C(h,function(t){return t.expr&&t.expr.unmount&&t.expr.unmount()}),this.__.onUnmount&&this.__.onUnmount(),c||(this.trigger("unmount"),this.off("*")),L(this,"isMounted",!1),delete this.root._tag,this}.bind(this))}function ot(t){return t.tagName&&Nt[b(t,Et)||b(t,Et)||t.tagName.toLowerCase()]}function at(t,e){var n=this;C(Object.keys(t),function(r){var o=!l(r)&&j(e,r);(i(n[r])||o)&&(o||e.push(r),n[r]=t[r])})}function st(t,e){var n,r=this.parent;r&&(s(n=r.tags[t])?n.splice(e,0,n.splice(n.indexOf(this),1)[0]):ht(r.tags,t,this))}function ut(t,e,n,r){var i=new it(t,e,n),o=e.tagName||pt(e.root,!0),a=lt(r);return L(i,"parent",a),i.__.parent=r,ht(a.tags,o,i),a!==r&&ht(r.tags,o,i),e.root.innerHTML="",i}function lt(t){for(var e=t;e.__.isAnonymous&&e.parent;)e=e.parent;return e}function ct(t){C(t,function(t){t instanceof it?t.unmount(!0):t.tagName?t.tag.unmount(!0):t.unmount&&t.unmount()})}function pt(t,e){var n=ot(t),r=!e&&b(t,Et);return r&&!ee.hasExpr(r)?r:n?n.name:t.tagName.toLowerCase()}function ft(t){if(!(t instanceof it||t&&n(t.trigger)))return t;var e={};for(var r in t)Ft.test(r)||(e[r]=t[r]);return e}function ht(t,e,n,r,o){var a=t[e],u=s(a),l=!i(o);if(!a||a!==n)if(!a&&r)t[e]=[n];else if(a)if(u){var c=a.indexOf(n);if(c===o)return;-1!==c&&a.splice(c,1),l?a.splice(o,0,n):a.push(n)}else t[e]=[a,n];else t[e]=n}function dt(t,e,n,r){if(s(t[e])){var i=t[e].indexOf(n);-1!==i&&t[e].splice(i,1),t[e].length?1!==t[e].length||r||(t[e]=t[e][0]):delete t[e]}else delete t[e]}function gt(t,e,n,r){var i=Nt[e],o=Nt[e].class,a=r||(o?Object.create(o.prototype):{}),s=t._innerHTML=t._innerHTML||t.innerHTML,u=A({root:t,opts:n},{parent:n?n.parent:null});return i&&t&&it.apply(a,[i,u,s]),a&&a.mount&&(a.mount(!0),j(wt,a)||wt.push(a)),a}function mt(t,e){var n=f();vt.call(t,n),e.parentNode.replaceChild(n,e)}function vt(t,e){var n,r,i=this,o=h(),a=h(),s=f();for(this.root.insertBefore(o,this.root.firstChild),this.root.appendChild(a),this.__.head=r=o,this.__.tail=a;r;)n=r.nextSibling,s.appendChild(r),i.__.virts.push(r),r=n;e?t.insertBefore(s,e.__.head):t.appendChild(s)}function yt(t,e){for(var n,r=this,i=this.__.head,o=f();i;)if(n=i.nextSibling,o.appendChild(i),(i=n)===r.__.tail){o.appendChild(i),t.insertBefore(o,e.__.head);break}}function _t(t){if(!t){var e=Object.keys(Nt);return e+_t(e)}return t.filter(function(t){return!/[^-\w]/.test(t)}).reduce(function(t,e){var n=e.trim().toLowerCase();return t+",["+Et+'="'+n+'"]'},"")}var bt,xt,wt=[],Nt={},Ot="__global_mixin",Ct="riot-",jt=["ref","data-ref"],Et="data-is",Tt="if",Lt="each",At="no-reorder",Mt="show",St="hide",kt="__riot-events__",Rt="string",It="object",Pt="undefined",Ht="function",$t="http://www.w3.org/1999/xlink",Vt="http://www.w3.org/2000/svg",Ut=/^xlink:(\w+)/,Bt=typeof window===Pt?void 0:window,zt=/^on/,Ft=/^(?:_(?:item|id|parent)|update|root|(?:un)?mount|mixin|is(?:Mounted|Loop)|tags|refs|parent|opts|trigger|o(?:n|ff|ne))$/,Dt=/([-\w]+) ?= ?(?:"([^"]*)|'([^']*)|({[^}]*}))/g,Kt={viewbox:"viewBox"},Wt=/^(?:disabled|checked|readonly|required|allowfullscreen|auto(?:focus|play)|compact|controls|default|formnovalidate|hidden|ismap|itemscope|loop|multiple|muted|no(?:resize|shade|validate|wrap)?|open|reversed|seamless|selected|sortable|truespeed|typemustmatch)$/,qt=0|(Bt&&Bt.document||{}).documentMode,Zt=Object.freeze({isBoolAttr:e,isFunction:n,isObject:r,isUndefined:i,isString:o,isBlank:a,isArray:s,isWritable:u,isReservedName:l}),Gt=Object.freeze({$$:c,$:p,createFrag:f,createDOMPlaceholder:h,isSvg:d,mkEl:g,setInnerHTML:m,toggleVisibility:v,remAttr:y,styleObjectToString:_,getAttr:b,setAttr:x,safeInsert:w,walkAttrs:N,walkNodes:O}),Qt={},Jt=[],Xt=!1;Bt&&(bt=function(){var t=g("style");x(t,"type","text/css");var e=p("style[type=riot]");return e?(e.id&&(t.id=e.id),e.parentNode.replaceChild(t,e)):document.getElementsByTagName("head")[0].appendChild(t),t}(),xt=bt.styleSheet);var Yt={styleNode:bt,add:function(t,e){e?Qt[e]=t:Jt.push(t),Xt=!0},inject:function(){if(Bt&&Xt){Xt=!1;var t=Object.keys(Qt).map(function(t){return Qt[t]}).concat(Jt).join("\n");xt?xt.cssText=t:bt.innerHTML=t}}},te=function(t){function e(t){return t}function n(t,e){return e||(e=y),new RegExp(t.source.replace(/{/g,e[2]).replace(/}/g,e[3]),t.global?l:"")}function r(t){if(t===g)return m;var e=t.split(" ");if(2!==e.length||f.test(t))throw new Error('Unsupported brackets "'+t+'"');return e=e.concat(t.replace(h,"\\").split(" ")),e[4]=n(e[1].length>1?/{[\S\s]*?}/:m[4],e),e[5]=n(t.length>3?/\\({|})/g:m[5],e),e[6]=n(m[6],e),e[7]=RegExp("\\\\("+e[3]+")|([[({])|("+e[3]+")|"+p,l),e[8]=t,e}function i(t){return t instanceof RegExp?s(t):y[t]}function o(t){(t||(t=g))!==y[8]&&(y=r(t),s=t===g?e:n,y[9]=s(m[9])),v=t}function a(t){var e;e=(t=t||{}).brackets,Object.defineProperty(t,"brackets",{set:o,get:function(){return v},enumerable:!0}),u=t,o(e)}var s,u,l="g",c=/"[^"\\]*(?:\\[\S\s][^"\\]*)*"|'[^'\\]*(?:\\[\S\s][^'\\]*)*'|`[^`\\]*(?:\\[\S\s][^`\\]*)*`/g,p=c.source+"|"+/(?:\breturn\s+|(?:[$\w\)\]]|\+\+|--)\s*(\/)(?![*\/]))/.source+"|"+/\/(?=[^*\/])[^[\/\\]*(?:(?:\[(?:\\.|[^\]\\]*)*\]|\\.)[^[\/\\]*)*?(\/)[gim]*/.source,f=RegExp("[\\x00-\\x1F<>a-zA-Z0-9'\",;\\\\]"),h=/(?=[[\]()*+?.^$|])/g,d={"(":RegExp("([()])|"+p,l),"[":RegExp("([[\\]])|"+p,l),"{":RegExp("([{}])|"+p,l)},g="{ }",m=["{","}","{","}",/{[^}]*}/,/\\([{}])/g,/\\({)|{/g,RegExp("\\\\(})|([[({])|(})|"+p,l),g,/^\s*{\^?\s*([$\w]+)(?:\s*,\s*(\S+))?\s+in\s+(\S.*)\s*}/,/(^|[^\\]){=[\S\s]*?}/],v=void 0,y=[];return i.split=function(t,e,n){function r(t){e||o?u.push(t&&t.replace(n[5],"$1")):u.push(t)}n||(n=y);var i,o,a,s,u=[],l=n[6];for(o=a=l.lastIndex=0;i=l.exec(t);){if(s=i.index,o){if(i[2]){l.lastIndex=function(t,e,n){var r,i=d[e];for(i.lastIndex=n,n=1;(r=i.exec(t))&&(!r[1]||(r[1]===e?++n:--n)););return n?t.length:i.lastIndex}(t,i[2],l.lastIndex);continue}if(!i[3])continue}i[1]||(r(t.slice(a,s)),a=l.lastIndex,(l=n[6+(o^=1)]).lastIndex=a)}return t&&a<t.length&&r(t.slice(a)),u},i.hasExpr=function(t){return y[4].test(t)},i.loopKeys=function(t){var e=t.match(y[9]);return e?{key:e[1],pos:e[2],val:y[0]+e[3].trim()+y[1]}:{val:t.trim()}},i.array=function(t){return t?r(t):y},Object.defineProperty(i,"settings",{set:a,get:function(){return u}}),i.settings="undefined"!=typeof riot&&riot.settings||{},i.set=o,i.R_STRINGS=c,i.R_MLCOMMS=/\/\*[^*]*\*+(?:[^*\/][^*]*\*+)*\//g,i.S_QBLOCKS=p,i}(),ee=function(){function t(t,r){return t?(a[t]||(a[t]=n(t))).call(r,e.bind({data:r,tmpl:t})):t}function e(e,n){e.riotData={tagName:n&&n.__&&n.__.tagName,_riot_id:n&&n._riot_id},t.errorHandler?t.errorHandler(e):"undefined"!=typeof console&&"function"==typeof console.error&&(console.error(e.message),console.log("<%s> %s",e.riotData.tagName||"Unknown tag",this.tmpl),console.log(this.data))}function n(t){var e=r(t);return"try{return "!==e.slice(0,11)&&(e="return "+e),new Function("E",e+";")}function r(t){var e,n=[],r=te.split(t.replace(c,'"'),1);if(r.length>2||r[0]){var o,a,s=[];for(o=a=0;o<r.length;++o)(e=r[o])&&(e=1&o?i(e,1,n):'"'+e.replace(/\\/g,"\\\\").replace(/\r\n?|\n/g,"\\n").replace(/"/g,'\\"')+'"')&&(s[a++]=e);e=a<2?s[0]:"["+s.join(",")+'].join("")'}else e=i(r[1],0,n);return n[0]&&(e=e.replace(p,function(t,e){return n[e].replace(/\r/g,"\\r").replace(/\n/g,"\\n")})),e}function i(t,e,n){if(t=t.replace(l,function(t,e){return t.length>2&&!e?s+(n.push(t)-1)+"~":t}).replace(/\s+/g," ").trim().replace(/\ ?([[\({},?\.:])\ ?/g,"$1")){for(var r,i=[],a=0;t&&(r=t.match(u))&&!r.index;){var c,p,h=/,|([[{(])|$/g;for(t=RegExp.rightContext,c=r[2]?n[r[2]].slice(1,-1).trim().replace(/\s+/g," "):r[1];p=(r=h.exec(t))[1];)!function(e,n){var r,i=1,o=f[e];for(o.lastIndex=n.lastIndex;r=o.exec(t);)if(r[0]===e)++i;else if(!--i)break;n.lastIndex=i?t.length:o.lastIndex}(p,h);p=t.slice(0,r.index),t=RegExp.rightContext,i[a++]=o(p,1,c)}t=a?a>1?"["+i.join(",")+'].join(" ").trim()':i[0]:o(t,e)}return t}function o(t,e,n){var r;return t=t.replace(d,function(t,e,n,i,o){return n&&(i=r?0:i+t.length,"this"!==n&&"global"!==n&&"window"!==n?(t=e+'("'+n+h+n,i&&(r="."===(o=o[i])||"("===o||"["===o)):i&&(r=!g.test(o.slice(i)))),t}),r&&(t="try{return "+t+"}catch(e){E(e,this)}"),n?t=(r?"function(){"+t+"}.call(this)":"("+t+")")+'?"'+n+'":""':e&&(t="function(v){"+(r?t.replace("return ","v="):"v=("+t+")")+';return v||v===0?v:""}.call(this)'),t}var a={};t.hasExpr=te.hasExpr,t.loopKeys=te.loopKeys,t.clearCache=function(){a={}},t.errorHandler=null;var s=String.fromCharCode(8279),u=/^(?:(-?[_A-Za-z\xA0-\xFF][-\w\xA0-\xFF]*)|\u2057(\d+)~):/,l=RegExp(te.S_QBLOCKS,"g"),c=/\u2057/g,p=/\u2057(\d+)~/g,f={"(":/[()]/g,"[":/[[\]]/g,"{":/[{}]/g},h='"in this?this:'+("object"!=typeof window?"global":"window")+").",d=/[,{][\$\w]+(?=:)|(^ *|[^$\w\.{])(?!(?:typeof|true|false|null|undefined|in|instanceof|is(?:Finite|NaN)|void|NaN|new|Date|RegExp|Math)(?![$\w]))([$_A-Za-z][$\w]*)/g,g=/^(?=(\.[$\w]+))\1(?:[^.[(]|$)/;return t.version=te.version="v3.0.4",t}(),ne=function(t){t=t||{};var e={},n=Array.prototype.slice;return Object.defineProperties(t,{on:{value:function(n,r){return"function"==typeof r&&(e[n]=e[n]||[]).push(r),t},enumerable:!1,writable:!1,configurable:!1},off:{value:function(n,r){if("*"!=n||r)if(r)for(var i,o=e[n],a=0;i=o&&o[a];++a)i==r&&o.splice(a--,1);else delete e[n];else e={};return t},enumerable:!1,writable:!1,configurable:!1},one:{value:function(e,n){function r(){t.off(e,r),n.apply(t,arguments)}return t.on(e,r)},enumerable:!1,writable:!1,configurable:!1},trigger:{value:function(r){var i,o,a,s=arguments,u=arguments.length-1,l=new Array(u);for(a=0;a<u;a++)l[a]=s[a+1];for(i=n.call(e[r]||[],0),a=0;o=i[a];++a)o.apply(t,l);return e["*"]&&"*"!=r&&t.trigger.apply(t,["*",r].concat(l)),t},enumerable:!1,writable:!1,configurable:!1}}),t},re=Object.freeze({each:C,contains:j,toCamel:E,startsWith:T,defineProperty:L,extend:A}),ie=A(Object.create(te.settings),{skipAnonymousTags:!0}),oe={init:function(t,e,n){y(t,Tt),this.tag=e,this.expr=n,this.stub=document.createTextNode(""),this.pristine=t;var r=t.parentNode;return r.insertBefore(this.stub,t),r.removeChild(t),this},update:function(){this.value=ee(this.expr,this.tag),this.value&&!this.current?(this.current=this.pristine.cloneNode(!0),this.stub.parentNode.insertBefore(this.current,this.stub),this.expressions=[],K.apply(this.tag,[this.current,this.expressions,!0])):!this.value&&this.current&&(ct(this.expressions),this.current._tag?this.current._tag.unmount():this.current.parentNode&&this.current.parentNode.removeChild(this.current),this.current=null,this.expressions=[]),this.value&&P.call(this.tag,this.expressions)},unmount:function(){ct(this.expressions||[])}},ae={init:function(t,e,n,r){return this.dom=t,this.attr=n,this.rawValue=r,this.parent=e,this.hasExp=ee.hasExpr(r),this},update:function(){var t=this.value,e=this.parent&&lt(this.parent),n=this.dom.__ref||this.tag||this.dom;this.value=this.hasExp?ee(this.rawValue,this.parent):this.rawValue,!a(t)&&e&&dt(e.refs,t,n),!a(this.value)&&o(this.value)?(e&&ht(e.refs,this.value,n,null,this.parent.__.index),this.value!==t&&x(this.dom,this.attr,this.value)):y(this.dom,this.attr),this.dom.__ref||(this.dom.__ref=n)},unmount:function(){var t=this.tag||this.dom,e=this.parent&&lt(this.parent);!a(this.value)&&e&&dt(e.refs,this.value,t)}},se=/<yield\b/i,ue=/<yield\s*(?:\/>|>([\S\s]*?)<\/yield\s*>|>)/gi,le=/<yield\s+to=['"]([^'">]*)['"]\s*>([\S\s]*?)<\/yield\s*>/gi,ce=/<yield\s+from=['"]?([-\w]+)['"]?\s*(?:\/>|>([\S\s]*?)<\/yield\s*>)/gi,pe={tr:"tbody",th:"tr",td:"tr",col:"colgroup"},fe=qt&&qt<10?/^(?:t(?:body|head|foot|[rhd])|caption|col(?:group)?|opt(?:ion|group))$/:/^(?:t(?:body|head|foot|[rhd])|caption|col(?:group)?)$/,he="div",de="svg",ge={},me=ge[Ot]={},ve=0,ye=Object.freeze({Tag:Q,tag:J,tag2:X,mount:Y,mixin:tt,update:et,unregister:nt,version:"v3.5.0"}),_e=0,be=Object.freeze({getTag:ot,inheritFrom:at,moveChildTag:st,initChildTag:ut,getImmediateCustomParentTag:lt,unmountAll:ct,getTagName:pt,cleanUpData:ft,arrayishAdd:ht,arrayishRemove:dt,mountTo:gt,makeReplaceVirtual:mt,makeVirtual:vt,moveVirtual:yt,selectTags:_t}),xe=ie,we={tmpl:ee,brackets:te,styleManager:Yt,vdom:wt,styleNode:Yt.styleNode,dom:Gt,check:Zt,misc:re,tags:be},Ne=Q,Oe=J,Ce=X,je=Y,Ee=tt,Te=et,Le=nt,Ae=ne,Me=A({},ye,{observable:ne,settings:xe,util:we});t.settings=xe,t.util=we,t.Tag=Ne,t.tag=Oe,t.tag2=Ce,t.mount=je,t.mixin=Ee,t.update=Te,t.unregister=Le,t.version="WIP",t.observable=Ae,t.default=Me,Object.defineProperty(t,"__esModule",{value:!0})});
