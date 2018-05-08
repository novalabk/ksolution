<%@ page import="com.chequer.axboot.core.utils.RequestUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%

	String code = request.getParameter("code");
	String infoId = request.getParameter("infoId");
	request.setAttribute("code", code);
	request.setAttribute("infoId", infoId);
	
%>
<ax:set key="pageName" value="File Browser"/>
<ax:set key="page_auto_height" value="true"/>
<ax:set key="axbody_class" value="baseStyle"/>

<ax:layout name="modal">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/project/project-material.js' />"></script>
    </jsp:attribute>
    <jsp:attribute name="header">
        <h1 class="title">
            <i class="cqc-browser"></i> 자재목록
        </h1>
        <input type="hidden" id="infoId" value="${infoId }">
		<input type="hidden" id="code" value="${code }">
    </jsp:attribute>
    <jsp:body>
    	<c:if test="${!empty code }">
        <ax:page-buttons>
        	일련번호 추가 : <input type="text" id="serialNo" value="">
        	<button type="button" class="btn btn-default" data-grid-view-01-btn="delete"><i class="cqc-circle-with-minus"></i> <ax:lang id="ax.admin.delete"/></button>
        	<button type="button" class="btn btn-default" data-grid-view-01-btn="material-add"><i class="cqc-circle-with-plus"></i>자재 <ax:lang id="ax.admin.add"/></button>
        	<button type="button" class="btn btn-default" data-grid-view-01-btn="basket-add"><i class="cqc-circle-with-plus"></i>즐겨찾기 <ax:lang id="ax.admin.add"/></button>
        </ax:page-buttons>
        </c:if>
        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="*" style="padding-right: 0px;">
            	<div data-thumbview style="position:absolute;border:1px solid black;display:none;z-index:99999999999999999;"></div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>
            </ax:split-panel>
        </ax:split-layout>
        
        <script>
	    	$("#serialNo").focus();
	    	$("#serialNo").keyup(function (key) {
	            if(key.keyCode == 13){//키가 13이면 실행 (엔터는 13)
	            	ACTIONS.dispatch(ACTIONS.ITEM_SERIAL_ADD);
	            	$(this).val("");
	            	$(this).focus();
	            }
	        });
	    </script>
    </jsp:body>
</ax:layout>