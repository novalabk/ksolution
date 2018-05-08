<%@ page import="com.chequer.axboot.core.utils.RequestUtils" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>
<%

%>

<ax:set key="title" value="${pageName}"/>
<ax:set key="page_auto_height" value="true"/>


<ax:layout name="modal">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/basket/folderCreate.js' />"></script>
    </jsp:attribute>
    
  

    
    <jsp:body>
         
   

        <%-- <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='ax.admin.sample.search.condition' width="300px">
                            <input type="text" class="form-control"/>
                        </ax:td> 
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div> --%>

        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="*" style="padding-right: 0px;">

                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>
                            List </h2>
                    </div>
                    <div class="right">
						<button type="button" class="btn btn-default" data-grid-view-01-btn="add">Add</button>
			            <button type="button" class="btn btn-info" data-grid-view-01-btn="delete">Delete</button>
			            <button type="button" class="btn btn-fn1" data-grid-view-01-btn="save">Save</button>
                    </div>
                </div> 

                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>