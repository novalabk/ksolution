<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<ax:set key="system-auth-user-version" value="1.0.0"/>
<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" var="LANG" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='js/page-structure.js' />"></script>
    </jsp:attribute>
    <jsp:body>

        <ax:page-buttons></ax:page-buttons>

        <!-- 검색바 -->
        
        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='메뉴그룹' width="300px">
                            <ax:common-code groupCd="USER_ROLE" id="menuGrpCd"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>
        
        
         <!-- role="page-header" 높이를 뺀 나머지 높이를 role="page-content" 가 차지하게 됩니다 -->
        <div role="page-content">

			<ax:split-layout name="ax1" orientation="horizontal">
			    <ax:split-panel height="300" style="padding-right: 10px;">
			        	너비가 300인 왼쪽 패널
			    </ax:split-panel>
			    <!-- splitter -->
			    <ax:splitter>
			    </ax:splitter>
			    
			    <ax:split-panel height="*" style="padding-left: 10px;" id="split-panel-form" scroll="true">
			        	너비가 나머지인 오른쪽 패널 (건텐츠의 높이가 넘칠 경우 스크롤)
			    </ax:split-panel>
			</ax:split-layout>


        </div>
        
    </jsp:body>
</ax:layout>