<%@page import="com.boot.ksolution.core.utils.RequestUtils"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<% 
	
	RequestUtils requestUtils = RequestUtils.of(request);
	requestUtils.setAttribute("masterId", requestUtils.getLong("masterId"));

	

%>

<ax:set key="title" value="${pageName}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
	
	
	<jsp:attribute name="css">
		<link rel="stylesheet" href="<c:url value='/webjars/font-awesome/5.0.6/web-fonts-with-css/css/fontawesome-all.min.css'/>"/>
    </jsp:attribute>

    <jsp:attribute name="script">
        <script type="text/javascript">
        var fnObj = { masterId : ${masterId} };
        
        var ACTIONS = axboot.actionExtend(fnObj, {
        	
        	GET_uploaded : function(caller, act, data){
        		//alert(caller.masterId);
            	var sendData = {masterId : caller.masterId};
            	
            	console.log("sendData", sendData);
            	axboot.ajax({
            		type: "GET", 
                    url: ["files", "versionList"], 
                    data: sendData,
                    callback: function (res) {
                    	
                    	caller.fileGrid.setData(res.list);
                    } 
                });
            },
        	
        	dispatch: function (caller, act, data) {
                var result = ACTIONS.exec(caller, act, data);
                if (result != "error") {
                    return result;
                } else {
                    // 직접코딩
                    return false;
                }
            }
        });
        
        fnObj.pageStart = function () {
        	
        	 var _this = this;
        	 _this.fileGrid.initView();
        	 ACTIONS.dispatch(ACTIONS.GET_uploaded);
        	/* console.log("initData", initData);
        	
        	var target = $("#formView01");
       	 
       	 	var name = target.find('[data-ax-path="' + "name" + '"]').val(initData.prj_name);
       		var desc = target.find('[data-ax-path="' + "desc" + '"]').val(initData.desc); */
        }
        
        
        fnObj.fileGrid =  axboot.viewExtend(axboot.gridView, {
        	initView: function(){
        		var _this = this;
        		this.target = axboot.gridBuilder({
                    target: $('[data-ax5grid="first-grid'),
                    columns: [
                        {key: "fileNm", label: "fileName", width: 200},
                        {key: "versionIndex", label: "V",  align: "center",  width: 50},
                        
                        {key: "fileSize", label: "fileSize", align: "right", formatter: function () {
                            return ax5.util.number(this.value, {byte: true});
                        }},
                        /* {key: "extension", label: "ext", align: "center", width: 60}, */
                        {key: "generatedcreatedAt", label: "createdAt", align: "center", width: 140, formatter: function () {
                            return ax5.util.date(this.value, {"return": "yyyy/MM/dd hh:mm:ss"});
                        }}, 
                        {key: "creatorNm", label: "creator", align: "center", width: 100},
                        {key: "download", label: "down", width: 60, align: "center", formatter: function () {
                            return '<i class="fa fa-download" aria-hidden="true"></i>'
                        }}
                    ],
                    body: {
                        onClick: function () {
                            if(this.column.key == "download" && this.item.download){
                            	//alert(CONTEXT_PATH + this.item.download);
                                location.href = CONTEXT_PATH + this.item.download;
                            } 
                        }
                    }
        		});
        	},
        
        	
        	setData : function(data){
        		var _this = this;
        		_this.target.setData(data);
        	}
        });
        
        
        
        </script>
    </jsp:attribute>
	   	
	<jsp:body>
	
	
		
			
		<ax:split-layout name="ax1" orientation="horizontal">
            <ax:split-panel width="*" style="">

                <!-- 목록 -->
                <%-- <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2>
                            <i class="cqc-list"></i>
                            <ax:lang id="ks.Msg.10"/>
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-default" data-grid-view-01-btn="add"><i class="cqc-circle-with-plus"></i> <ax:lang id="ax.admin.add"/></button>
                        <button type="button" class="btn btn-default" data-grid-view-01-btn="delete"><i class="cqc-circle-with-minus"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div> --%>
                <div id="fileList" data-ax5grid="first-grid" data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: false,
					                    multipleSelect: true,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					    }" style="height:380px;"></div>   
                 </div>

            </ax:split-panel>
        </ax:split-layout>
        
	</jsp:body>
</ax:layout>