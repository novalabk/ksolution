<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%

	String code = request.getParameter("code");
	String infoId = request.getParameter("infoId");
	request.setAttribute("code", code);
	request.setAttribute("infoId", infoId);
	
%>
<ax:set key="system-auth-user-version" value="1.0.0"/>
<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" var="LANG" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/material/select-material-list.js' />"></script>
    </jsp:attribute>
    <jsp:body>
		<input type="hidden" id="infoId" value="${infoId }">
		<input type="hidden" id="code" value="${code }">
        <ax:page-buttons>
        	<button type="button" class="btn btn-fn1" data-page-btn="choice"><ax:lang id="ax.admin.sample.modal.button.choice"/></button>
        </ax:page-buttons>

        <!-- 검색바 -->
        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="900px">
                    <ax:tr>
                        <ax:td label="일련 번호" width="300px">
                            <input type="text" data-ax-path="seqNumber" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td>
                          <ax:td label="소비자가" width="300px">
                                <input type="text" data-ax-path="price1" class="form-control inline-block W80"  data-ax5formatter="money"/>~
                                <input type="text" data-ax-path="price2" class="form-control inline-block W80"  data-ax5formatter="money"/>  
                            </ax:td>  
                            
                        <ax:td label="브랜드" width="300px">
                            <input type="text" data-ax-path="brand" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td>
                        <ax:td label="분류" width="600px"> 
                        
                        <select class="form-control inline-block W160" id="level1" data-ax-path="level1"></select>
                        <select class="form-control inline-block W160" id="level2" data-ax-path="level2"></select>
                        <select class="form-control inline-block W160" id="level3" data-ax-path="level3"></select>
                              
                       </ax:td>
                       
                        <ax:td label="제조사" width="300px"> 
                            <input type="text" data-ax-path="mfCompany" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td> 
                    </ax:tr>
                    <ax:tr>
                        <ax:td label="유통사" width="300px">
                            <input type="text" data-ax-path="disCompany"" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td>
                        <ax:td label="규격" width="300px">
                            <input type="text" data-ax-path="specName" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td>
                        <ax:td label="원산지" width="300px">
                            <input type="text" data-ax-path="location" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td> 
                    </ax:tr>
                   
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>
        <div data-thumbview style="position:absolute;border:1px solid black;display:none;z-index:99999999999999999;"></div>
        <ax:split-layout name="ax1" orientation="vertical">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>
                            <ax:lang id="ax.admin.user.title"/>
                        </h2>
                    </div>
                    <div class="right"></div>
                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height:300px;"></div>
        </ax:split-layout>
    </jsp:body>
</ax:layout>