<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags"%>

<ax:set key="title" value="${pageName}"/> 
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:set key="page_auto_height" value="true" />
<ax:layout name="base"> 

<jsp:attribute name="css">
<link href="<c:url value='/fullcalendar-3.9.0/fullcalendar.min.css'/>" rel="stylesheet" />
<link href="<c:url value='/fullcalendar-3.9.0/fullcalendar.print.min.css'/>" rel="stylesheet" media="print" />
<link href="<c:url value='/assets/css/axboot.css'/>" rel="stylesheet" />
<style>
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
<script type="text/javascript" src="<c:url value='/assets/js/axboot/calendar/calendar.js' />"></script>
<script src="<c:url value='/fullcalendar-3.9.0/lib/moment.min.js'/>"></script>
<script src="<c:url value='/fullcalendar-3.9.0/fullcalendar.min.js'/>"></script>
<script src="<c:url value='/fullcalendar-3.9.0/locale-all.js'/>"></script>

</jsp:attribute>
<jsp:body>
<ax:page-buttons></ax:page-buttons>
<ax:split-layout name="ax1" orientation="vertical">
       <ax:split-panel width="40%" style="padding-right: 10px;">

           <!-- 목록 -->
           <div class="ax-button-group" data-fit-height-aside="grid-view-01">
               <div class="left">
                   <h2><i class="cqc-list"></i>
                       <ax:lang id="ks.Msg.45"/>
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
      <ax:splitter></ax:splitter>

	   <ax:split-panel width="*" style="padding-left: 10px;" scroll="scroll">
  			<div id='script-warning'>
  			</div>
  			<div id='calendar'></div>
  		</ax:split-panel>
</ax:split-layout>

</jsp:body> 
</ax:layout>