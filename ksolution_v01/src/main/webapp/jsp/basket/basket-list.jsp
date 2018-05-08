<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<%

	String menuId = request.getParameter("menuId");
	request.setAttribute("menuId", menuId);

%>

<ax:set key="system-auth-user-version" value="1.0.0"/>
<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="js">
	  <script type="text/javascript" src="/assets/plugins/select2-4.0.3/dist/js/select2.min.js"></script>
    </jsp:attribute>
    <jsp:attribute name="css">
       	 <link href="/assets/plugins/select2-4.0.3/dist/css/select2.min.css" rel="stylesheet" />
    </jsp:attribute>
    
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" var="LANG" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/basket/basketl-list.js' />"></script>
        
        <script type="text/javascript">
	        $(document.body).ready(function(){
	     	   fnObj.menuId = ${menuId };
	        });
        </script>
    
    </jsp:attribute>
     <jsp:body>

        <ax:page-buttons></ax:page-buttons>

        <!-- 검색바 --> 
        <%-- <div role="page-header">
            <ax:form name="searchView0"> 
                <ax:tbl clazz="ax-search-tbl" >
               
                    <ax:tr>
                            <ax:td label="ax.admin.sample.form.code" width="100%">
                               <ax:folderSelect id="folderOid"  emptyText="전체" style="width:200px"/>
                                <button class="btn btn-default" data-form-view-01-btn="folder"  style="margin-left:10px"><i class="cqc-magnifier"></i>폴더 생성</button>
                            </ax:td>
                        </ax:tr>
                    
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div> --%>
		
		<div data-thumbview style="position:absolute;border:1px solid black;display:none;z-index:99999999999999999;"></div>
        <ax:split-layout name="ax1" orientation="vertical">
        
        <ax:split-panel width="20%" style="padding-right: 10px;">
           <div class="ax-button-group" data-fit-height-aside="tree-view-01">
                    <div class="left">
                        <h2>
                            <i class="cqc-list"></i>폴더 리스트</h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-default" data-form-view-01-btn="folder"><i class="cqc-circle-with-plus"></i>폴더편집</button>
                    </div>
                </div>
           <div data-ax5grid="grid-view-folder" data-fit-height-content="grid-view-folder" style="height: 300px;"></div>
        </ax:split-panel>
        <ax:splitter></ax:splitter>
        
         <ax:split-panel width="*" style="padding-left: 10px;" scroll="scroll">
        
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>자재리스트
                        </h2>
                    </div>
                    <div class="right"><button type="button" class="btn btn-default" data-grid-view-01-btn="delete"><i class="cqc-circle-with-minus"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div>
                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>
        	</ax:split-panel>
        </ax:split-layout>
    </jsp:body>
</ax:layout>