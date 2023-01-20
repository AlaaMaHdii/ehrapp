<%--
  Created by IntelliJ IDEA.
  User: Alaa Mahdi
  Date: 19-01-2023
  Time: 21:05
  To change this template use File | Settings | File Templates.
--%>
/*! DataTables Editor v2.0.4
*
* ©2012-2021 SpryMedia Ltd, all rights reserved.
* License: editor.datatables.net/license
*/(function(factory){if(typeof define==='function'&&define.amd){define(['jquery','datatables.net'],function($){return factory($,window,document);});}
else if(typeof exports==='object'){module.exports=function(root,$){if(!root){root=window;}
if(!$||!$.fn.dataTable){$=require('datatables.net')(root,$).$;}
return factory($,root,root.document);};}
else{factory(jQuery,window,document);}}(function($,window,document,undefined){'use strict';var DataTable=$.fn.dataTable;if(!DataTable||!DataTable.versionCheck||!DataTable.versionCheck('1.10.20')){throw new Error('Editor requires DataTables 1.10.20 or newer');}
var formOptions={onReturn:'submit',onBlur:'close',onBackground:'blur',onComplete:'close',onEsc:'close',onFieldError:'focus',submit:'all',submitTrigger:null,submitHtml:'▶',focus:0,buttons:true,title:true,message:true,drawType:false,nest:false,scope:'row'};var defaults$1={"table":null,"fields":[],"display":'lightbox',"ajax":null,"idSrc":'DT_RowId',"events":{},"i18n":{"close":"Close","create":{"button":"New","title":"Create new entry","submit":"Create"},"edit":{"button":"Edit","title":"Edit entry","submit":"Update"},"remove":{"button":"Delete","title":"Delete","submit":"Delete","confirm":{"_":"Are you sure you wish to delete %d rows?","1":"Are you sure you wish to delete 1 row?"}},"error":{"system":"A system error has occurred (<a target=\"_blank\" href=\"//datatables.net/tn/12\">More information</a>)."},multi:{title:"Multiple values",info:"The selected items contain different values for this input. To edit and set all items for this input to the same value, click or tap here, otherwise they will retain their individual values.",restore:"Undo changes",noMulti:"This input can be edited individually, but not part of a group."},datetime:{previous:'Previous',next:'Next',months:['January','February','March','April','May','June','July','August','September','October','November','December'],weekdays:['Sun','Mon','Tue','Wed','Thu','Fri','Sat'],amPm:['am','pm'],hours:'Hour',minutes:'Minute',seconds:'Second',unknown:'-'}},formOptions:{bubble:$.extend({},formOptions,{title:false,message:false,buttons:'_basic',submit:'changed'}),inline:$.extend({},formOptions,{buttons:false,submit:'changed'}),main:$.extend({},formOptions)},actionName:'action'};var settings={actionName:'action',ajax:null,bubbleNodes:[],dataSource:null,opts:null,displayController:null,editFields:{},fields:{},globalError:'',order:[],id:-1,displayed:false,processing:false,modifier:null,action:null,idSrc:null,unique:0,table:null,template:null,mode:null,editOpts:{},closeCb:null,closeIcb:null,formOptions:{bubble:$.extend({},formOptions),inline:$.extend({},formOptions),main:$.extend({},formOptions),},includeFields:[],editData:{},setFocus:null,editCount:0,};var DataTable$5=$.fn.dataTable;var DtInternalApi=DataTable$5.ext.oApi;function objectKeys(o){var out=[];for(var key in o){if(o.hasOwnProperty(key)){out.push(key);}}
return out;}
function el(tag,ctx){if(ctx===undefined){ctx=document;}
return $('*[data-dte-e="'+tag+'"]',ctx);}
function safeDomId(id,prefix){if(prefix===void 0){prefix='#';}
return typeof id==='string'?prefix+id.replace(/\./g,'-'):prefix+id;}
function safeQueryId(id,prefix){if(prefix===void 0){prefix='#';}
return typeof id==='string'?prefix+id.replace(/(:|\.|\[|\]|,)/g,'\\$1'):prefix+id;}
function dataGet(src){return DtInternalApi._fnGetObjectDataFn(src);}
function dataSet(src){return DtInternalApi._fnSetObjectDataFn(src);}
var extend=DtInternalApi._fnExtend;function pluck(a,prop){var out=[];$.each(a,function(idx,el){out.push(el[prop]);});return out;}
function deepCompare(o1,o2){if(typeof o1!=='object'||typeof o2!=='object'){return o1==o2;}
var o1Props=objectKeys(o1);var o2Props=objectKeys(o2);if(o1Props.length!==o2Props.length){return false;}
for(var i=0,ien=o1Props.length;i<ien;i++){var propName=o1Props[i];if(typeof o1[propName]==='object'){if(!deepCompare(o1[propName],o2[propName])){return false;}}
else if(o1[propName]!=o2[propName]){return false;}}
return true;}
var __dtIsSsp=function(dt,editor){return dt.settings()[0].oFeatures.bServerSide&&editor.s.editOpts.drawType!=='none';};var __dtApi=function(table){return table instanceof $.fn.dataTable.Api?table:$(table).DataTable();};var __dtHighlight=function(node){node=$(node);setTimeout(function(){node.addClass('highlight');setTimeout(function(){node.addClass('noHighlight').removeClass('highlight');setTimeout(function(){node.removeClass('noHighlight');},550);},500);},20);};var __dtRowSelector=function(out,dt,identifier,fields,idFn){dt.rows(identifier).indexes().each(function(idx){var row=dt.row(idx);var data=row.data();var idSrc=idFn(data);if(idSrc===undefined){Editor.error('Unable to find row identifier',14);}
out[idSrc]={idSrc:idSrc,data:data,node:row.node(),fields:fields,type:'row'};});};var __dtFieldsFromIdx=function(dt,fields,idx,ignoreUnknown){var col=dt.settings()[0].aoColumns[idx];var dataSrc=col.editField!==undefined?col.editField:col.mData;var resolvedFields={};var run=function(field,dataSrc){if(field.name()===dataSrc){resolvedFields[field.name()]=field;}};$.each(fields,function(name,fieldInst){if(Array.isArray(dataSrc)){for(var i=0;i<dataSrc.length;i++){run(fieldInst,dataSrc[i]);}}
else{run(fieldInst,dataSrc);}});if($.isEmptyObject(resolvedFields)&&!ignoreUnknown){Editor.error('Unable to automatically determine field from source. Please specify the field name.',11);}
return resolvedFields;};var __dtCellSelector=function(out,dt,identifier,allFields,idFn,forceFields){if(forceFields===void 0){forceFields=null;}
var cells=dt.cells(identifier);cells.indexes().each(function(idx){var cell=dt.cell(idx);var row=dt.row(idx.row);var data=row.data();var idSrc=idFn(data);var fields=forceFields||__dtFieldsFromIdx(dt,allFields,idx.column,cells.count()>1);var isNode=(typeof identifier==='object'&&identifier.nodeName)||identifier instanceof $;var prevDisplayFields,prevAttach,prevAttachFields;if(Object.keys(fields).length){if(out[idSrc]){prevAttach=out[idSrc].attach;prevAttachFields=out[idSrc].attachFields;prevDisplayFields=out[idSrc].displayFields;}
__dtRowSelector(out,dt,idx.row,allFields,idFn);out[idSrc].attachFields=prevAttachFields||[];out[idSrc].attachFields.push(Object.keys(fields));out[idSrc].attach=prevAttach||[];out[idSrc].attach.push(isNode?$(identifier).get(0):cell.fixedNode?cell.fixedNode():cell.node());out[idSrc].displayFields=prevDisplayFields||{};$.extend(out[idSrc].displayFields,fields);}});};var __dtColumnSelector=function(out,dt,identifier,fields,idFn){dt.cells(null,identifier).indexes().each(function(idx){__dtCellSelector(out,dt,idx,fields,idFn);});};var dataSource$1={id:function(data){var idFn=dataGet(this.s.idSrc);return idFn(data);},fakeRow:function(insertPoint){var dt=__dtApi(this.s.table);var tr=$('<tr class="dte-inlineAdd">');var attachFields=[];var attach=[];var displayFields={};for(var i=0,ien=dt.columns(':visible').count();i<ien;i++){var td=$('<td>').appendTo(tr);var fields=__dtFieldsFromIdx(dt,this.s.fields,i,true);var cell=dt.cell(':eq(0)',i+':visible').node();if(cell){td.addClass(cell.className);}
if(Object.keys(fields).length){attachFields.push(Object.keys(fields));attach.push(td[0]);$.extend(displayFields,fields);}}
var append=function(){var action=insertPoint==='end'?'appendTo':'prependTo';tr[action](dt.table(undefined).body());};this.__dtFakeRow=tr;append();dt.on('draw.dte-createInline',function(){append();});return{0:{attachFields:attachFields,attach:attach,displayFields:displayFields,fields:this.s.fields,type:'row'}};},fakeRowEnd:function(){var dt=__dtApi(this.s.table);dt.off('draw.dte-createInline');this.__dtFakeRow.remove();this.__dtFakeRow=null;},individual:function(identifier,fieldNames){var idFn=dataGet(this.s.idSrc);var dt=__dtApi(this.s.table);var fields=this.s.fields;var out={};var forceFields;if(fieldNames){if(!Array.isArray(fieldNames)){fieldNames=[fieldNames];}
forceFields={};$.each(fieldNames,function(i,name){forceFields[name]=fields[name];});}
__dtCellSelector(out,dt,identifier,fields,idFn,forceFields);return out;},fields:function(identifier){var idFn=dataGet(this.s.idSrc);var dt=__dtApi(this.s.table);var fields=this.s.fields;var out={};if($.isPlainObject(identifier)&&(identifier.rows!==undefined||identifier.columns!==undefined||identifier.cells!==undefined)){if(identifier.rows!==undefined){__dtRowSelector(out,dt,identifier.rows,fields,idFn);}
if(identifier.columns!==undefined){__dtColumnSelector(out,dt,identifier.columns,fields,idFn);}
if(identifier.cells!==undefined){__dtCellSelector(out,dt,identifier.cells,fields,idFn);}}
else{__dtRowSelector(out,dt,identifier,fields,idFn);}
return out;},create:function(fields,data){var dt=__dtApi(this.s.table);if(!__dtIsSsp(dt,this)){var row=dt.row.add(data);__dtHighlight(row.node());}},edit:function(identifier,fields,data,store){var that=this;var dt=__dtApi(this.s.table);if(!__dtIsSsp(dt,this)||this.s.editOpts.drawType==='none'){var rowId=dataSource$1.id.call(this,data);var row;try{row=dt.row(safeQueryId(rowId));}
catch(e){row=dt;}
if(!row.any()){row=dt.row(function(rowIdx,rowData,rowNode){return rowId==dataSource$1.id.call(that,rowData);});}
if(row.any()){var toSave=extend({},row.data(),true);toSave=extend(toSave,data,true);row.data(toSave);var idx=$.inArray(rowId,store.rowIds);store.rowIds.splice(idx,1);}
else{row=dt.row.add(data);}
__dtHighlight(row.node());}},refresh:function(){var dt=__dtApi(this.s.table);dt.ajax.reload(null,false);},remove:function(identifier,fields,store){var that=this;var dt=__dtApi(this.s.table);var cancelled=store.cancelled;if(cancelled.length===0){dt.rows(identifier).remove();}
else{var indexes=[];dt.rows(identifier).every(function(){var id=dataSource$1.id.call(that,this.data());if($.inArray(id,cancelled)===-1){indexes.push(this.index());}});dt.rows(indexes).remove();}},prep:function(action,identifier,submit,json,store){var _this=this;if(action==='create'){store.rowIds=$.map(json.data,function(row){return dataSource$1.id.call(_this,row);});}
if(action==='edit'){var cancelled=json.cancelled||[];store.rowIds=$.map(submit.data,function(val,key){return!$.isEmptyObject(submit.data[key])&&$.inArray(key,cancelled)===-1?key:undefined;});}
else if(action==='remove'){store.cancelled=json.cancelled||[];}},commit:function(action,identifier,data,store){var that=this;var dt=__dtApi(this.s.table);var ssp=dt.settings()[0].oFeatures.bServerSide;var ids=store.rowIds;if(!__dtIsSsp(dt,this)&&action==='edit'&&store.rowIds.length){var row=void 0;var compare=function(id){return function(rowIdx,rowData,rowNode){return id==dataSource$1.id.call(that,rowData);};};for(var i=0,ien=ids.length;i<ien;i++){try{row=dt.row(safeQueryId(ids[i]));}
catch(e){row=dt;}
if(!row.any()){row=dt.row(compare(ids[i]));}
if(row.any()&&!ssp){row.remove();}}}
var drawType=this.s.editOpts.drawType;if(drawType!=='none'){var dtAny=dt;if(ssp&&ids&&ids.length){dt.one('draw',function(){for(var i=0,ien=ids.length;i<ien;i++){var row=dt.row(safeQueryId(ids[i]));if(row.any()){__dtHighlight(row.node());}}});}
dt.draw(drawType);if(dtAny.responsive){dtAny.responsive.recalc();}
if(typeof dtAny.searchPanes==='function'&&!ssp){dtAny.searchPanes.rebuildPane(undefined,true);}
if(dtAny.searchBuilder!==undefined&&typeof dtAny.searchBuilder.rebuild==='function'&&!ssp){dtAny.searchBuilder.rebuild(dtAny.searchBuilder.getDetails());}}}};function __html_id(identifier){if(identifier==='keyless'){return $(document);}
var specific=$('[data-editor-id="'+identifier+'"]');if(specific.length===0){specific=typeof identifier==='string'?$(safeQueryId(identifier)):$(identifier);}
if(specific.length===0){throw new Error('Could not find an element with `data-editor-id` or `id` of: '+identifier);}
return specific;}
function __html_el(identifier,name){var context=__html_id(identifier);return $('[data-editor-field="'+name+'"]',context);}
function __html_els(identifier,names){var out=$();for(var i=0,ien=names.length;i<ien;i++){out=out.add(__html_el(identifier,names[i]));}
return out;}
function __html_get(identifier,dataSrc){var el=__html_el(identifier,dataSrc);return el.filter('[data-editor-value]').length?el.attr('data-editor-value'):el.html();}
function __html_set(identifier,fields,data){$.each(fields,function(name,field){var val=field.valFromData(data);if(val!==undefined){var el=__html_el(identifier,field.dataSrc());if(el.filter('[data-editor-value]').length){el.attr('data-editor-value',val);}
else{el.each(function(){while(this.childNodes.length){this.removeChild(this.firstChild);}}).html(val);}}});}
var dataSource={id:function(data){var idFn=dataGet(this.s.idSrc);return idFn(data);},initField:function(cfg){var label=$('[data-editor-label="'+(cfg.data||cfg.name)+'"]');if(!cfg.label&&label.length){cfg.label=label.html();}},individual:function(identifier,fieldNames){var attachEl;if(identifier instanceof $||identifier.nodeName){attachEl=identifier;if(!fieldNames){fieldNames=[$(identifier).attr('data-editor-field')];}
var back=$.fn.addBack?'addBack':'andSelf';identifier=$(identifier).parents('[data-editor-id]')[back]().data('editor-id');}
if(!identifier){identifier='keyless';}
if(fieldNames&&!Array.isArray(fieldNames)){fieldNames=[fieldNames];}
if(!fieldNames||fieldNames.length===0){throw new Error('Cannot automatically determine field name from data source');}
var out=dataSource.fields.call(this,identifier);var fields=this.s.fields;var forceFields={};$.each(fieldNames,function(i,name){forceFields[name]=fields[name];});$.each(out,function(id,set){set.type='cell';set.attachFields=[fieldNames];set.attach=attachEl?$(attachEl):__html_els(identifier,fieldNames).toArray();set.fields=fields;set.displayFields=forceFields;});return out;},fields:function(identifier){var out={};if(Array.isArray(identifier)){for(var i=0,ien=identifier.length;i<ien;i++){var res=dataSource.fields.call(this,identifier[i]);out[identifier[i]]=res[identifier[i]];}
return out;}
var data={};var fields=this.s.fields;if(!identifier){identifier='keyless';}
$.each(fields,function(name,field){var val=__html_get(identifier,field.dataSrc());field.valToData(data,val===null?undefined:val);});out[identifier]={idSrc:identifier,data:data,node:document,fields:fields,type:'row'};return out;},create:function(fields,data){if(data){var id=dataSource.id.call(this,data);try{if(__html_id(id).length){__html_set(id,fields,data);}}
catch(e){}}},edit:function(identifier,fields,data){var id=dataSource.id.call(this,data)||'keyless';__html_set(id,fields,data);},remove:function(identifier,fields){__html_id(identifier).remove();}};var classNames={"wrapper":"DTE","processing":{"indicator":"DTE_Processing_Indicator","active":"processing"},"header":{"wrapper":"DTE_Header","content":"DTE_Header_Content"},"body":{"wrapper":"DTE_Body","content":"DTE_Body_Content"},"footer":{"wrapper":"DTE_Footer","content":"DTE_Footer_Content"},"form":{"wrapper":"DTE_Form","content":"DTE_Form_Content","tag":"","info":"DTE_Form_Info","error":"DTE_Form_Error","buttons":"DTE_Form_Buttons","button":"btn","buttonInternal":"btn"},"field":{"wrapper":"DTE_Field","typePrefix":"DTE_Field_Type_","namePrefix":"DTE_Field_Name_","label":"DTE_Label","input":"DTE_Field_Input","inputControl":"DTE_Field_InputControl","error":"DTE_Field_StateError","msg-label":"DTE_Label_Info","msg-error":"DTE_Field_Error","msg-message":"DTE_Field_Message","msg-info":"DTE_Field_Info","multiValue":"multi-value","multiInfo":"multi-info","multiRestore":"multi-restore","multiNoEdit":"multi-noEdit","disabled":"disabled","processing":"DTE_Processing_Indicator"},"actions":{"create":"DTE_Action_Create","edit":"DTE_Action_Edit","remove":"DTE_Action_Remove"},"inline":{"wrapper":"DTE DTE_Inline","liner":"DTE_Inline_Field","buttons":"DTE_Inline_Buttons"},"bubble":{"wrapper":"DTE DTE_Bubble","liner":"DTE_Bubble_Liner","table":"DTE_Bubble_Table","close":"icon close","pointer":"DTE_Bubble_Triangle","bg":"DTE_Bubble_Background"}};var displayed$2=false;var cssBackgroundOpacity=1;var dom$1={wrapper:$('<div class="DTED DTED_Envelope_Wrapper">'+
'<div class="DTED_Envelope_Shadow"></div>'+
'<div class="DTED_Envelope_Container"></div>'+
'</div>')[0],background:$('<div class="DTED_Envelope_Background"><div></div></div>')[0],close:$('<div class="DTED_Envelope_Close"></div>')[0],content:null};function findAttachRow(editor,attach){var dt=new $.fn.dataTable.Api(editor.s.table);if(attach==='head'){return dt.table(undefined).header();}
else if(editor.s.action==='create'){return dt.table(undefined).header();}
else{return dt.row(editor.s.modifier).node();}}
function heightCalc$1(dte){var header=$('div.DTE_Header',dom$1.wrapper).outerHeight();var footer=$('div.DTE_Footer',dom$1.wrapper).outerHeight();var maxHeight=$(window).height()-(envelope.conf.windowPadding*2)-
header-footer;$('div.DTE_Body_Content',dom$1.wrapper).css('maxHeight',maxHeight);return $(dte.dom.wrapper).outerHeight();}
function hide$2(dte,callback){if(!callback){callback=function(){};}
if(displayed$2){$(dom$1.content).animate({top:-(dom$1.content.offsetHeight+50)},600,function(){$([dom$1.wrapper,dom$1.background]).fadeOut('normal',function(){$(this).detach();callback();});});displayed$2=false;}}
function init$1(){dom$1.content=$('div.DTED_Envelope_Container',dom$1.wrapper)[0];cssBackgroundOpacity=$(dom$1.background).css('opacity');}
function show$2(dte,callback){if(!callback){callback=function(){};}
$('body').append(dom$1.background).append(dom$1.wrapper);dom$1.content.style.height='auto';if(!displayed$2){var style=dom$1.wrapper.style;style.opacity='0';style.display='block';var height=heightCalc$1(dte);var targetRow=findAttachRow(dte,envelope.conf.attach);var width=targetRow.offsetWidth;style.display='none';style.opacity='1';dom$1.wrapper.style.width=width+"px";dom$1.wrapper.style.marginLeft=-(width/2)+"px";dom$1.wrapper.style.top=($(targetRow).offset().top+targetRow.offsetHeight)+"px";dom$1.content.style.top=((-1*height)-20)+"px";dom$1.background.style.opacity='0';dom$1.background.style.display='block';$(dom$1.background).animate({opacity:cssBackgroundOpacity},'normal');$(dom$1.wrapper).fadeIn();$(dom$1.content).animate({top:0},600,callback);}
$(dom$1.close).attr('title',dte.i18n.close).off('click.DTED_Envelope').on('click.DTED_Envelope',function(e){dte.close();});$(dom$1.background).off('click.DTED_Envelope').on('click.DTED_Envelope',function(e){dte.background();});$('div.DTED_Lightbox_Content_Wrapper',dom$1.wrapper).off('click.DTED_Envelope').on('click.DTED_Envelope',function(e){if($(e.target).hasClass('DTED_Envelope_Content_Wrapper')){dte.background();}});$(window).off('resize.DTED_Envelope').on('resize.DTED_Envelope',function(){heightCalc$1(dte);});displayed$2=true;}
var envelope={close:function(dte,callback){hide$2(dte,callback);},destroy:function(dte){hide$2();},init:function(dte){init$1();return envelope;},node:function(dte){return dom$1.wrapper[0];},open:function(dte,append,callback){$(dom$1.content).children().detach();dom$1.content.appendChild(append);dom$1.content.appendChild(dom$1.close);show$2(dte,callback);},conf:{windowPadding:50,attach:'row'}};function isMobile(){return typeof window.orientation!=='undefined'&&window.outerWidth<=576?true:false;}
var displayed$1=false;var ready=false;var scrollTop=0;var dom={wrapper:$('<div class="DTED DTED_Lightbox_Wrapper">'+
'<div class="DTED_Lightbox_Container">'+
'<div class="DTED_Lightbox_Content_Wrapper">'+
'<div class="DTED_Lightbox_Content">'+
'</div>'+
'</div>'+
'</div>'+
'</div>'),background:$('<div class="DTED_Lightbox_Background"><div></div></div>'),close:$('<div class="DTED_Lightbox_Close"></div>'),content:null};function heightCalc(){var headerFooter=$('div.DTE_Header',dom.wrapper).outerHeight()+
$('div.DTE_Footer',dom.wrapper).outerHeight();if(isMobile()){$('div.DTE_Body_Content',dom.wrapper).css('maxHeight','calc(100vh - '+headerFooter+'px)');}
else{var maxHeight=$(window).height()-(self.conf.windowPadding*2)-headerFooter;$('div.DTE_Body_Content',dom.wrapper).css('maxHeight',maxHeight);}}
function hide$1(dte,callback){if(!callback){callback=function(){};}
$('body').scrollTop(scrollTop);dte._animate(dom.wrapper,{opacity:0,top:self.conf.offsetAni},function(){$(this).detach();callback();});dte._animate(dom.background,{opacity:0},function(){$(this).detach();});displayed$1=false;$(window).off('resize.DTED_Lightbox');}
function init(){if(ready){return;}
dom.content=$('div.DTED_Lightbox_Content',dom.wrapper);dom.wrapper.css('opacity',0);dom.background.css('opacity',0);ready=true;}
function show$1(dte,callback){if(isMobile()){$('body').addClass('DTED_Lightbox_Mobile');}
$('body').append(dom.background).append(dom.wrapper);heightCalc();if(!displayed$1){displayed$1=true;dom.content.css('height','auto');dom.wrapper.css({top:-self.conf.offsetAni});dte._animate(dom.wrapper,{opacity:1,top:0},callback);dte._animate(dom.background,{opacity:1});$(window).on('resize.DTED_Lightbox',function(){heightCalc();});scrollTop=$('body').scrollTop();}
dom.close.attr('title',dte.i18n.close).off('click.DTED_Lightbox').on('click.DTED_Lightbox',function(e){dte.close();});dom.background.off('click.DTED_Lightbox').on('click.DTED_Lightbox',function(e){e.stopImmediatePropagation();dte.background();});$('div.DTED_Lightbox_Content_Wrapper',dom.wrapper).off('click.DTED_Lightbox').on('click.DTED_Lightbox',function(e){if($(e.target).hasClass('DTED_Lightbox_Content_Wrapper')){e.stopImmediatePropagation();dte.background();}});}
var self={close:function(dte,callback){hide$1(dte,callback);},conf:{offsetAni:25,windowPadding:25},destroy:function(dte){if(displayed$1){hide$1(dte);}},init:function(dte){init();return self;},node:function(dte){return dom.wrapper[0];},open:function(dte,append,callback){var content=dom.content;content.children().detach();content.append(append).append(dom.close);show$1(dte,callback);},};var DataTable$4=$.fn.dataTable;function add(cfg,after,reorder){if(reorder===void 0){reorder=true;}
if(Array.isArray(cfg)){if(after!==undefined){cfg.reverse();}
for(var i=0;i<cfg.length;i++){this.add(cfg[i],after,false);}
this._displayReorder(this.order());return this;}
var name=cfg.name;if(name===undefined){throw "Error adding field. The field requires a `name` option";}
if(this.s.fields[name]){throw "Error adding field '"+name+"'. A field already exists with this name";}
this._dataSource('initField',cfg);var field=new Editor.Field(cfg,this.classes.field,this);if(this.s.mode){var editFields=this.s.editFields;field.multiReset();$.each(editFields,function(idSrc,edit){var val;if(edit.data){val=field.valFromData(edit.data);}
field.multiSet(idSrc,val!==undefined?val:field.def());});}
this.s.fields[name]=field;if(after===undefined){this.s.order.push(name);}
else if(after===null){this.s.order.unshift(name);}
else{var idx=$.inArray(after,this.s.order);this.s.order.splice(idx+1,0,name);}
if(reorder!==false){this._displayReorder(this.order());}
return this;}
function ajax(newAjax){if(newAjax){this.s.ajax=newAjax;return this;}
return this.s.ajax;}
function background(){var onBackground=this.s.editOpts.onBackground;if(typeof onBackground==='function'){onBackground(this);}
else if(onBackground==='blur'){this.blur();}
else if(onBackground==='close'){this.close();}
else if(onBackground==='submit'){this.submit();}
return this;}
function blur(){this._blur();return this;}
function bubble(cells,fieldNames,show,opts){var _this=this;var that=this;if(this._tidy(function(){that.bubble(cells,fieldNames,opts);})){return this;}
if($.isPlainObject(fieldNames)){opts=fieldNames;fieldNames=undefined;show=true;}
else if(typeof fieldNames==='boolean'){show=fieldNames;fieldNames=undefined;opts=undefined;}
if($.isPlainObject(show)){opts=show;show=true;}
if(show===undefined){show=true;}
opts=$.extend({},this.s.formOptions.bubble,opts);var editFields=this._dataSource('individual',cells,fieldNames);this._edit(cells,editFields,'bubble',opts,function(){var namespace=_this._formOptions(opts);var ret=_this._preopen('bubble');if(!ret){return _this;}
$(window).on('resize.'+namespace,function(){_this.bubblePosition();});var nodes=[];_this.s.bubbleNodes=nodes.concat.apply(nodes,pluck(editFields,'attach'));var classes=_this.classes.bubble;var background=$('<div class="'+classes.bg+'"><div></div></div>');var container=$('<div class="'+classes.wrapper+'">'+
'<div class="'+classes.liner+'">'+
'<div class="'+classes.table+'">'+
'<div class="'+classes.close+'" title="'+_this.i18n.close+'"></div>'+
'<div class="DTE_Processing_Indicator"><span></div>'+
'</div>'+
'</div>'+
'<div class="'+classes.pointer+'"></div>'+
'</div>');if(show){container.appendTo('body');background.appendTo('body');}
var liner=container.children().eq(0);var table=liner.children();var close=table.children();liner.append(_this.dom.formError);table.prepend(_this.dom.form);if(opts.message){liner.prepend(_this.dom.formInfo);}
if(opts.title){liner.prepend(_this.dom.header);}
if(opts.buttons){table.append(_this.dom.buttons);}
var finish=function(){_this._clearDynamicInfo();_this._event('closed',['bubble']);};var pair=$().add(container).add(background);_this._closeReg(function(submitComplete){_this._animate(pair,{opacity:0},function(){if(this===container[0]){pair.detach();$(window).off('resize.'+namespace);finish();}});});background.on('click',function(){_this.blur();});close.on('click',function(){_this._close();});_this.bubblePosition();_this._postopen('bubble',false);var opened=function(){_this._focus(_this.s.includeFields,opts.focus);_this._event('opened',['bubble',_this.s.action]);};_this._animate(pair,{opacity:1},function(){if(this===container[0]){opened();}});});return this;}
function bubblePosition(){var wrapper=$('div.DTE_Bubble'),liner=$('div.DTE_Bubble_Liner'),nodes=this.s.bubbleNodes;var position={top:0,left:0,right:0,bottom:0};$.each(nodes,function(i,node){var pos=$(node).offset();node=$(node).get(0);position.top+=pos.top;position.left+=pos.left;position.right+=pos.left+node.offsetWidth;position.bottom+=pos.top+node.offsetHeight;});position.top/=nodes.length;position.left/=nodes.length;position.right/=nodes.length;position.bottom/=nodes.length;var top=position.top,left=(position.left+position.right)/2,width=liner.outerWidth(),visLeft=left-(width/2),visRight=visLeft+width,docWidth=$(window).width(),padding=15;this.classes.bubble;wrapper.css({top:top,left:left});if(liner.length&&liner.offset().top<0){wrapper.css('top',position.bottom).addClass('below');}
else{wrapper.removeClass('below');}
if(visRight+padding>docWidth){var diff=visRight-docWidth;liner.css('left',visLeft<padding?-(visLeft-padding):-(diff+padding));}
else{liner.css('left',visLeft<padding?-(visLeft-padding):0);}
return this;}
function buttons(buttons){var _this=this;if(buttons==='_basic'){buttons=[{text:this.i18n[this.s.action].submit,action:function(){this.submit();}}];}
else if(!Array.isArray(buttons)){buttons=[buttons];}
$(this.dom.buttons).empty();$.each(buttons,function(i,btn){if(typeof btn==='string'){btn={text:btn,action:function(){this.submit();}};}
var text=btn.text||btn.label;var action=btn.action||btn.fn;$('<button></button>',{'class':_this.classes.form.button+(btn.className?' '+btn.className:'')}).html(typeof text==='function'?text(_this):text||'').attr('tabindex',btn.tabIndex!==undefined?btn.tabIndex:0).on('keyup',function(e){if(e.which===13&&action){action.call(_this);}}).on('keypress',function(e){if(e.which===13){e.preventDefault();}}).on('click',function(e){e.preventDefault();if(action){action.call(_this,e);}}).appendTo(_this.dom.buttons);});return this;}
function clear(fieldName){var that=this;var fields=this.s.fields;if(typeof fieldName==='string'){that.field(fieldName).destroy();delete fields[fieldName];var orderIdx=$.inArray(fieldName,this.s.order);this.s.order.splice(orderIdx,1);var includeIdx=$.inArray(fieldName,this.s.includeFields);if(includeIdx!==-1){this.s.includeFields.splice(includeIdx,1);}}
else{$.each(this._fieldNames(fieldName),function(i,name){that.clear(name);});}
return this;}
function close(){this._close(false);return this;}
function create(arg1,arg2,arg3,arg4){var _this=this;var that=this;var fields=this.s.fields;var count=1;if(this._tidy(function(){that.create(arg1,arg2,arg3,arg4);})){return this;}
if(typeof arg1==='number'){count=arg1;arg1=arg2;arg2=arg3;}
this.s.editFields={};for(var i=0;i<count;i++){this.s.editFields[i]={fields:this.s.fields};}
var argOpts=this._crudArgs(arg1,arg2,arg3,arg4);this.s.mode='main';this.s.action="create";this.s.modifier=null;this.dom.form.style.display='block';this._actionClass();this._displayReorder(this.fields());$.each(fields,function(name,field){field.multiReset();for(var i=0;i<count;i++){field.multiSet(i,field.def());}
field.set(field.def());});this._event('initCreate',null,function(){_this._assembleMain();_this._formOptions(argOpts.opts);argOpts.maybeOpen();});return this;}
function undependent(parent){if(Array.isArray(parent)){for(var i=0,ien=parent.length;i<ien;i++){this.undependent(parent[i]);}
return this;}
var field=this.field(parent);$(field.node()).off('.edep');return this;}
function dependent(parent,url,opts){var _this=this;if(Array.isArray(parent)){for(var i=0,ien=parent.length;i<ien;i++){this.dependent(parent[i],url,opts);}
return this;}
var that=this;var field=this.field(parent);var ajaxOpts={type:'POST',dataType:'json'};opts=$.extend({event:'change',data:null,preUpdate:null,postUpdate:null},opts);var update=function(json){if(opts.preUpdate){opts.preUpdate(json);}
$.each({labels:'label',options:'update',values:'val',messages:'message',errors:'error'},function(jsonProp,fieldFn){if(json[jsonProp]){$.each(json[jsonProp],function(field,val){that.field(field)[fieldFn](val);});}});$.each(['hide','show','enable','disable'],function(i,key){if(json[key]){that[key](json[key],json.animate);}});if(opts.postUpdate){opts.postUpdate(json);}
field.processing(false);};$(field.node()).on(opts.event+'.edep',function(e){if($(field.node()).find(e.target).length===0){return;}
field.processing(true);var data={};data.rows=_this.s.editFields?pluck(_this.s.editFields,'data'):null;data.row=data.rows?data.rows[0]:null;data.values=_this.val();if(opts.data){var ret=opts.data(data);if(ret){opts.data=ret;}}
if(typeof url==='function'){var o=url.call(_this,field.val(),data,update,e);if(o){if(typeof o==='object'&&typeof o.then==='function'){o.then(function(resolved){if(resolved){update(resolved);}});}
else{update(o);}}}
else{if($.isPlainObject(url)){$.extend(ajaxOpts,url);}
else{ajaxOpts.url=url;}
$.ajax($.extend(ajaxOpts,{data:data,success:update}));}});return this;}
function destroy(){if(this.s.displayed){this.close();}
this.clear();if(this.s.template){$('body').append(this.s.template);}
var controller=this.s.displayController;if(controller.destroy){controller.destroy(this);}
$(document).off('.dte'+this.s.unique);this.dom=null;this.s=null;}
function disable(name){var that=this;$.each(this._fieldNames(name),function(i,n){that.field(n).disable();});return this;}
function display(show){if(show===undefined){return this.s.displayed;}
return this[show?'open':'close']();}
function displayed(){return $.map(this.s.fields,function(field,name){return field.displayed()?name:null;});}
function displayNode(){return this.s.displayController.node(this);}
function edit(items,arg1,arg2,arg3,arg4){var _this=this;var that=this;if(this._tidy(function(){that.edit(items,arg1,arg2,arg3,arg4);})){return this;}
var argOpts=this._crudArgs(arg1,arg2,arg3,arg4);this._edit(items,this._dataSource('fields',items),'main',argOpts.opts,function(){_this._assembleMain();_this._formOptions(argOpts.opts);argOpts.maybeOpen();});return this;}
function enable(name){var that=this;$.each(this._fieldNames(name),function(i,n){that.field(n).enable();});return this;}
function error$1(name,msg){var wrapper=$(this.dom.wrapper);if(msg===undefined){this._message(this.dom.formError,name,true,function(){wrapper.toggleClass('inFormError',name!==undefined&&name!=='');});this.s.globalError=name;}
else{this.field(name).error(msg);}
return this;}
function field(name){var fields=this.s.fields;if(!fields[name]){throw 'Unknown field name - '+name;}
return fields[name];}
function fields(){return $.map(this.s.fields,function(field,name){return name;});}
function file(name,id){var table=this.files(name);var file=table[id];if(!file){throw 'Unknown file id '+id+' in table '+name;}
return table[id];}
function files(name){if(!name){return Editor.files;}
var table=Editor.files[name];if(!table){throw 'Unknown file table name: '+name;}
return table;}
function get(name){var that=this;if(!name){name=this.fields();}
if(Array.isArray(name)){var out={};$.each(name,function(i,n){out[n]=that.field(n).get();});return out;}
return this.field(name).get();}
function hide(names,animate){var that=this;$.each(this._fieldNames(names),function(i,n){that.field(n).hide(animate);});return this;}
function ids(includeHash){if(includeHash===void 0){includeHash=false;}
return $.map(this.s.editFields,function(edit,idSrc){return includeHash===true?'#'+idSrc:idSrc;});}
function inError(inNames){$(this.dom.formError);if(this.s.globalError){return true;}
var names=this._fieldNames(inNames);for(var i=0,ien=names.length;i<ien;i++){if(this.field(names[i]).inError()){return true;}}
return false;}
function inline(cell,fieldName,opts){var _this=this;var that=this;if($.isPlainObject(fieldName)){opts=fieldName;fieldName=undefined;}
opts=$.extend({},this.s.formOptions.inline,opts);var editFields=this._dataSource('individual',cell,fieldName);var keys=Object.keys(editFields);if(keys.length>1){throw new Error('Cannot edit more than one row inline at a time');}
var editRow=editFields[keys[0]];var hosts=[];for(var i=0;i<editRow.attach.length;i++){hosts.push(editRow.attach[i]);}
if($('div.DTE_Field',hosts).length){return this;}
if(this._tidy(function(){that.inline(cell,fieldName,opts);})){return this;}
this._edit(cell,editFields,'inline',opts,function(){_this._inline(editFields,opts);});return this;}
function inlineCreate(insertPoint,opts){var _this=this;if($.isPlainObject(insertPoint)){opts=insertPoint;insertPoint=null;}
if(this._tidy(function(){_this.inlineCreate(insertPoint,opts);})){return this;}
$.each(this.s.fields,function(name,field){field.multiReset();field.multiSet(0,field.def());field.set(field.def());});this.s.mode='main';this.s.action="create";this.s.modifier=null;this.s.editFields=this._dataSource('fakeRow',insertPoint);opts=$.extend({},this.s.formOptions.inline,opts);this._actionClass();this._inline(this.s.editFields,opts,function(){_this._dataSource('fakeRowEnd');});this._event('initCreate',null);return this;}
function message(name,msg){if(msg===undefined){this._message(this.dom.formInfo,name);}
else{this.field(name).message(msg);}
return this;}
function mode(mode){if(!mode){return this.s.action;}
if(!this.s.action){throw new Error('Not currently in an editing mode');}
else if(this.s.action==='create'&&mode!=='create'){throw new Error('Changing from create mode is not supported');}
this.s.action=mode;return this;}
function modifier(){return this.s.modifier;}
function multiGet(fieldNames){var that=this;if(fieldNames===undefined){fieldNames=this.fields();}
if(Array.isArray(fieldNames)){var out={};$.each(fieldNames,function(i,name){out[name]=that.field(name).multiGet();});return out;}
return this.field(fieldNames).multiGet();}
function multiSet(fieldNames,val){var that=this;if($.isPlainObject(fieldNames)&&val===undefined){$.each(fieldNames,function(name,value){that.field(name).multiSet(value);});}
else{this.field(fieldNames).multiSet(val);}
return this;}
function node(name){var that=this;if(!name){name=this.order();}
return Array.isArray(name)?$.map(name,function(n){return that.field(n).node();}):this.field(name).node();}
function off(name,fn){$(this).off(this._eventName(name),fn);return this;}
function on(name,fn){$(this).on(this._eventName(name),fn);return this;}
function one(name,fn){$(this).one(this._eventName(name),fn);return this;}
function open(){var _this=this;this._displayReorder();this._closeReg(function(){_this._nestedClose(function(){_this._clearDynamicInfo();_this._event('closed',['main']);});});var ret=this._preopen('main');if(!ret){return this;}
this._nestedOpen(function(){_this._focus($.map(_this.s.order,function(name){return _this.s.fields[name];}),_this.s.editOpts.focus);_this._event('opened',['main',_this.s.action]);},this.s.editOpts.nest);this._postopen('main',false);return this;}
function order(set){if(!set){return this.s.order;}
if(arguments.length&&!Array.isArray(set)){set=Array.prototype.slice.call(arguments);}
if(this.s.order.slice().sort().join('-')!==set.slice().sort().join('-')){throw "All fields, and no additional fields, must be provided for ordering.";}
$.extend(this.s.order,set);this._displayReorder();return this;}
function remove(items,arg1,arg2,arg3,arg4){var _this=this;var that=this;if(this._tidy(function(){that.remove(items,arg1,arg2,arg3,arg4);})){return this;}
if(items.length===undefined){items=[items];}
var argOpts=this._crudArgs(arg1,arg2,arg3,arg4);var editFields=this._dataSource('fields',items);this.s.action="remove";this.s.modifier=items;this.s.editFields=editFields;this.dom.form.style.display='none';this._actionClass();this._event('initRemove',[pluck(editFields,'node'),pluck(editFields,'data'),items],function(){_this._event('initMultiRemove',[editFields,items],function(){_this._assembleMain();_this._formOptions(argOpts.opts);argOpts.maybeOpen();var opts=_this.s.editOpts;if(opts.focus!==null){$('button',_this.dom.buttons).eq(opts.focus).focus();}});});return this;}
function set(set,val){var that=this;if(!$.isPlainObject(set)){var o={};o[set]=val;set=o;}
$.each(set,function(n,v){that.field(n).set(v);});return this;}
function show(names,animate){var that=this;$.each(this._fieldNames(names),function(i,n){that.field(n).show(animate);});return this;}
function submit(successCallback,errorCallback,formatdata,hide){var _this=this;var fields=this.s.fields,errorFields=[],errorReady=0,sent=false;if(this.s.processing||!this.s.action){return this;}
this._processing(true);var send=function(){if(errorFields.length!==errorReady||sent){return;}
_this._event('initSubmit',[_this.s.action],function(result){if(result===false){_this._processing(false);return;}
sent=true;_this._submit(successCallback,errorCallback,formatdata,hide);});};this.error();$.each(fields,function(name,field){if(field.inError()){errorFields.push(name);}});$.each(errorFields,function(i,name){fields[name].error('',function(){errorReady++;send();});});send();return this;}
function table(set){if(set===undefined){return this.s.table;}
this.s.table=set;return this;}
function template(set){if(set===undefined){return this.s.template;}
this.s.template=set===null?null:$(set);return this;}
function title(title){var header=$(this.dom.header).children('div.'+this.classes.header.content);if(title===undefined){return header.html();}
if(typeof title==='function'){title=title(this,new DataTable$4.Api(this.s.table));}
header.html(title);return this;}
function val(field,value){if(value!==undefined||$.isPlainObject(field)){return this.set(field,value);}
return this.get(field);}
function error(msg,tn,thro){if(thro===void 0){thro=true;}
var display=tn?msg+' For more information, please refer to https://datatables.net/tn/'+tn:msg;if(thro){throw display;}
else{console.warn(display);}}
function pairs(data,props,fn){var i,ien,dataPoint;props=$.extend({label:'label',value:'value'},props);if(Array.isArray(data)){for(i=0,ien=data.length;i<ien;i++){dataPoint=data[i];if($.isPlainObject(dataPoint)){fn(dataPoint[props.value]===undefined?dataPoint[props.label]:dataPoint[props.value],dataPoint[props.label],i,dataPoint.attr);}
else{fn(dataPoint,dataPoint,i);}}}
else{i=0;$.each(data,function(key,val){fn(val,key,i);i++;});}}
function upload$1(editor,conf,files,progressCallback,completeCallback){var reader=new FileReader();var counter=0;var ids=[];var generalError='A server error occurred while uploading the file';editor.error(conf.name,'');if(typeof conf.ajax==='function'){conf.ajax(files,function(ids){completeCallback.call(editor,ids);});return;}
progressCallback(conf,conf.fileReadText||"<i>Uploading file</i>");reader.onload=function(e){var data=new FormData();var ajax;data.append('action','upload');data.append('uploadField',conf.name);data.append('upload',files[counter]);if(conf.ajaxData){conf.ajaxData(data,files[counter],counter);}
if(conf.ajax){ajax=conf.ajax;}
else if($.isPlainObject(editor.s.ajax)){ajax=editor.s.ajax.upload?editor.s.ajax.upload:editor.s.ajax;}
else if(typeof editor.s.ajax==='string'){ajax=editor.s.ajax;}
if(!ajax){throw new Error('No Ajax option specified for upload plug-in');}
if(typeof ajax==='string'){ajax={url:ajax};}
if(typeof ajax.data==='function'){var d={};var ret=ajax.data(d);if(ret!==undefined&&typeof ret!=='string'){d=ret;}
$.each(d,function(key,value){data.append(key,value);});}
else if($.isPlainObject(ajax.data)){throw new Error('Upload feature cannot use `ajax.data` with an object. Please use it as a function instead.');}
var preRet=editor._event('preUpload',[conf.name,files[counter],data]);if(preRet===false){if(counter<files.length-1){counter++;reader.readAsDataURL(files[counter]);}
else{completeCallback.call(editor,ids);}
return;}
var submit=false;editor.on('preSubmit.DTE_Upload',function(){submit=true;return false;});$.ajax($.extend({},ajax,{type:'post',data:data,dataType:'json',contentType:false,processData:false,xhr:function(){var xhr=$.ajaxSettings.xhr();if(xhr.upload){xhr.upload.onprogress=function(e){if(e.lengthComputable){var percent=(e.loaded/e.total*100).toFixed(0)+"%";progressCallback(conf,files.length===1?percent:counter+':'+files.length+' '+percent);}};xhr.upload.onloadend=function(e){progressCallback(conf,conf.processingText||'Processing');};}
return xhr;},success:function(json){editor.off('preSubmit.DTE_Upload');editor._event('uploadXhrSuccess',[conf.name,json]);if(json.fieldErrors&&json.fieldErrors.length){var errors=json.fieldErrors;for(var i=0,ien=errors.length;i<ien;i++){editor.error(errors[i].name,errors[i].status);}}
else if(json.error){editor.error(json.error);}
else if(!json.upload||!json.upload.id){editor.error(conf.name,generalError);}
else{if(json.files){$.each(json.files,function(table,files){if(!Editor.files[table]){Editor.files[table]={};}
$.extend(Editor.files[table],files);});}
ids.push(json.upload.id);if(counter<files.length-1){counter++;reader.readAsDataURL(files[counter]);}
else{completeCallback.call(editor,ids);if(submit){editor.submit();}}}
progressCallback(conf);},error:function(xhr){editor.error(conf.name,generalError);editor._event('uploadXhrError',[conf.name,xhr]);progressCallback(conf);}}));};files=$.map(files,function(val){return val;});if(conf._limitLeft!==undefined){files.splice(conf._limitLeft,files.length);}
reader.readAsDataURL(files[0]);}
var DataTable$3=$.fn.dataTable;var __inlineCounter=0;function _actionClass(){var classesActions=this.classes.actions;var action=this.s.action;var wrapper=$(this.dom.wrapper);wrapper.removeClass([classesActions.create,classesActions.edit,classesActions.remove].join(' '));if(action==="create"){wrapper.addClass(classesActions.create);}
else if(action==="edit"){wrapper.addClass(classesActions.edit);}
else if(action==="remove"){wrapper.addClass(classesActions.remove);}}
function _ajax(data,success,error,submitParams){var action=this.s.action;var thrown;var opts={type:'POST',dataType:'json',data:null,error:[function(xhr,text,err){thrown=err;}],success:[],complete:[function(xhr,text){var json=null;if(xhr.status===204||xhr.responseText==='null'){json={};}
else{try{json=xhr.responseJSON?xhr.responseJSON:JSON.parse(xhr.responseText);}
catch(e){}}
if($.isPlainObject(json)||Array.isArray(json)){success(json,xhr.status>=400,xhr);}
else{error(xhr,text,thrown);}}]};var a;var ajaxSrc=this.s.ajax;var id=action==='edit'||action==='remove'?pluck(this.s.editFields,'idSrc').join(','):null;if($.isPlainObject(ajaxSrc)&&ajaxSrc[action]){ajaxSrc=ajaxSrc[action];}
if(typeof ajaxSrc==='function'){ajaxSrc(null,null,data,success,error);return;}
else if(typeof ajaxSrc==='string'){if(ajaxSrc.indexOf(' ')!==-1){a=ajaxSrc.split(' ');opts.type=a[0];opts.url=a[1];}
else{opts.url=ajaxSrc;}}
else{var optsCopy=$.extend({},ajaxSrc||{});if(optsCopy.complete){opts.complete.unshift(optsCopy.complete);delete optsCopy.complete;}
if(optsCopy.error){opts.error.unshift(optsCopy.error);delete optsCopy.error;}
opts=$.extend({},opts,optsCopy);}
if(opts.replacements){$.each(opts.replacements,function(key,repl){opts.url=opts.url.replace('{'+key+'}',repl.call(this,key,id,action,data));});}
opts.url=opts.url.replace(/_id_/,id).replace(/{id}/,id);if(opts.data){var isFn=typeof opts.data==='function';var newData=isFn?opts.data(data):opts.data;data=isFn&&newData?newData:$.extend(true,data,newData);}
opts.data=data;if(opts.type==='DELETE'&&(opts.deleteBody===undefined||opts.deleteBody===true)){var params=$.param(opts.data);opts.url+=opts.url.indexOf('?')===-1?'?'+params:'&'+params;delete opts.data;}
$.ajax(opts);}
function _animate(target,style,time,callback){if($.fn.animate){target.stop().animate(style,time,callback);}
else{target.css(style);if(typeof time==='function'){time.call(target);}
else if(callback){callback.call(target);}}}
function _assembleMain(){var dom=this.dom;$(dom.wrapper).prepend(dom.header);$(dom.footer).append(dom.formError).append(dom.buttons);$(dom.bodyContent).append(dom.formInfo).append(dom.form);}
function _blur(){var opts=this.s.editOpts;var onBlur=opts.onBlur;if(this._event('preBlur')===false){return;}
if(typeof onBlur==='function'){onBlur(this);}
else if(onBlur==='submit'){this.submit();}
else if(onBlur==='close'){this._close();}}
function _clearDynamicInfo(errorsOnly){if(errorsOnly===void 0){errorsOnly=false;}
if(!this.s){return;}
var errorClass=this.classes.field.error;var fields=this.s.fields;$('div.'+errorClass,this.dom.wrapper).removeClass(errorClass);$.each(fields,function(name,field){field.error('');if(!errorsOnly){field.message('');}});this.error('');if(!errorsOnly){this.message('');}}
function _close(submitComplete,mode){var closed;if(this._event('preClose')===false){return;}
if(this.s.closeCb){closed=this.s.closeCb(submitComplete,mode);this.s.closeCb=null;}
if(this.s.closeIcb){this.s.closeIcb();this.s.closeIcb=null;}
$('body').off('focus.editor-focus');this.s.displayed=false;this._event('close');if(closed){this._event('closed',[closed]);}}
function _closeReg(fn){this.s.closeCb=fn;}
function _crudArgs(arg1,arg2,arg3,arg4){var that=this;var title;var buttons;var show;var opts;if($.isPlainObject(arg1)){opts=arg1;}
else if(typeof arg1==='boolean'){show=arg1;opts=arg2;}
else{title=arg1;buttons=arg2;show=arg3;opts=arg4;}
if(show===undefined){show=true;}
if(title){that.title(title);}
if(buttons){that.buttons(buttons);}
return{opts:$.extend({},this.s.formOptions.main,opts),maybeOpen:function(){if(show){that.open();}}};}
function _dataSource(name){var args=[];for(var _i=1;_i<arguments.length;_i++){args[_i-1]=arguments[_i];}
var dataSource=this.s.table?Editor.dataSources.dataTable:Editor.dataSources.html;var fn=dataSource[name];if(fn){return fn.apply(this,args);}}
function _displayReorder(includeFields){var _this=this;var formContent=$(this.dom.formContent);var fields=this.s.fields;var order=this.s.order;var template=this.s.template;var mode=this.s.mode||'main';if(includeFields){this.s.includeFields=includeFields;}
else{includeFields=this.s.includeFields;}
formContent.children().detach();$.each(order,function(i,name){if(_this._weakInArray(name,includeFields)!==-1){if(template&&mode==='main'){template.find('editor-field[name="'+name+'"]').after(fields[name].node());template.find('[data-editor-template="'+name+'"]').append(fields[name].node());}
else{formContent.append(fields[name].node());}}});if(template&&mode==='main'){template.appendTo(formContent);}
this._event('displayOrder',[this.s.displayed,this.s.action,formContent]);}
function _edit(items,editFields,type,formOptions,setupDone){var _this=this;var fields=this.s.fields;var usedFields=[];var includeInOrder;var editData={};this.s.editFields=editFields;this.s.editData=editData;this.s.modifier=items;this.s.action="edit";this.dom.form.style.display='block';this.s.mode=type;this._actionClass();$.each(fields,function(name,field){field.multiReset();includeInOrder=false;editData[name]={};$.each(editFields,function(idSrc,edit){if(edit.fields[name]){var val=field.valFromData(edit.data);var nullDefault=field.nullDefault();editData[name][idSrc]=val===null?'':Array.isArray(val)?val.slice():val;if(!formOptions||formOptions.scope==='row'){field.multiSet(idSrc,val===undefined||(nullDefault&&val===null)?field.def():val);if(!edit.displayFields||edit.displayFields[name]){includeInOrder=true;}}
else{if(!edit.displayFields||edit.displayFields[name]){field.multiSet(idSrc,val===undefined||(nullDefault&&val===null)?field.def():val);includeInOrder=true;}}}});if(field.multiIds().length!==0&&includeInOrder){usedFields.push(name);}});var currOrder=this.order().slice();for(var i=currOrder.length-1;i>=0;i--){if($.inArray(currOrder[i].toString(),usedFields)===-1){currOrder.splice(i,1);}}
this._displayReorder(currOrder);this._event('initEdit',[pluck(editFields,'node')[0],pluck(editFields,'data')[0],items,type],function(){_this._event('initMultiEdit',[editFields,items,type],function(){setupDone();});});}
function _event(trigger,args,promiseComplete){if(args===void 0){args=[];}
if(promiseComplete===void 0){promiseComplete=undefined;}
if(Array.isArray(trigger)){for(var i=0,ien=trigger.length;i<ien;i++){this._event(trigger[i],args);}}
else{var e=$.Event(trigger);$(this).triggerHandler(e,args);var result=e.result;if(trigger.indexOf('pre')===0&&result===false){$(this).triggerHandler($.Event(trigger+'Cancelled'),args);}
if(promiseComplete){if(result&&typeof result==='object'&&result.then){result.then(promiseComplete);}
else{promiseComplete(result);}}
return result;}}
function _eventName(input){var name;var names=input.split(' ');for(var i=0,ien=names.length;i<ien;i++){name=names[i];var onStyle=name.match(/^on([A-Z])/);if(onStyle){name=onStyle[1].toLowerCase()+name.substring(3);}
names[i]=name;}
return names.join(' ');}
function _fieldFromNode(node){var foundField=null;$.each(this.s.fields,function(name,field){if($(field.node()).find(node).length){foundField=field;}});return foundField;}
function _fieldNames(fieldNames){if(fieldNames===undefined){return this.fields();}
else if(!Array.isArray(fieldNames)){return[fieldNames];}
return fieldNames;}
function _focus(fieldsIn,focus){var _this=this;if(this.s.action==='remove'){return;}
var field;var fields=$.map(fieldsIn,function(fieldOrName){return typeof fieldOrName==='string'?_this.s.fields[fieldOrName]:fieldOrName;});if(typeof focus==='number'){field=fields[focus];}
else if(focus){if(focus.indexOf('jq:')===0){field=$('div.DTE '+focus.replace(/^jq:/,''));}
else{field=this.s.fields[focus];}}
else{document.activeElement.blur();}
this.s.setFocus=field;if(field){field.focus();}}
function _formOptions(opts){var _this=this;var that=this;var inlineCount=__inlineCounter++;var namespace='.dteInline'+inlineCount;this.s.editOpts=opts;this.s.editCount=inlineCount;if(typeof opts.title==='string'||typeof opts.title==='function'){this.title(opts.title);opts.title=true;}
if(typeof opts.message==='string'||typeof opts.message==='function'){this.message(opts.message);opts.message=true;}
if(typeof opts.buttons!=='boolean'){this.buttons(opts.buttons);opts.buttons=true;}
$(document).on('keydown'+namespace,function(e){if(e.which===13&&_this.s.displayed){var el=$(document.activeElement);if(el){var field=_this._fieldFromNode(el);if(field&&typeof field.canReturnSubmit==='function'&&field.canReturnSubmit(el)){e.preventDefault();}}}});$(document).on('keyup'+namespace,function(e){var el=$(document.activeElement);if(e.which===13&&_this.s.displayed){var field=_this._fieldFromNode(el);if(field&&typeof field.canReturnSubmit==='function'&&field.canReturnSubmit(el)){if(opts.onReturn==='submit'){e.preventDefault();_this.submit();}
else if(typeof opts.onReturn==='function'){e.preventDefault();opts.onReturn(_this,e);}}}
else if(e.which===27){e.preventDefault();if(typeof opts.onEsc==='function'){opts.onEsc(that,e);}
else if(opts.onEsc==='blur'){that.blur();}
else if(opts.onEsc==='close'){that.close();}
else if(opts.onEsc==='submit'){that.submit();}}
else if(el.parents('.DTE_Form_Buttons').length){if(e.which===37){el.prev('button').trigger('focus');}
else if(e.which===39){el.next('button').trigger('focus');}}});this.s.closeIcb=function(){$(document).off('keydown'+namespace);$(document).off('keyup'+namespace);};return namespace;}
function _inline(editFields,opts,closeCb){var _this=this;if(closeCb===void 0){closeCb=null;}
var closed=false;var classes=this.classes.inline;var keys=Object.keys(editFields);var editRow=editFields[keys[0]];var children=null;var lastAttachPoint;var elements=[];for(var i=0;i<editRow.attach.length;i++){var name_1=editRow.attachFields[i][0];elements.push({field:this.s.fields[name_1],name:name_1,node:$(editRow.attach[i]),});}
var namespace=this._formOptions(opts);var ret=this._preopen('inline');if(!ret){return this;}
for(var i=0;i<elements.length;i++){var el=elements[i];var node=el.node;elements[i].children=node.contents().detach();var style=navigator.userAgent.indexOf('Edge/')!==-1?'style="width:'+node.width()+'px"':'';node.append($('<div class="'+classes.wrapper+'">'+
'<div class="'+classes.liner+'" '+style+'>'+
'<div class="DTE_Processing_Indicator"><span></span></div>'+
'</div>'+
'<div class="'+classes.buttons+'"></div>'+
'</div>'));node.find('div.'+classes.liner.replace(/ /g,'.')).append(el.field.node()).append(this.dom.formError);lastAttachPoint=el.field.node();if(opts.buttons){node.find('div.'+classes.buttons.replace(/ /g,'.')).append(this.dom.buttons);}}
var submitTrigger=opts.submitTrigger;if(submitTrigger!==null){if(typeof submitTrigger==='number'){var kids=$(lastAttachPoint).closest('tr').children();submitTrigger=submitTrigger<0?kids[kids.length+submitTrigger]:kids[submitTrigger];}
children=Array.from($(submitTrigger)[0].childNodes).slice();$(children).detach();$(submitTrigger).on('click.dte-submit',function(e){e.stopImmediatePropagation();_this.submit();}).append(opts.submitHtml);}
this._closeReg(function(submitComplete,action){closed=true;$(document).off('click'+namespace);if(!submitComplete||action!=='edit'){elements.forEach(function(el){el.node.contents().detach();el.node.append(el.children);});}
if(submitTrigger){$(submitTrigger).off('click.dte-submit').empty().append(children);}
_this._clearDynamicInfo();if(closeCb){closeCb();}
return 'inline';});setTimeout(function(){if(closed){return;}
var back=$.fn.addBack?'addBack':'andSelf';var target;$(document).on('mousedown'+namespace,function(e){target=e.target;}).on('click'+namespace,function(e){var isIn=false;for(var i=0;i<elements.length;i++){if(elements[i].field._typeFn('owns',target)||$.inArray(elements[i].node[0],$(target).parents()[back]())!==-1){isIn=true;}}
if(!isIn){_this.blur();}});},0);this._focus($.map(elements,function(el){return el.field;}),opts.focus);this._postopen('inline',true);}
function _optionsUpdate(json){var that=this;if(json.options){$.each(this.s.fields,function(name,field){if(json.options[name]!==undefined){var fieldInst=that.field(name);if(fieldInst&&fieldInst.update){fieldInst.update(json.options[name]);}}});}}
function _message(el,msg,title,fn){var canAnimate=$.fn.animate?true:false;if(title===undefined){title=false;}
if(!fn){fn=function(){};}
if(typeof msg==='function'){msg=msg(this,new DataTable$3.Api(this.s.table));}
el=$(el);if(canAnimate){el.stop();}
if(!msg){if(this.s.displayed&&canAnimate){el.fadeOut(function(){el.html('');fn();});}
else{el.html('').css('display','none');fn();}
if(title){el.removeAttr('title');}}
else{fn();if(this.s.displayed&&canAnimate){el.html(msg).fadeIn();}
else{el.html(msg).css('display','block');}
if(title){el.attr('title',msg);}}}
function _multiInfo(){var fields=this.s.fields;var include=this.s.includeFields;var show=true;var state;if(!include){return;}
for(var i=0,ien=include.length;i<ien;i++){var field=fields[include[i]];var multiEditable=field.multiEditable();if(field.isMultiValue()&&multiEditable&&show){state=true;show=false;}
else if(field.isMultiValue()&&!multiEditable){state=true;}
else{state=false;}
fields[include[i]].multiInfoShown(state);}}
function _nestedClose(cb){var disCtrl=this.s.displayController;var show=disCtrl._show;if(!show||!show.length){if(cb){cb();}}
else if(show.length>1){show.pop();var last=show[show.length-1];if(cb){cb();}
this.s.displayController.open(last.dte,last.append,last.callback);}
else{this.s.displayController.close(this,cb);show.length=0;}}
function _nestedOpen(cb,nest){var disCtrl=this.s.displayController;if(!disCtrl._show){disCtrl._show=[];}
if(!nest){disCtrl._show.length=0;}
disCtrl._show.push({dte:this,append:this.dom.wrapper,callback:cb,});this.s.displayController.open(this,this.dom.wrapper,cb);}
function _postopen(type,immediate){var _this=this;var focusCapture=this.s.displayController.captureFocus;if(focusCapture===undefined){focusCapture=true;}
$(this.dom.form).off('submit.editor-internal').on('submit.editor-internal',function(e){e.preventDefault();});if(focusCapture&&(type==='main'||type==='bubble')){$('body').on('focus.editor-focus',function(){if($(document.activeElement).parents('.DTE').length===0&&$(document.activeElement).parents('.DTED').length===0){if(_this.s.setFocus){_this.s.setFocus.focus();}}});}
this._multiInfo();this._event('open',[type,this.s.action]);if(immediate){this._event('opened',[type,this.s.action]);}
return true;}
function _preopen(type){if(this._event('preOpen',[type,this.s.action])===false){this._clearDynamicInfo();this._event('cancelOpen',[type,this.s.action]);if((this.s.mode==='inline'||this.s.mode==='bubble')&&this.s.closeIcb){this.s.closeIcb();}
this.s.closeIcb=null;return false;}
this._clearDynamicInfo(true);this.s.displayed=type;return true;}
function _processing(processing){var procClass=this.classes.processing.active;$(['div.DTE',this.dom.wrapper]).toggleClass(procClass,processing);this.s.processing=processing;this._event('processing',[processing]);}
function _noProcessing(args){var processing=false;$.each(this.s.fields,function(name,field){if(field.processing()){processing=true;}});if(processing){this.one('processing-field',function(){if(this._noProcessing(args)===true){this._submit.apply(this,args);}});}
return!processing;}
function _submit(successCallback,errorCallback,formatdata,hide){var _this=this;var changed=false,allData={},changedData={};var setBuilder=dataSet;var fields=this.s.fields;var editCount=this.s.editCount;var editFields=this.s.editFields;var editData=this.s.editData;var opts=this.s.editOpts;var changedSubmit=opts.submit;var submitParamsLocal;if(this._noProcessing(arguments)===false){Editor.error('Field is still processing',16,false);return;}
var action=this.s.action;var submitParams={"data":{}};submitParams[this.s.actionName]=action;if(action==="create"||action==="edit"){$.each(editFields,function(idSrc,edit){var allRowData={};var changedRowData={};$.each(fields,function(name,field){if(edit.fields[name]&&field.submittable()){var multiGet=field.multiGet();var builder=setBuilder(name);if(multiGet[idSrc]===undefined){var originalVal=field.valFromData(edit.data);builder(allRowData,originalVal);return;}
var value=multiGet[idSrc];var manyBuilder=Array.isArray(value)&&typeof name==='string'&&name.indexOf('[]')!==-1?setBuilder(name.replace(/\[.*$/,'')+'-many-count'):null;builder(allRowData,value);if(manyBuilder){manyBuilder(allRowData,value.length);}
if(action==='edit'&&(!editData[name]||!field.compare(value,editData[name][idSrc]))){builder(changedRowData,value);changed=true;if(manyBuilder){manyBuilder(changedRowData,value.length);}}}});if(!$.isEmptyObject(allRowData)){allData[idSrc]=allRowData;}
if(!$.isEmptyObject(changedRowData)){changedData[idSrc]=changedRowData;}});if(action==='create'||changedSubmit==='all'||(changedSubmit==='allIfChanged'&&changed)){submitParams.data=allData;}
else if(changedSubmit==='changed'&&changed){submitParams.data=changedData;}
else{this.s.action=null;if(opts.onComplete==='close'&&(hide===undefined||hide)){this._close(false);}
else if(typeof opts.onComplete==='function'){opts.onComplete(this);}
if(successCallback){successCallback.call(this);}
this._processing(false);this._event('submitComplete');return;}}
else if(action==="remove"){$.each(editFields,function(idSrc,edit){submitParams.data[idSrc]=edit.data;});}
submitParamsLocal=$.extend(true,{},submitParams);if(formatdata){formatdata(submitParams);}
this._event('preSubmit',[submitParams,action],function(result){if(result===false){_this._processing(false);}
else{var submitWire=_this.s.ajax?_this._ajax:_this._submitTable;submitWire.call(_this,submitParams,function(json,notGood,xhr){_this._submitSuccess(json,notGood,submitParams,submitParamsLocal,_this.s.action,editCount,hide,successCallback,errorCallback,xhr);},function(xhr,err,thrown){_this._submitError(xhr,err,thrown,errorCallback,submitParams,_this.s.action);},submitParams);}});}
function _submitTable(data,success,error,submitParams){var action=data.action;var out={data:[]};var idGet=dataGet(this.s.idSrc);var idSet=dataSet(this.s.idSrc);if(action!=='remove'){var originalData=this.s.mode==='main'?this._dataSource('fields',this.modifier()):this._dataSource('individual',this.modifier());$.each(data.data,function(key,vals){var toSave;var extender=extend;if(action==='edit'){var rowData=originalData[key].data;toSave=extender({},rowData,true);toSave=extender(toSave,vals,true);}
else{toSave=extender({},vals,true);}
var overrideId=idGet(toSave);if(action==='create'&&overrideId===undefined){idSet(toSave,+new Date()+key.toString());}
else{idSet(toSave,overrideId);}
out.data.push(toSave);});}
success(out);}
function _submitSuccess(json,notGood,submitParams,submitParamsLocal,action,editCount,hide,successCallback,errorCallback,xhr){var _this=this;var that=this;var setData;var fields=this.s.fields;var opts=this.s.editOpts;var modifier=this.s.modifier;this._event('postSubmit',[json,submitParams,action,xhr]);if(!json.error){json.error="";}
if(!json.fieldErrors){json.fieldErrors=[];}
if(notGood||json.error||json.fieldErrors.length){var globalError=[];if(json.error){globalError.push(json.error);}
$.each(json.fieldErrors,function(i,err){var field=fields[err.name];if(!field){throw new Error('Unknown field: '+err.name);}
else if(field.displayed()){field.error(err.status||"Error");if(i===0){if(opts.onFieldError==='focus'){_this._animate($(_this.dom.bodyContent),{scrollTop:$(field.node()).position().top},500);field.focus();}
else if(typeof opts.onFieldError==='function'){opts.onFieldError(_this,err);}}}
else{globalError.push(field.name()+': '+(err.status||"Error"));}});this.error(globalError.join('<br>'));this._event('submitUnsuccessful',[json]);if(errorCallback){errorCallback.call(that,json);}}
else{var store={};if(json.data&&(action==="create"||action==="edit")){this._dataSource('prep',action,modifier,submitParamsLocal,json,store);for(var i=0;i<json.data.length;i++){setData=json.data[i];var id=this._dataSource('id',setData);this._event('setData',[json,setData,action]);if(action==="create"){this._event('preCreate',[json,setData,id]);this._dataSource('create',fields,setData,store);this._event(['create','postCreate'],[json,setData,id]);}
else if(action==="edit"){this._event('preEdit',[json,setData,id]);this._dataSource('edit',modifier,fields,setData,store);this._event(['edit','postEdit'],[json,setData,id]);}}
this._dataSource('commit',action,modifier,json.data,store);}
else if(action==="remove"){this._dataSource('prep',action,modifier,submitParamsLocal,json,store);this._event('preRemove',[json,this.ids()]);this._dataSource('remove',modifier,fields,store);this._event(['remove','postRemove'],[json,this.ids()]);this._dataSource('commit',action,modifier,json.data,store);}
if(editCount===this.s.editCount){var action_1=this.s.action;this.s.action=null;if(opts.onComplete==='close'&&(hide===undefined||hide)){this._close(json.data?true:false,action_1);}
else if(typeof opts.onComplete==='function'){opts.onComplete(this);}}
if(successCallback){successCallback.call(that,json);}
this._event('submitSuccess',[json,setData,action]);}
this._processing(false);this._event('submitComplete',[json,setData,action]);}
function _submitError(xhr,err,thrown,errorCallback,submitParams,action){this._event('postSubmit',[null,submitParams,action,xhr]);this.error(this.i18n.error.system);this._processing(false);if(errorCallback){errorCallback.call(this,xhr,err,thrown);}
this._event(['submitError','submitComplete'],[xhr,err,thrown,submitParams]);}
function _tidy(fn){var _this=this;var dt=this.s.table?new $.fn.dataTable.Api(this.s.table):null;var ssp=false;if(dt){ssp=dt.settings()[0].oFeatures.bServerSide;}
if(this.s.processing){this.one('submitComplete',function(){if(ssp){dt.one('draw',fn);}
else{setTimeout(function(){fn();},10);}});return true;}
else if(this.display()==='inline'||this.display()==='bubble'){this.one('close',function(){if(!_this.s.processing){setTimeout(function(){if(_this.s){fn();}},10);}
else{_this.one('submitComplete',function(e,json){if(ssp&&json){dt.one('draw',fn);}
else{setTimeout(function(){if(_this.s){fn();}},10);}});}}).blur();return true;}
return false;}
function _weakInArray(name,arr){for(var i=0,ien=arr.length;i<ien;i++){if(name==arr[i]){return i;}}
return-1;}
var fieldType={create:function(){},get:function(){},set:function(){},enable:function(){},disable:function(){},};var DataTable$2=$.fn.dataTable;function _buttonText(conf,text){if(text===null||text===undefined){text=conf.uploadText||"Choose file...";}
conf._input.find('div.upload button').html(text);}
function _commonUpload(editor,conf,dropCallback,multiple){if(multiple===void 0){multiple=false;}
var btnClass=editor.classes.form.buttonInternal;var container=$('<div class="editor_upload">'+
'<div class="eu_table">'+
'<div class="row">'+
'<div class="cell upload limitHide">'+
'<button class="'+btnClass+'"></button>'+
'<input type="file" '+(multiple?'multiple':'')+'></input>'+
'</div>'+
'<div class="cell clearValue">'+
'<button class="'+btnClass+'"></button>'+
'</div>'+
'</div>'+
'<div class="row second">'+
'<div class="cell limitHide">'+
'<div class="drop"><span></span></div>'+
'</div>'+
'<div class="cell">'+
'<div class="rendered"></div>'+
'</div>'+
'</div>'+
'</div>'+
'</div>');conf._input=container;conf._enabled=true;if(conf.id){container.find('input[type=file]').attr('id',Editor.safeId(conf.id));}
if(conf.attr){container.find('input[type=file]').attr(conf.attr);}
_buttonText(conf);if(window.FileReader&&conf.dragDrop!==false){container.find('div.drop span').text(conf.dragDropText||"Drag and drop a file here to upload");var dragDrop=container.find('div.drop');dragDrop.on('drop',function(e){if(conf._enabled){Editor.upload(editor,conf,e.originalEvent.dataTransfer.files,_buttonText,dropCallback);dragDrop.removeClass('over');}
return false;}).on('dragleave dragexit',function(e){if(conf._enabled){dragDrop.removeClass('over');}
return false;}).on('dragover',function(e){if(conf._enabled){dragDrop.addClass('over');}
return false;});editor.on('open',function(){$('body').on('dragover.DTE_Upload drop.DTE_Upload',function(e){return false;});}).on('close',function(){$('body').off('dragover.DTE_Upload drop.DTE_Upload');});}
else{container.addClass('noDrop');container.append(container.find('div.rendered'));}
container.find('div.clearValue button').on('click',function(e){e.preventDefault();if(conf._enabled){upload.set.call(editor,conf,'');}});container.find('input[type=file]').on('input',function(){Editor.upload(editor,conf,this.files,_buttonText,function(ids){dropCallback.call(editor,ids);container.find('input[type=file]')[0].value='';});});return container;}
function _triggerChange(input){setTimeout(function(){input.trigger('change',{editor:true,editorSet:true});},0);}
var baseFieldType=$.extend(true,{},fieldType,{get:function(conf){return conf._input.val();},set:function(conf,val){conf._input.val(val);_triggerChange(conf._input);},enable:function(conf){conf._input.prop('disabled',false);},disable:function(conf){conf._input.prop('disabled',true);},canReturnSubmit:function(conf,node){return true;}});var hidden={create:function(conf){conf._val=conf.value;return null;},get:function(conf){return conf._val;},set:function(conf,val){conf._val=val;}};var readonly=$.extend(true,{},baseFieldType,{create:function(conf){conf._input=$('<input/>').attr($.extend({id:Editor.safeId(conf.id),type:'text',readonly:'readonly'},conf.attr||{}));return conf._input[0];}});var text=$.extend(true,{},baseFieldType,{create:function(conf){conf._input=$('<input/>').attr($.extend({id:Editor.safeId(conf.id),type:'text'},conf.attr||{}));return conf._input[0];}});var password=$.extend(true,{},baseFieldType,{create:function(conf){conf._input=$('<input/>').attr($.extend({id:Editor.safeId(conf.id),type:'password'},conf.attr||{}));return conf._input[0];}});var textarea=$.extend(true,{},baseFieldType,{create:function(conf){conf._input=$('<textarea></textarea>').attr($.extend({id:Editor.safeId(conf.id)},conf.attr||{}));return conf._input[0];},canReturnSubmit:function(conf,node){return false;}});var select=$.extend(true,{},baseFieldType,{_addOptions:function(conf,opts,append){if(append===void 0){append=false;}
var elOpts=conf._input[0].options;var countOffset=0;if(!append){elOpts.length=0;if(conf.placeholder!==undefined){var placeholderValue=conf.placeholderValue!==undefined?conf.placeholderValue:'';countOffset+=1;elOpts[0]=new Option(conf.placeholder,placeholderValue);var disabled=conf.placeholderDisabled!==undefined?conf.placeholderDisabled:true;elOpts[0].hidden=disabled;elOpts[0].disabled=disabled;elOpts[0]._editor_val=placeholderValue;}}
else{countOffset=elOpts.length;}
if(opts){Editor.pairs(opts,conf.optionsPair,function(val,label,i,attr){var option=new Option(label,val);option._editor_val=val;if(attr){$(option).attr(attr);}
elOpts[i+countOffset]=option;});}},create:function(conf){conf._input=$('<select></select>').attr($.extend({id:Editor.safeId(conf.id),multiple:conf.multiple===true},conf.attr||{})).on('change.dte',function(e,d){if(!d||!d.editor){conf._lastSet=select.get(conf);}});select._addOptions(conf,conf.options||conf.ipOpts);return conf._input[0];},update:function(conf,options,append){select._addOptions(conf,options,append);var lastSet=conf._lastSet;if(lastSet!==undefined){select.set(conf,lastSet,true);}
_triggerChange(conf._input);},get:function(conf){var val=conf._input.find('option:selected').map(function(){return this._editor_val;}).toArray();if(conf.multiple){return conf.separator?val.join(conf.separator):val;}
return val.length?val[0]:null;},set:function(conf,val,localUpdate){if(!localUpdate){conf._lastSet=val;}
if(conf.multiple&&conf.separator&&!Array.isArray(val)){val=typeof val==='string'?val.split(conf.separator):[];}
else if(!Array.isArray(val)){val=[val];}
var i,len=val.length,found,allFound=false;var options=conf._input.find('option');conf._input.find('option').each(function(){found=false;for(i=0;i<len;i++){if(this._editor_val==val[i]){found=true;allFound=true;break;}}
this.selected=found;});if(conf.placeholder&&!allFound&&!conf.multiple&&options.length){options[0].selected=true;}
if(!localUpdate){_triggerChange(conf._input);}
return allFound;},destroy:function(conf){conf._input.off('change.dte');}});var checkbox=$.extend(true,{},baseFieldType,{_addOptions:function(conf,opts,append){if(append===void 0){append=false;}
var jqInput=conf._input;var offset=0;if(!append){jqInput.empty();}
else{offset=$('input',jqInput).length;}
if(opts){Editor.pairs(opts,conf.optionsPair,function(val,label,i,attr){jqInput.append('<div>'+
'<input id="'+Editor.safeId(conf.id)+'_'+(i+offset)+'" type="checkbox" />'+
'<label for="'+Editor.safeId(conf.id)+'_'+(i+offset)+'">'+label+'</label>'+
'</div>');$('input:last',jqInput).attr('value',val)[0]._editor_val=val;if(attr){$('input:last',jqInput).attr(attr);}});}},create:function(conf){conf._input=$('<div></div>');checkbox._addOptions(conf,conf.options||conf.ipOpts);return conf._input[0];},get:function(conf){var out=[];var selected=conf._input.find('input:checked');if(selected.length){selected.each(function(){out.push(this._editor_val);});}
else if(conf.unselectedValue!==undefined){out.push(conf.unselectedValue);}
return conf.separator===undefined||conf.separator===null?out:out.join(conf.separator);},set:function(conf,val){var jqInputs=conf._input.find('input');if(!Array.isArray(val)&&typeof val==='string'){val=val.split(conf.separator||'|');}
else if(!Array.isArray(val)){val=[val];}
var i,len=val.length,found;jqInputs.each(function(){found=false;for(i=0;i<len;i++){if(this._editor_val==val[i]){found=true;break;}}
this.checked=found;});_triggerChange(jqInputs);},enable:function(conf){conf._input.find('input').prop('disabled',false);},disable:function(conf){conf._input.find('input').prop('disabled',true);},update:function(conf,options,append){var currVal=checkbox.get(conf);checkbox._addOptions(conf,options,append);checkbox.set(conf,currVal);}});var radio=$.extend(true,{},baseFieldType,{_addOptions:function(conf,opts,append){if(append===void 0){append=false;}
var jqInput=conf._input;var offset=0;if(!append){jqInput.empty();}
else{offset=$('input',jqInput).length;}
if(opts){Editor.pairs(opts,conf.optionsPair,function(val,label,i,attr){jqInput.append('<div>'+
'<input id="'+Editor.safeId(conf.id)+'_'+(i+offset)+'" type="radio" name="'+conf.name+'" />'+
'<label for="'+Editor.safeId(conf.id)+'_'+(i+offset)+'">'+label+'</label>'+
'</div>');$('input:last',jqInput).attr('value',val)[0]._editor_val=val;if(attr){$('input:last',jqInput).attr(attr);}});}},create:function(conf){conf._input=$('<div />');radio._addOptions(conf,conf.options||conf.ipOpts);this.on('open',function(){conf._input.find('input').each(function(){if(this._preChecked){this.checked=true;}});});return conf._input[0];},get:function(conf){var el=conf._input.find('input:checked');return el.length?el[0]._editor_val:undefined;},set:function(conf,val){conf._input.find('input').each(function(){this._preChecked=false;if(this._editor_val==val){this.checked=true;this._preChecked=true;}
else{this.checked=false;this._preChecked=false;}});_triggerChange(conf._input.find('input:checked'));},enable:function(conf){conf._input.find('input').prop('disabled',false);},disable:function(conf){conf._input.find('input').prop('disabled',true);},update:function(conf,options,append){var currVal=radio.get(conf);radio._addOptions(conf,options,append);var inputs=conf._input.find('input');radio.set(conf,inputs.filter('[value="'+currVal+'"]').length?currVal:inputs.eq(0).attr('value'));}});var datetime=$.extend(true,{},baseFieldType,{create:function(conf){conf._input=$('<input />').attr($.extend(true,{id:Editor.safeId(conf.id),type:'text'},conf.attr));if(!DataTable$2.DateTime){Editor.error('DateTime library is required',15);}
conf._picker=new DataTable$2.DateTime(conf._input,$.extend({format:conf.displayFormat||conf.format,i18n:this.i18n.datetime,},conf.opts));conf._closeFn=function(){conf._picker.hide();};if(conf.keyInput===false){conf._input.on('keydown',function(e){e.preventDefault();});}
this.on('close',conf._closeFn);return conf._input[0];},get:function(conf){var val=conf._input.val();var inst=conf._picker.c;var moment=window.moment;return val&&conf.wireFormat&&moment?moment(val,inst.format,inst.momentLocale,inst.momentStrict).format(conf.wireFormat):val;},set:function(conf,val){var inst=conf._picker.c;var moment=window.moment;conf._picker.val(typeof val==='string'&&val&&val.indexOf('--')!==0&&conf.wireFormat&&moment?moment(val,conf.wireFormat,inst.momentLocale,inst.momentStrict).format(inst.format):val);_triggerChange(conf._input);},owns:function(conf,node){return conf._picker.owns(node);},errorMessage:function(conf,msg){conf._picker.errorMsg(msg);},destroy:function(conf){this.off('close',conf._closeFn);conf._input.off('keydown');conf._picker.destroy();},minDate:function(conf,min){conf._picker.min(min);},maxDate:function(conf,max){conf._picker.max(max);}});var upload=$.extend(true,{},baseFieldType,{create:function(conf){var editor=this;var container=_commonUpload(editor,conf,function(val){upload.set.call(editor,conf,val[0]);editor._event('postUpload',[conf.name,val[0]]);});return container;},get:function(conf){return conf._val;},set:function(conf,val){conf._val=val;conf._input.val('');var container=conf._input;if(conf.display){var rendered=container.find('div.rendered');if(conf._val){rendered.html(conf.display(conf._val));}
else{rendered.empty().append('<span>'+(conf.noFileText||'No file')+'</span>');}}
var button=container.find('div.clearValue button');if(val&&conf.clearText){button.html(conf.clearText);container.removeClass('noClear');}
else{container.addClass('noClear');}
conf._input.find('input').triggerHandler('upload.editor',[conf._val]);},enable:function(conf){conf._input.find('input').prop('disabled',false);conf._enabled=true;},disable:function(conf){conf._input.find('input').prop('disabled',true);conf._enabled=false;},canReturnSubmit:function(conf,node){return false;}});var uploadMany=$.extend(true,{},baseFieldType,{_showHide:function(conf){if(!conf.limit){return;}
conf._container.find('div.limitHide').css('display',conf._val.length>=conf.limit?'none':'block');conf._limitLeft=conf.limit-conf._val.length;},create:function(conf){var editor=this;var container=_commonUpload(editor,conf,function(val){conf._val=conf._val.concat(val);uploadMany.set.call(editor,conf,conf._val);editor._event('postUpload',[conf.name,conf._val]);},true);container.addClass('multi').on('click','button.remove',function(e){e.stopPropagation();if(conf._enabled){var idx=$(this).data('idx');conf._val.splice(idx,1);uploadMany.set.call(editor,conf,conf._val);}});conf._container=container;return container;},get:function(conf){return conf._val;},set:function(conf,val){if(!val){val=[];}
if(!Array.isArray(val)){throw 'Upload collections must have an array as a value';}
conf._val=val;conf._input.val('');var that=this;var container=conf._input;if(conf.display){var rendered=container.find('div.rendered').empty();if(val.length){var list=$('<ul></ul>').appendTo(rendered);$.each(val,function(i,file){list.append('<li>'+
conf.display(file,i)+
' <button class="'+that.classes.form.button+' remove" data-idx="'+i+'">&times;</button>'+
'</li>');});}
else{rendered.append('<span>'+(conf.noFileText||'No files')+'</span>');}}
uploadMany._showHide(conf);conf._input.find('input').triggerHandler('upload.editor',[conf._val]);},enable:function(conf){conf._input.find('input').prop('disabled',false);conf._enabled=true;},disable:function(conf){conf._input.find('input').prop('disabled',true);conf._enabled=false;},canReturnSubmit:function(conf,node){return false;}});var datatable=$.extend(true,{},baseFieldType,{_addOptions:function(conf,options,append){if(append===void 0){append=false;}
var dt=conf.dt;if(!append){dt.clear();}
dt.rows.add(options).draw();},create:function(conf){var _this=this;conf.optionsPair=$.extend({label:'label',value:'value'},conf.optionsPair);var table=$('<table>');if(conf.footer){$('<tfoot>').append(Array.isArray(conf.footer)?$('<tr>').append($.map(conf.footer,function(str){return $('<th>').html(str);})):conf.footer).appendTo(table);}
var dt=table.addClass(datatable.tableClass).width('100%').DataTable($.extend({buttons:[],columns:[{title:'Label',data:conf.optionsPair.label}],deferRender:true,dom:'fiBtp',language:{search:'',searchPlaceholder:'Search',paginate:{next:'>',previous:'<',}},lengthChange:false,select:{style:conf.multiple?'os':'single'},},conf.config));DataTable$2.select.init(dt);this.on('open',function(){if(dt.search()){dt.search('').draw();}
dt.columns.adjust();});dt.on('user-select',function(){_triggerChange($(conf.dt.table().container()));});if(conf.editor){conf.editor.table(dt);conf.editor.on('submitComplete',function(e,json,data,action){if(action==='create'){var _loop_1=function(i){dt.rows(function(idx,d){return d===json.data[i];}).select();};for(var i=0;i<json.data.length;i++){_loop_1(i);}}
else if(action==='edit'||action==='remove'){_this._dataSource('refresh');}});}
conf.dt=dt;datatable._addOptions(conf,conf.options||[]);var container=$(dt.table(undefined).container());return{input:container,side:$('<div class="DTE_Field_Type_datatable_info">').append(container.find('div.dataTables_filter')).append(container.find('div.dt-buttons')).append(container.find('div.dataTables_info')),};},get:function(conf){var rows=conf.dt.rows({selected:true}).data().pluck(conf.optionsPair.value).toArray();return conf.separator||!conf.multiple?rows.join(conf.separator||','):rows;},set:function(conf,val,localUpdate){if(conf.multiple&&conf.separator&&!Array.isArray(val)){val=typeof val==='string'?val.split(conf.separator):[];}
else if(!Array.isArray(val)){val=[val];}
var valueProp=conf.optionsPair.value;conf.dt.rows({selected:true}).deselect();conf.dt.rows(function(idx,data,node){return val.indexOf(data[valueProp])!==-1;}).select();var idx=conf.dt.row({selected:true,order:'applied'}).index();var page=0;if(typeof idx==='number'){var pageLen=conf.dt.page.info().length;var pos=conf.dt.rows({order:'applied'}).indexes().indexOf(idx);page=pageLen>0?Math.floor(pos/pageLen):0;}
conf.dt.page(page).draw(false);if(!localUpdate){_triggerChange($(conf.dt.table().container()));}},update:function(conf,options,append){datatable._addOptions(conf,options,append);var lastSet=conf._lastSet;if(lastSet!==undefined){datatable.set(conf,lastSet,true);}
_triggerChange($(conf.dt.table().container()));},dt:function(conf){return conf.dt;},tableClass:''});var defaults={className:'',compare:null,data:'',def:'',entityDecode:true,fieldInfo:'',id:'',label:'',labelInfo:'',name:null,nullDefault:false,type:'text',message:'',multiEditable:true,submit:true,getFormatter:null,setFormatter:null,};var DataTable$1=$.fn.dataTable;var Field=(function(){function Field(options,classes,host){var that=this;var multiI18n=host.internalI18n().multi;var opts=$.extend(true,{},Field.defaults,options);if(!Editor.fieldTypes[opts.type]){throw new Error('Error adding field - unknown field type '+opts.type);}
this.s={classes:classes,host:host,multiIds:[],multiValue:false,multiValues:{},name:opts.name,opts:opts,processing:false,type:Editor.fieldTypes[opts.type],};if(!opts.id){opts.id='DTE_Field_'+opts.name;}
if(opts.data===''){opts.data=opts.name;}
this.valFromData=function(d){return dataGet(opts.data)(d,'editor');};this.valToData=dataSet(opts.data);var template=$('<div class="'+classes.wrapper+' '+classes.typePrefix+opts.type+' '+classes.namePrefix+opts.name+' '+opts.className+'">'+
'<label data-dte-e="label" class="'+classes.label+'" for="'+Editor.safeId(opts.id)+'">'+
opts.label+
'<div data-dte-e="msg-label" class="'+classes['msg-label']+'">'+opts.labelInfo+'</div>'+
'</label>'+
'<div data-dte-e="input" class="'+classes.input+'">'+
'<div data-dte-e="input-control" class="'+classes.inputControl+'"></div>'+
'<div data-dte-e="multi-value" class="'+classes.multiValue+'">'+
multiI18n.title+
'<span data-dte-e="multi-info" class="'+classes.multiInfo+'">'+
multiI18n.info+
'</span>'+
'</div>'+
'<div data-dte-e="msg-multi" class="'+classes.multiRestore+'">'+
multiI18n.restore+
'</div>'+
'<div data-dte-e="msg-error" class="'+classes['msg-error']+'"></div>'+
'<div data-dte-e="msg-message" class="'+classes['msg-message']+'">'+opts.message+'</div>'+
'<div data-dte-e="msg-info" class="'+classes['msg-info']+'">'+opts.fieldInfo+'</div>'+
'</div>'+
'<div data-dte-e="field-processing" class="'+classes.processing+'"><span></span></div>'+
'</div>');var input=this._typeFn('create',opts);var side=null;if(input&&input.side){side=input.side;input=input.input;}
if(input!==null){el('input-control',template).prepend(input);}
else{template.css('display',"none");}
this.dom={container:template,inputControl:el('input-control',template),label:el('label',template).append(side),fieldInfo:el('msg-info',template),labelInfo:el('msg-label',template),fieldError:el('msg-error',template),fieldMessage:el('msg-message',template),multi:el('multi-value',template),multiReturn:el('msg-multi',template),multiInfo:el('multi-info',template),processing:el('field-processing',template)};this.dom.multi.on('click',function(){if(that.s.opts.multiEditable&&!template.hasClass(classes.disabled)&&opts.type!=='readonly'){that.val('');that.focus();}});this.dom.multiReturn.on('click',function(){that.multiRestore();});$.each(this.s.type,function(name,fn){if(typeof fn==='function'&&that[name]===undefined){that[name]=function(){var args=Array.prototype.slice.call(arguments);args.unshift(name);var ret=that._typeFn.apply(that,args);return ret===undefined?that:ret;};}});}
Field.prototype.def=function(set){var opts=this.s.opts;if(set===undefined){var def=opts['default']!==undefined?opts['default']:opts.def;return typeof def==='function'?def():def;}
opts.def=set;return this;};Field.prototype.disable=function(){this.dom.container.addClass(this.s.classes.disabled);this._typeFn('disable');return this;};Field.prototype.displayed=function(){var container=this.dom.container;return container.parents('body').length&&container.css('display')!='none'?true:false;};Field.prototype.enable=function(toggle){if(toggle===void 0){toggle=true;}
if(toggle===false){return this.disable();}
this.dom.container.removeClass(this.s.classes.disabled);this._typeFn('enable');return this;};Field.prototype.enabled=function(){return this.dom.container.hasClass(this.s.classes.disabled)===false;};Field.prototype.error=function(msg,fn){var classes=this.s.classes;if(msg){this.dom.container.addClass(classes.error);}
else{this.dom.container.removeClass(classes.error);}
this._typeFn('errorMessage',msg);return this._msg(this.dom.fieldError,msg,fn);};Field.prototype.fieldInfo=function(msg){return this._msg(this.dom.fieldInfo,msg);};Field.prototype.isMultiValue=function(){return this.s.multiValue&&this.s.multiIds.length!==1;};Field.prototype.inError=function(){return this.dom.container.hasClass(this.s.classes.error);};Field.prototype.input=function(){return this.s.type.input?this._typeFn('input'):$('input, select, textarea',this.dom.container);};Field.prototype.focus=function(){if(this.s.type.focus){this._typeFn('focus');}
else{$('input, select, textarea',this.dom.container).focus();}
return this;};Field.prototype.get=function(){if(this.isMultiValue()){return undefined;}
return this._format(this._typeFn('get'),this.s.opts.getFormatter);};Field.prototype.hide=function(animate){var el=this.dom.container;if(animate===undefined){animate=true;}
if(this.s.host.display()&&animate&&$.fn.slideUp){el.slideUp();}
else{el.css('display','none');}
return this;};Field.prototype.label=function(str){var label=this.dom.label;var labelInfo=this.dom.labelInfo.detach();if(str===undefined){return label.html();}
label.html(str);label.append(labelInfo);return this;};Field.prototype.labelInfo=function(msg){return this._msg(this.dom.labelInfo,msg);};Field.prototype.message=function(msg,fn){return this._msg(this.dom.fieldMessage,msg,fn);};Field.prototype.multiGet=function(id){var value;var multiValues=this.s.multiValues;var multiIds=this.s.multiIds;var isMultiValue=this.isMultiValue();if(id===undefined){var fieldVal=this.val();value={};for(var i=0;i<multiIds.length;i++){value[multiIds[i]]=isMultiValue?multiValues[multiIds[i]]:fieldVal;}}
else if(isMultiValue){value=multiValues[id];}
else{value=this.val();}
return value;};Field.prototype.multiRestore=function(){this.s.multiValue=true;this._multiValueCheck();};Field.prototype.multiSet=function(id,val){var that=this;var multiValues=this.s.multiValues;var multiIds=this.s.multiIds;if(val===undefined){val=id;id=undefined;}
var set=function(idSrc,val){if($.inArray(idSrc,multiIds)===-1){multiIds.push(idSrc);}
multiValues[idSrc]=that._format(val,that.s.opts.setFormatter);};if($.isPlainObject(val)&&id===undefined){$.each(val,function(idSrc,innerVal){set(idSrc,innerVal);});}
else if(id===undefined){$.each(multiIds,function(i,idSrc){set(idSrc,val);});}
else{set(id,val);}
this.s.multiValue=true;this._multiValueCheck();return this;};Field.prototype.name=function(){return this.s.opts.name;};Field.prototype.node=function(){return this.dom.container[0];};Field.prototype.nullDefault=function(){return this.s.opts.nullDefault;};Field.prototype.processing=function(set){if(set===undefined){return this.s.processing;}
this.dom.processing.css('display',set?'block':'none');this.s.processing=set;this.s.host.internalEvent('processing-field',[set]);return this;};Field.prototype.set=function(val,multiCheck){if(multiCheck===void 0){multiCheck=true;}
var decodeFn=function(d){return typeof d!=='string'?d:d.replace(/&gt;/g,'>').replace(/&lt;/g,'<').replace(/&amp;/g,'&').replace(/&quot;/g,'"').replace(/&#163;/g,'£').replace(/&#39;/g,'\'').replace(/&#10;/g,'\n');};this.s.multiValue=false;var decode=this.s.opts.entityDecode;if(decode===undefined||decode===true){if(Array.isArray(val)){for(var i=0,ien=val.length;i<ien;i++){val[i]=decodeFn(val[i]);}}
else{val=decodeFn(val);}}
if(multiCheck===true){val=this._format(val,this.s.opts.setFormatter);this._typeFn('set',val);this._multiValueCheck();}
else{this._typeFn('set',val);}
return this;};Field.prototype.show=function(animate,toggle){if(animate===void 0){animate=true;}
if(toggle===void 0){toggle=true;}
if(toggle===false){return this.hide(animate);}
var el=this.dom.container;if(this.s.host.display()&&animate&&$.fn.slideDown){el.slideDown();}
else{el.css('display','');}
return this;};Field.prototype.update=function(options,append){if(append===void 0){append=false;}
if(this.s.type.update){this._typeFn('update',options,append);}
return this;};Field.prototype.val=function(val){return val===undefined?this.get():this.set(val);};Field.prototype.compare=function(value,original){var compare=this.s.opts.compare||deepCompare;return compare(value,original);};Field.prototype.dataSrc=function(){return this.s.opts.data;};Field.prototype.destroy=function(){this.dom.container.remove();this._typeFn('destroy');return this;};Field.prototype.multiEditable=function(){return this.s.opts.multiEditable;};Field.prototype.multiIds=function(){return this.s.multiIds;};Field.prototype.multiInfoShown=function(show){this.dom.multiInfo.css({display:show?'block':'none'});};Field.prototype.multiReset=function(){this.s.multiIds=[];this.s.multiValues={};};Field.prototype.submittable=function(){return this.s.opts.submit;};Field.prototype._errorNode=function(){return this.dom.fieldError;};Field.prototype._format=function(val,formatter){if(formatter){if(Array.isArray(formatter)){var args=formatter.slice();var name=args.shift();formatter=Field.formatters[name].apply(this,args);}
return formatter.call(this.s.host,val,this);}
return val;};Field.prototype._msg=function(el,msg,fn){if(msg===undefined){return el.html();}
if(typeof msg==='function'){var editor=this.s.host;msg=msg(editor,new DataTable$1.Api(editor.internalSettings().table));}
if(el.parent().is(":visible")&&$.fn.animate){el.html(msg);if(msg){el.slideDown(fn);}
else{el.slideUp(fn);}}
else{el.html(msg||'').css('display',msg?'block':'none');if(fn){fn();}}
return this;};Field.prototype._multiValueCheck=function(){var last;var ids=this.s.multiIds;var values=this.s.multiValues;var isMultiValue=this.s.multiValue;var isMultiEditable=this.s.opts.multiEditable;var val;var different=false;if(ids){for(var i=0;i<ids.length;i++){val=values[ids[i]];if(i>0&&!deepCompare(val,last)){different=true;break;}
last=val;}}
if((different&&isMultiValue)||(!isMultiEditable&&this.isMultiValue())){this.dom.inputControl.css({display:'none'});this.dom.multi.css({display:'block'});}
else{this.dom.inputControl.css({display:'block'});this.dom.multi.css({display:'none'});if(isMultiValue&&!different){this.set(last,false);}}
this.dom.multiReturn.css({display:ids&&ids.length>1&&different&&!isMultiValue?'block':'none'});var i18n=this.s.host.internalI18n().multi;this.dom.multiInfo.html(isMultiEditable?i18n.info:i18n.noMulti);this.dom.multi.toggleClass(this.s.classes.multiNoEdit,!isMultiEditable);this.s.host.internalMultiInfo();return true;};Field.prototype._typeFn=function(name){var args=[];for(var _i=1;_i<arguments.length;_i++){args[_i-1]=arguments[_i];}
args.unshift(this.s.opts);var fn=this.s.type[name];if(fn){return fn.apply(this.s.host,args);}};Field.defaults=defaults;Field.formatters={};return Field;}());var button={action:null,className:null,tabIndex:0,text:null,};var displayController={close:function(){},init:function(){},open:function(){},node:function(){}};var DataTable=$.fn.dataTable;var apiRegister=DataTable.Api.register;function __getInst(api){var ctx=api.context[0];return ctx.oInit.editor||ctx._editor;}
function __setBasic(inst,opts,type,plural){if(!opts){opts={};}
if(opts.buttons===undefined){opts.buttons='_basic';}
if(opts.title===undefined){opts.title=inst.i18n[type].title;}
if(opts.message===undefined){if(type==='remove'){var confirm=inst.i18n[type].confirm;opts.message=plural!==1?confirm._.replace(/%d/,plural):confirm['1'];}
else{opts.message='';}}
return opts;}
apiRegister('editor()',function(){return __getInst(this);});apiRegister('row.create()',function(opts){var inst=__getInst(this);inst.create(__setBasic(inst,opts,'create'));return this;});apiRegister('row().edit()',function(opts){var inst=__getInst(this);inst.edit(this[0][0],__setBasic(inst,opts,'edit'));return this;});apiRegister('rows().edit()',function(opts){var inst=__getInst(this);inst.edit(this[0],__setBasic(inst,opts,'edit'));return this;});apiRegister('row().delete()',function(opts){var inst=__getInst(this);inst.remove(this[0][0],__setBasic(inst,opts,'remove',1));return this;});apiRegister('rows().delete()',function(opts){var inst=__getInst(this);inst.remove(this[0],__setBasic(inst,opts,'remove',this[0].length));return this;});apiRegister('cell().edit()',function(type,opts){if(!type){type='inline';}
else if($.isPlainObject(type)){opts=type;type='inline';}
__getInst(this)[type](this[0][0],opts);return this;});apiRegister('cells().edit()',function(opts){__getInst(this).bubble(this[0],opts);return this;});apiRegister('file()',file);apiRegister('files()',files);$(document).on('xhr.dt',function(e,ctx,json){if(e.namespace!=='dt'){return;}
if(json&&json.files){$.each(json.files,function(name,files){if(!Editor.files[name]){Editor.files[name]={};}
$.extend(Editor.files[name],files);});}});var _buttons=$.fn.dataTable.ext.buttons;$.extend(_buttons,{create:{text:function(dt,node,config){return dt.i18n('buttons.create',config.editor.i18n.create.button);},className:'buttons-create',editor:null,formButtons:{text:function(editor){return editor.i18n.create.submit;},action:function(e){this.submit();}},formMessage:null,formOptions:{},formTitle:null,action:function(e,dt,node,config){var that=this;var editor=config.editor;this.processing(true);editor.one('preOpen',function(){that.processing(false);}).create($.extend({buttons:config.formButtons,message:config.formMessage||editor.i18n.create.message,title:config.formTitle||editor.i18n.create.title,nest:true,},config.formOptions));}},createInline:{text:function(dt,node,config){return dt.i18n('buttons.create',config.editor.i18n.create.button);},className:'buttons-create',editor:null,formButtons:{text:function(editor){return editor.i18n.create.submit;},action:function(e){this.submit();}},formOptions:{},action:function(e,dt,node,config){config.editor.inlineCreate(config.position,config.formOptions);},position:'start'},edit:{extend:'selected',text:function(dt,node,config){return dt.i18n('buttons.edit',config.editor.i18n.edit.button);},className:'buttons-edit',editor:null,formButtons:{text:function(editor){return editor.i18n.edit.submit;},action:function(e){this.submit();}},formMessage:null,formOptions:{},formTitle:null,action:function(e,dt,node,config){var that=this;var editor=config.editor;var rows=dt.rows({selected:true}).indexes();var columns=dt.columns({selected:true}).indexes();var cells=dt.cells({selected:true}).indexes();var items=columns.length||cells.length?{rows:rows,columns:columns,cells:cells}:rows;this.processing(true);editor.one('preOpen',function(){that.processing(false);}).edit(items,$.extend({buttons:config.formButtons,message:config.formMessage||editor.i18n.edit.message,title:config.formTitle||editor.i18n.edit.title,nest:true,},config.formOptions));}},remove:{extend:'selected',limitTo:['rows'],text:function(dt,node,config){return dt.i18n('buttons.remove',config.editor.i18n.remove.button);},className:'buttons-remove',editor:null,formButtons:{text:function(editor){return editor.i18n.remove.submit;},action:function(e){this.submit();}},formMessage:function(editor,dt){var rows=dt.rows({selected:true}).indexes();var i18n=editor.i18n.remove;var question=typeof i18n.confirm==='string'?i18n.confirm:i18n.confirm[rows.length]?i18n.confirm[rows.length]:i18n.confirm._;return question.replace(/%d/g,rows.length);},formOptions:{},formTitle:null,action:function(e,dt,node,config){var that=this;var editor=config.editor;this.processing(true);editor.one('preOpen',function(){that.processing(false);}).remove(dt.rows({selected:true}).indexes(),$.extend({buttons:config.formButtons,message:config.formMessage,title:config.formTitle||editor.i18n.remove.title,nest:true,},config.formOptions));}}});_buttons.editSingle=$.extend({},_buttons.edit);_buttons.editSingle.extend='selectedSingle';_buttons.removeSingle=$.extend({},_buttons.remove);_buttons.removeSingle.extend='selectedSingle';var Editor=(function(){function Editor(init){var _this=this;this.add=add;this.ajax=ajax;this.background=background;this.blur=blur;this.bubble=bubble;this.bubblePosition=bubblePosition;this.buttons=buttons;this.clear=clear;this.close=close;this.create=create;this.undependent=undependent;this.dependent=dependent;this.destroy=destroy;this.disable=disable;this.display=display;this.displayed=displayed;this.displayNode=displayNode;this.edit=edit;this.enable=enable;this.error=error$1;this.field=field;this.fields=fields;this.file=file;this.files=files;this.get=get;this.hide=hide;this.ids=ids;this.inError=inError;this.inline=inline;this.inlineCreate=inlineCreate;this.message=message;this.mode=mode;this.modifier=modifier;this.multiGet=multiGet;this.multiSet=multiSet;this.node=node;this.off=off;this.on=on;this.one=one;this.open=open;this.order=order;this.remove=remove;this.set=set;this.show=show;this.submit=submit;this.table=table;this.template=template;this.title=title;this.val=val;this._actionClass=_actionClass;this._ajax=_ajax;this._animate=_animate;this._assembleMain=_assembleMain;this._blur=_blur;this._clearDynamicInfo=_clearDynamicInfo;this._close=_close;this._closeReg=_closeReg;this._crudArgs=_crudArgs;this._dataSource=_dataSource;this._displayReorder=_displayReorder;this._edit=_edit;this._event=_event;this._eventName=_eventName;this._fieldFromNode=_fieldFromNode;this._fieldNames=_fieldNames;this._focus=_focus;this._formOptions=_formOptions;this._inline=_inline;this._optionsUpdate=_optionsUpdate;this._message=_message;this._multiInfo=_multiInfo;this._nestedClose=_nestedClose;this._nestedOpen=_nestedOpen;this._postopen=_postopen;this._preopen=_preopen;this._processing=_processing;this._noProcessing=_noProcessing;this._submit=_submit;this._submitTable=_submitTable;this._submitSuccess=_submitSuccess;this._submitError=_submitError;this._tidy=_tidy;this._weakInArray=_weakInArray;if(!(this instanceof Editor)){alert("DataTables Editor must be initialised as a 'new' instance");}
init=$.extend(true,{},Editor.defaults,init);this.s=$.extend(true,{},Editor.models.settings,{actionName:init.actionName,table:init.domTable||init.table,ajax:init.ajax,idSrc:init.idSrc,formOptions:init.formOptions,template:init.template?$(init.template).detach():null});this.classes=$.extend(true,{},Editor.classes);this.i18n=init.i18n;Editor.models.settings.unique++;var that=this;var classes=this.classes;var wrapper=$('<div class="'+classes.wrapper+'">'+
'<div data-dte-e="processing" class="'+classes.processing.indicator+'"><span></span></div>'+
'<div data-dte-e="body" class="'+classes.body.wrapper+'">'+
'<div data-dte-e="body_content" class="'+classes.body.content+'"></div>'+
'</div>'+
'<div data-dte-e="foot" class="'+classes.footer.wrapper+'">'+
'<div class="'+classes.footer.content+'"></div>'+
'</div>'+
'</div>');var form=$('<form data-dte-e="form" class="'+classes.form.tag+'">'+
'<div data-dte-e="form_content" class="'+classes.form.content+'"></div>'+
'</form>');this.dom={wrapper:wrapper[0],form:form[0],formError:$('<div data-dte-e="form_error" class="'+classes.form.error+'"></div>')[0],formInfo:$('<div data-dte-e="form_info" class="'+classes.form.info+'"></div>')[0],header:$('<div data-dte-e="head" class="'+classes.header.wrapper+'"><div class="'+classes.header.content+'"></div></div>')[0],buttons:$('<div data-dte-e="form_buttons" class="'+classes.form.buttons+'"></div>')[0],formContent:el('form_content',form)[0],footer:el('foot',wrapper)[0],body:el('body',wrapper)[0],bodyContent:el('body_content',wrapper)[0],processing:el('processing',wrapper)[0],};$.each(init.events,function(evt,fn){that.on(evt,function(){var args=Array.prototype.slice.call(arguments);args.shift();fn.apply(that,args);});});this.dom;var table$1=this.s.table;if(init.fields){this.add(init.fields);}
$(document).on('init.dt.dte'+this.s.unique,function(e,settings,json){if(_this.s.table&&settings.nTable===$(table$1)[0]){settings._editor=_this;}}).on('i18n.dt.dte'+this.s.unique,function(e,settings){if(_this.s.table&&settings.nTable===$(table$1)[0]){if(settings.oLanguage.editor){$.extend(true,_this.i18n,settings.oLanguage.editor);}}}).on('xhr.dt.dte'+this.s.unique,function(e,settings,json){if(json&&_this.s.table&&settings.nTable===$(table$1)[0]){_this._optionsUpdate(json);}});if(!Editor.display[init.display]){throw new Error('Cannot find display controller '+init.display);}
this.s.displayController=Editor.display[init.display].init(this);this._event('initComplete',[]);$(document).trigger('initEditor',[this]);}
Editor.prototype.internalEvent=function(name,args){this._event(name,args);};Editor.prototype.internalI18n=function(){return this.i18n;};Editor.prototype.internalMultiInfo=function(){return this._multiInfo();};Editor.prototype.internalSettings=function(){return this.s;};Editor.fieldTypes={checkbox:checkbox,datatable:datatable,datetime:datetime,hidden:hidden,password:password,radio:radio,readonly:readonly,select:select,text:text,textarea:textarea,upload:upload,uploadMany:uploadMany};Editor.files={};Editor.version='2.0.4';Editor.classes=classNames;Editor.Field=Field;Editor.DateTime=null;Editor.error=error;Editor.pairs=pairs;Editor.safeId=function(id){return safeDomId(id,'');};Editor.upload=upload$1;Editor.defaults=defaults$1;Editor.models={button:button,displayController:displayController,fieldType:fieldType,formOptions:formOptions,settings:settings,};Editor.dataSources={dataTable:dataSource$1,html:dataSource,};Editor.display={envelope:envelope,lightbox:self,};return Editor;}());DataTable.Editor=Editor;$.fn.DataTable.Editor=Editor;if(DataTable.DateTime){Editor.DateTime=DataTable.DateTime;}
if(DataTable.ext.editorFields){$.extend(Editor.fieldTypes,DataTable.ext.editorFields);}
DataTable.ext.editorFields=Editor.fieldTypes;return Editor;}));