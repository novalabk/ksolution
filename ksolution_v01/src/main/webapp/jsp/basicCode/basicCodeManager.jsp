<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="system-config-menu-version" value="1.0.0"/>
<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/basicCode/basicCodeManager.js' />"></script>
    </jsp:attribute>
    <jsp:body>

        <ax:page-buttons></ax:page-buttons>


        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='ax.admin.menu.group' width="300px">
                            <ax:common-code groupCd="HOUSE_BASIC" id="typeCd"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>


        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="300" style="padding-right: 10px;">

                <div class="ax-button-group" data-fit-height-aside="tree-view-01">
                    <div class="left">
                        <h2>
                            <i class="cqc-list"></i>
                            <ax:lang id="ax.admin.menu.title"/> </h2>
                    </div>
                    <%-- <div class="right">
                        <button type="button" class="btn btn-default" data-tree-view-01-btn="add"><i class="cqc-circle-with-plus"></i> <ax:lang id="ax.admin.add"/></button>
                    </div> --%>
                </div>

                <div data-z-tree="tree-view-01" data-fit-height-content="tree-view-01" style="height: 300px;" class="ztree"></div>

            </ax:split-panel>
            <ax:splitter></ax:splitter>
            <ax:split-panel width="*" style="padding-left: 10px;" id="split-panel-form">

                <div data-fit-height-aside="form-view-01">
                    <div class="ax-button-group">
                        <div class="left">
                            <h2>
                                <i class="cqc-news"></i>
                                <ax:lang id="ax.admin.menu.program.setting"/> </h2>
                        </div>
                        <div class="right">

                        </div>
                    </div>

                    <ax:form name="formView01">
                        <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                            <ax:tr labelWidth="150px">
                                <ax:td label="기준코드" width="100%">
                                    <input type="text" data-ax-path="code" class="form-control" value="" />
                                </ax:td>
                                <input type="hidden" data-ax-path="codeId" class="form-control" value=""/>
                            </ax:tr>
                            <ax:tr labelWidth="150px">
                                <ax:td label="이름" width="100%">
                                <input type="text" data-ax-path="codeNm" class="form-control" value="" />
                                </ax:td>
                            </ax:tr>
                        </ax:tbl>
                    </ax:form>
                 	<div class="H20"></div>
                    <!-- 목록 -->
                    
                </div>

               

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>