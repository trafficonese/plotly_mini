function TraceManager(t,e){this.gd=t,this.origData=JSON.parse(JSON.stringify(t.data)),this.origOpacity=[];for(var n=0;n<this.origData.length;n++)this.origOpacity[n]=0===this.origData[n].opacity?0:this.origData[n].opacity||1;this.groupSelections={},this.highlight=e}function getMatchFunc(t){return t._isNestedKey?findNestedMatches:t._isSimpleKey?findSimpleMatches:findMatches}function findMatches(t,e){var n=[];return t.forEach(function(t,l){(null===t||e.indexOf(t)>=0)&&n.push(l)}),n}function findSimpleMatches(t,e){return t.every(function(t){return null===t||e.indexOf(t)>=0})?[0]:[]}function findNestedMatches(t,e){for(var n=[],l=0;l<t.length;l++){t[l].every(function(t){return null===t||e.indexOf(t)>=0})&&n.push(l)}return n}function isPlainObject(t){return"[object Object]"===Object.prototype.toString.call(t)&&Object.getPrototypeOf(t)===Object.prototype}function subsetArrayAttrs(t,e){var n={};return Object.keys(t).forEach(function(l){var i=t[l];"_"===l.charAt(0)?n[l]=i:"transforms"===l&&Array.isArray(i)?n[l]=i.map(function(t){return subsetArrayAttrs(t,e)}):"colorscale"===l&&Array.isArray(i)?n[l]=i:isPlainObject(i)?n[l]=subsetArrayAttrs(i,e):Array.isArray(i)?n[l]=subsetArray(i,e):n[l]=i}),n}function subsetArray(t,e){for(var n=[],l=0;l<e.length;l++)n.push(t[e[l]]);return n}function removeBrush(t){for(var e=t.querySelectorAll(".select-outline"),n=0;n<e.length;n++)e[n].remove()}function debounce(t,e,n){var l;return function(){var i=this,o=arguments,r=n&&!l;clearTimeout(l),l=setTimeout(function(){l=null,n||t.apply(i,o)},e),r&&t.apply(i,o)}}HTMLWidgets.widget({name:"plotly",type:"output",initialize:function(t,e,n){return{}},resize:function(t,e,n,l){if(l.autosize){e=l.width||e,n=l.height||n;Plotly.relayout(t.id,{width:e,height:n})}},renderValue:function(t,e,n){crosstalk.var("plotlyCrosstalkOpts").set(e.highlight);if("undefined"!=typeof window){window.PLOTLYENV=window.PLOTLYENV||{},window.PLOTLYENV.BASE_URL=e.base_url;e.highlight.persistent||(window.onmousemove=function(t){t||window.event,t.shiftKey?(e.highlight.persistent=!0,e.highlight.persistentShift=!0):(e.highlight.persistent=!1,e.highlight.persistentShift=!1)})}var l=document.getElementById(t.id);if(HTMLWidgets.addPostRenderHandler(function(){for(var t=document.querySelectorAll(".js-plotly-plot .plotly .modebar"),e=0;e<t.length;e++)t[e].style.zIndex=1}),e.config=e.config||{},e.config.cloud||(e.config.modeBarButtonsToRemove=e.config.modeBarButtonsToRemove||[],e.config.modeBarButtonsToRemove.push("sendDataToCloud")),n.plotly){n.width=e.layout.width||n.width,n.height=e.layout.height||n.height,Plotly.purge(l);i=Plotly.react(l,e)}else{var i=Plotly.plot(l,e);n.plotly=!0,n.autosize=e.layout.autosize||!0,n.width=e.layout.width,n.height=e.layout.height}function o(e){return void 0!==e&&e.hasOwnProperty("points")?e.points.map(function(e){var n={curveNumber:e.curveNumber,pointNumber:e.pointNumber,x:e.x,y:e.y};e.hasOwnProperty("z")&&(n.z=e.z);var l=document.getElementById(t.id).data[e.curveNumber];if(l._isSimpleKey){n.key=l.key;i=[]}else var i=["key"];for(var o=0;o<i.length;o++){var r=l[i[o]];Array.isArray(r)&&(n[i[o]]="number"==typeof e.pointNumber?r[e.pointNumber]:r[e.pointNumber[0]][e.pointNumber[1]])}return n}):null}function r(t){for(var e={},n=0;n<t.length;n++){var i=l.data[t[n].curveNumber];if(i.key&&i.set){e[i.set]=e[i.set]||{value:[],_isSimpleKey:i._isSimpleKey};var o="number"==typeof(o=t[n].pointNumber)?o:t[n].pointNumbers,r=i._isSimpleKey?i.key:Array.isArray(o)?o.map(function(t){return i.key[t]}):i.key[o],a=i._isNestedKey?[].concat.apply([],r):r;e[i.set].value=e[i.set].value.concat(a)}}return e}i.then(function(){HTMLWidgets.shinyMode&&Shiny.addCustomMessageHandler("plotly-calls",function(t){var e=document.getElementById(t.id);if(!e)throw new Error("Couldn't find plotly graph with id: "+t.id);if("reconfig"!=t.method){if(!Plotly[t.method])throw new Error("Unknown method "+t.method);var n=[e].concat(t.args);Plotly[t.method].apply(null,n)}else Plotly.react(e,e.data,e.layout,t.args)})}),HTMLWidgets.shinyMode&&(Shiny.onInputChange("shiftselect",!1),Shiny.onInputChange("resetselection",!1),l.on("plotly_relayout",function(t){Shiny.setInputValue(".clientValue-plotly_relayout-"+e.source,JSON.stringify(t))}),l.on("plotly_hover",function(t){Shiny.setInputValue(".clientValue-plotly_hover-"+e.source,JSON.stringify(o(t)))}),l.on("plotly_click",function(t){if(t.event.altKey){var n=l._shiny_plotly_click||{points:[]};if(1==n.points.length){t={points:[].concat(n.points,t.points),event:t.event};Shiny.setInputValue(".clientValue-plotly_alt_click-"+e.source,JSON.stringify(o(t)))}l._shiny_plotly_click=t}else if(e.highlight.persistentShift){var i=l._shiny_plotly_click||{points:[]};t={points:[].concat(i.points,t.points),event:t.event};Shiny.setInputValue(".clientValue-plotly_click_persist_on_shift-"+e.source,JSON.stringify(o(t))),l._shiny_plotly_click=t}else 1==t.event.buttons&&(Shiny.setInputValue(".clientValue-plotly_click-"+e.source,JSON.stringify(o(t))),l._shiny_plotly_click=t)}),l.on("plotly_restyle",function(t){Shiny.onInputChange(".clientValue-plotly_restyle-"+e.source,JSON.stringify(t))}),l.on("plotly_selected",function(t){if(e.highlight.persistentShift&&Shiny.onInputChange("shiftselect",!0),t){Shiny.onInputChange(".clientValue-plotly_selected-"+e.source,JSON.stringify(o(t)));var n=t.range?t.range:t.lassoPoints;Shiny.onInputChange(".clientValue-plotly_brush-"+e.source,JSON.stringify(n))}}),l.on("plotly_selecting",function(t){if(t){Shiny.onInputChange(".clientValue-plotly_selecting-"+e.source,JSON.stringify(o(t)));var n=t.range?t.range:t.lassoPoints;Shiny.onInputChange(".clientValue-plotly_brushing-"+e.source,JSON.stringify(n))}}),l.on("plotly_unhover",function(n){Shiny.setInputValue(".clientValue-plotly_hover-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_unhover-"+e.source,JSON.stringify(t.id),{priority:"event"})}),l.on("plotly_doubleclick",function(t){l._shiny_plotly_click=void 0,Shiny.onInputChange("resetselection",!0),Shiny.setInputValue(".clientValue-plotly_selected-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_selecting-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_brush-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_brushing-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_click-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_alt_click-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_click_persist_on_shift-"+e.source,null)}),l.on("plotly_deselect",function(t){l._shiny_plotly_click=void 0,Shiny.onInputChange("resetselection",!0),Shiny.setInputValue(".clientValue-plotly_selected-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_selecting-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_brush-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_brushing-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_click-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_alt_click-"+e.source,null),Shiny.setInputValue(".clientValue-plotly_click_persist_on_shift-"+e.source,null)}),l.on("plotly_clickannotation",function(t){Shiny.setInputValue(".clientValue-plotly_clickannotation-"+e.source,JSON.stringify(t.fullAnnotation))}),l.on("plotly_afterplot",function(){Shiny.setInputValue(".clientValue-plotly_afterplot-"+e.source,"afterplot",{priority:"event"})})),e.highlight.color=e.highlight.color||[],Array.isArray(e.highlight.color)||(e.highlight.color=[e.highlight.color]);for(var a=new TraceManager(l,e.highlight),s=[],u=0;u<e.data.length;u++){var h=e.data[u].set;h&&-1===s.indexOf(h)&&s.push(h)}for(var c=0;c<s.length;c++){var y=s[c],p=new crosstalk.SelectionHandle(y);new crosstalk.FilterHandle(y).on("change",function(e){removeBrush(t),a.updateFilter(y,e.value)});p.on("change",function(t){"plotly_selected"===e.highlight.on&&e.highlight.persistentShift&&(Array.prototype.diff=function(t){return this.filter(function(e){return t.indexOf(e)<0})},t.value=t.value.diff(t.oldValue));var n=crosstalk.var("plotlySelectionHistory").get()||[],l={receiverID:a.gd.id,plotlySelectionColour:crosstalk.group(y).var("plotlySelectionColour").get()};if(l[y]=t.value,n.length>0)for(var i=JSON.stringify(l),o=0;o<n.length;o++)if(JSON.stringify(n[o])==i)return;e.highlight.persistent?n.push(l):n=[l],crosstalk.var("plotlySelectionHistory").set(n),a.updateSelection(y,t.value)});var g=function(e){if(e){var n=r(e.points);for(var l in n)n.hasOwnProperty(l)&&p.set(n[l].value,{sender:t})}};e.highlight.debounce>0&&(g=debounce(g,e.highlight.debounce)),l.on(e.highlight.on,g),l.on(e.highlight.off,function(e){removeBrush(t),crosstalk.var("plotlySelectionHistory").set(null),p.set(null,{sender:t})})}}}),TraceManager.prototype.updateFilter=function(t,e){if(null==e)this.gd.data=JSON.parse(JSON.stringify(this.origData));else for(var n=[],l=0;l<this.origData.length;l++){var i=this.origData[l];if(i.key&&i.set===t){var o=getMatchFunc(i)(i.key,e);o.length>0&&(i._isSimpleKey||(i=subsetArrayAttrs(i,o)),n.push(i))}}this.gd.data=n,Plotly.redraw(this.gd)},TraceManager.prototype.updateSelection=function(t,e){if(null!==e&&!Array.isArray(e))throw new Error("Invalid keys argument; null or array expected");var n=this.gd.data.length-this.origData.length;if(null===e||!this.highlight.persistent&&n>0){for(var l=[],i=this.origData.length;i<this.gd.data.length;i++)l.push(i);Plotly.deleteTraces(this.gd,l),this.groupSelections[t]=e}else{this.groupSelections[t]=this.groupSelections[t]||[];for(i=0;i<e.length;i++){var o=e[i];this.groupSelections[t].indexOf(o)<0&&this.groupSelections[t].push(o)}}if(null===e)Plotly.restyle(this.gd,{opacity:this.origOpacity});else if(e.length>=1){var r=[],a=crosstalk.group(t).var("plotlySelectionColour").get()||this.highlight.color[0];for(i=0;i<this.origData.length;i++){var s=JSON.parse(JSON.stringify(this.gd.data[i]));if(s.key&&s.set===t)if((g=getMatchFunc(s)(s.key,e)).length>0){s._isSimpleKey||(s=subsetArrayAttrs(s,g));var u=this.gd._fullData[i];$.extend(!0,s,this.highlight.selected),u.marker&&(s.marker=s.marker||{},s.marker.color=a||s.marker.color||u.marker.color),u.line&&(s.line=s.line||{},s.line.color=a||s.line.color||u.line.color),u.textfont&&(s.textfont=s.textfont||{},s.textfont.color=a||s.textfont.color||u.textfont.color),u.fillcolor&&(s.fillcolor=a||s.fillcolor||u.fillcolor),s.name=s.name||e.join("<br />"),s.legendgroup=s.legendgroup||e.join("<br />"),s._originalIndex=i,s._newIndex=this.gd._fullData.length+r.length,r.push(s)}}if(r.length>0){Plotly.addTraces(this.gd,r).then(function(n){for(var l=n._transitionData._frameHash,i=n._transitionData._frames||[],o=0;o<i.length;o++){for(var a=[],u=0;u<r.length;u++){var h=r[u];i[o].traces.indexOf(h._originalIndex)>-1&&(a.push(h._newIndex),i[o].traces.push(h._newIndex))}if(0!==a.length){var c=0,y=i[o].data.length;for(u=0;u<y;u++){var p=i[o].data[u];if(p.key&&p.set===t){var g=getMatchFunc(p)(p.key,e);if(g.length>0){s._isSimpleKey||(p=subsetArrayAttrs(p,g));var f=n._fullData[a[c]];f.marker&&(p.marker=f.marker),f.line&&(p.line=f.line),f.textfont&&(p.textfont=f.textfont),c+=1,i[o].data.push(p)}}}l[i[o].name]=i[o]}}});var h=[],c=[],y=Object.keys(this.groupSelections),p=this.origData.length;for(i=0;i<p;i++){var g,f=this.origOpacity[i]||1;if(f===this.gd._fullData[i].opacity&&1!==this.highlight.opacityDim)(g=findMatches(y,[this.gd.data[i].set])).length&&(h.push(i),c.push(f*this.highlight.opacityDim))}h.length}}};