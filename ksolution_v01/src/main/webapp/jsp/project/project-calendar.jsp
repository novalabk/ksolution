<%@page import="com.boot.ksolution.core.utils.RequestUtils"%>
<%@page import="com.ksolution.common.domain.gantt.output.PJTFolder"%>
<%@page import="com.ksolution.common.domain.file.CommonFileService"%>
<%@page import="com.ksolution.common.domain.file.CommonFile"%>
<%@page import="com.boot.ksolution.core.context.AppContextManager"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags"%>
<%
	RequestUtils requestUtils = RequestUtils.of(request);
    String targetType = AppContextManager.getBean(CommonFileService.class).getTargetType(PJTFolder.class);
	requestUtils.setAttribute("targetType", targetType);
	
	String oid = requestUtils.getString("oid", "");
	
	requestUtils.setAttribute("oid", oid);

%>
<ax:set key="page_auto_height" value="true" />
<ax:layout name="base" title=""> 
<jsp:attribute name="css">
<link rel="stylesheet" href="<c:url value='/jsp/project/assets/project_style.css'/>"/>  	
<link href="<c:url value='/fullcalendar-3.9.0/fullcalendar.min.css'/>" rel="stylesheet" />
<link href="<c:url value='/fullcalendar-3.9.0/fullcalendar.print.min.css'/>" rel="stylesheet" media="print" />
<link href="<c:url value='/assets/css/axboot.css'/>" rel="stylesheet" />	
	 
	<style type="text/css">
        		
	    .nav-tabs>li.active>a, 
		.nav-tabs>li.active>a:hover, 
		.nav-tabs>li.active>a:focus {
    		color: #fff;
    		background-color: #485398;
    		border: 1px solid #485398;
    		border-bottom-color: transparent;
    		cursor: default;
		}
		
		body {
    		font-family: "Noto Sans Korean","Helvetica Neue",Helvetica,Arial,sans-serif;
  			font-size: 13px;
    		line-height: 1.42857;
    		color: #333;
     		background-color: #ECF0F5; 
		}
		
	    #calendar {
   
		   margin: 0 auto;
	    } 
		 
	   #script-warning {
		    display: none;
		    background: #eee;
		    border-bottom: 1px solid #ddd;
		    padding: 0 10px;
		    line-height: 40px;
		    text-align: center;
		    font-weight: bold;
		    font-size: 12px;
		    color: red;
	   }
	
	  
	 </style>  

</jsp:attribute>

 
<jsp:attribute name="script">
	<ax:script-lang key="ax.script" var="LANG"/>
	<ax:script-lang key="ks.Msg" var="MSG"/>
	<ax:script-lang key="ax.admin" var="COL" />
	<script type="text/javascript" src="<c:url value='/assets/js/axboot/project/project-calendar.js' />"></script>
	<script src="<c:url value='/fullcalendar-3.9.0/lib/moment.min.js'/>"></script>
	<script src="<c:url value='/fullcalendar-3.9.0/fullcalendar.min.js'/>"></script>
	<script src="<c:url value='/fullcalendar-3.9.0/locale-all.js'/>"></script>
</jsp:attribute>

<jsp:body>

   <!-- <div id="main"  > -->
   
    <div id="main"  > 
	 <div role="tabpanel" id="main_top">
			<ul class="nav nav-tabs" role="tablist">
			   
			
			<li role="presentation" class="text-center tab-menu-btn">
			<a href="<c:url value='/jsp/project/gantt-save.jsp'/>?oid=${oid}&tab=task" role="tab" ><ax:lang id="ks.Msg.1"/></a> <!--작성 -->
			</li>

			<li role="presentation" class="text-center tab-menu-btn">
			<a href="<c:url value='/jsp/project/gantt-save.jsp'/>?oid=${oid}&tab=view" role="tab"><ax:lang id="ks.Msg.2"/></a> <!--보기 -->
			</li> 

			<li role="presentation" class="text-center tab-menu-btn"> 
			<a href="<c:url value='/jsp/project/project-out.jsp'/>?oid=${oid}" role="tab" ><ax:lang id="ks.Msg.3"/></a><!-- 산출물 -->
			</li>
			
			<li role="presentation" class="active text-center tab-menu-btn"> 
			<a href="<c:url value='/jsp/project/project-calendar.jsp'/>?oid=${oid}" role="tab" ><ax:lang id="ks.Msg.44"/></a><!-- 휴일관리 -->
			</li>
			
			</ul> 	
     </ul>
     <div class="H5"></div>
   <ax:form name="searchView0"> 
   <input type="hidden" name="oid" data-ax-path="oid"  value="${oid}" /> <!-- ${param.oid} -->
   </ax:form> 
   <ax:split-layout name="ax1" orientation="vertical">
       <%-- <ax:split-panel width="40%" style="padding-right: 10px;">

           <!-- 목록 -->
           <div class="ax-button-group" data-fit-height-aside="grid-view-01">
               <div class="left">
                   <h2><i class="cqc-list"></i>
                       <ax:lang id="ax.admin.user.title"/>
                   </h2>
               </div>
               <div class="right">
                   <button type="button" class="btn btn-default" data-form-view-01-btn="create">
                       <i class="cqc-erase"></i>
                       <ax:lang id="ks.Msg.43"/>
                   </button>
               </div>
           </div>
           <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

        </ax:split-panel>
      <ax:splitter></ax:splitter> --%>

	   <ax:split-panel width="*" style="padding-left: 10px;" scroll="scroll">
  			<div id='script-warning'>
  			</div>
  			<div id='calendar'></div>
  		</ax:split-panel>
</ax:split-layout>

	
</jsp:body>

</ax:layout>