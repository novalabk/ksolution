<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="system-auth-user-version" value="1.0.0"/>
<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" var="LANG" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/project/project-list.js' />"></script>
    </jsp:attribute>
    <jsp:body>

        <ax:page-buttons></ax:page-buttons>

        <!-- 검색바 -->
        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label="프로젝트명" width="300px">
                            <input type="text" data-ax-path="projectNm" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="현장주소" width="300px">
                            <input type="text" data-ax-path="address" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="공간분류" width="300px">
                            <input type="text" data-ax-path="classification" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="공사구분" width="300px">
                            <input type="text" data-ax-path="category" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                    </ax:tr>
                    <ax:tr>
                        <ax:td label="의뢰인" width="300px">
                            <input type="text" data-ax-path="clientNm" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="설계자" width="300px">
                            <input type="text" data-ax-path="designerNm" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="대리인" width="300px">
                            <input type="text" data-ax-path="fieldAgentNm" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="등록일" width="300px">
                             <div class="input-group" data-ax5picker="date">
                                <input type="text" data-ax-path="createdAt" class="form-control" placeholder="yyyy/mm/dd"/>
                                <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                            </div>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <ax:split-layout name="ax1" orientation="vertical">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>
                            ${pageName}
                        </h2>
                    </div>
                    <div class="right"></div>
                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>
        </ax:split-layout>
    </jsp:body>
</ax:layout>