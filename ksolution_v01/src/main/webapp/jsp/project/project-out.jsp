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
	
    <%-- <link rel="stylesheet" href="<c:url value='/assets/plugins/bootstrap/dist/css/bootstrap.min.css'/>"/> --%>
	<%-- <link rel="stylesheet" type="text/css" href="<c:url value='/gantt/AUIGantt/AUIGantt_style.css'/>"/> --%>
<%-- 	<link rel="stylesheet" href="<c:url value='/assets/plugins/select2-4.0.3/dist/css/select2.min.css" rel="stylesheet'/>" />
	<link rel="stylesheet" href="<c:url value='/webjars/mjolnic-bootstrap-colorpicker/2.4.0/dist/css/bootstrap-colorpicker.min.css'/>"/> --%>
    <link rel="stylesheet" href="<c:url value='/jsp/project/assets/project_style.css'/>"/>  
	<link rel="stylesheet" type="text/css" href="<c:url value='/assets/plugins/ax5ui-dialog/dist/ax5dialog.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/assets/plugins/ax5ui-uploader/dist/ax5uploader.css'/>"/>
	
	<link rel="stylesheet" href="<c:url value='/webjars/font-awesome/5.0.6/web-fonts-with-css/css/fontawesome-all.min.css'/>"/>
		 
	<link href="<c:url value='/assets/css/axboot.css'/>" rel="stylesheet" />
	<script type="text/javascript" src="<c:url value='/assets/js/axboot/project/project-output.js' />"></script>
	
	 
	<style type="text/css">
         /*leaf node 폴더로 하기 위해 */
	    .ztree li span.button.ico_docu{margin-right:2px; margin-right:2px; background-position: -147px 0; vertical-align:top; *vertical-align:middle}
		
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
		 
		/*.nav-tabs>li.active>a, 
		.nav-tabs>li.active>a:focus, 
		.nav-tabs>li.active>a:hover {
    		color: #555;
    		cursor: default;
   			background-color: #fff;
    		border: 1px solid #ddd;
    		border-bottom-color: transparent;
		}*/
	 </style>  

</jsp:attribute>

 
<jsp:attribute name="script">
	<ax:script-lang key="" /> 
    <script type="text/javascript" src="<c:url value='/gantt/AUIGantt/AUIGanttLicense.js' />"></script>
	<script type="text/javascript" src="<c:url value='/webjars/mjolnic-bootstrap-colorpicker/2.4.0/dist/js/bootstrap-colorpicker.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/assets/plugins/bootstrap/dist/js/bootstrap.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/assets/plugins/ax5ui-dialog/dist/ax5dialog.js' />"></script>
	<script type="text/javascript" src="<c:url value='/assets/plugins/ax5ui-uploader/dist/ax5uploader.js'/>"></script>
	<script type="text/javascript" src="<c:url value='/assets/plugins/ax5ui-grid/dist/ax5grid.min.js' />"></script>
	
	<script type="text/javascript">

</script>
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

			<li role="presentation" class="active text-center tab-menu-btn"> 
			<a href="<c:url value='/jsp/project/project-out.jsp'/>?oid=${oid}" role="tab" ><ax:lang id="ks.Msg.3"/></a><!-- 산출물 -->
			</li>
			
			<li role="presentation" class="text-center tab-menu-btn"> 
			<a href="<c:url value='/jsp/project/project-calendar.jsp'/>?oid=${oid}" role="tab" ><ax:lang id="ks.Msg.44"/></a><!-- 휴일관리 -->
			</li>
			</ul> 	
     </ul>
     <div class="H5"></div>
     
     <div role="page-header">
            <ax:form name="searchView0">
            	<input type="hidden" name="oid" data-ax-path="oid"  value="${oid}" /> <!-- ${param.oid} -->
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='ax.admin.search' width="100%"> 
                           <%--  <ax:common-code groupCd="MENU_GROUP" id="menuGrpCd"/> --%>
                            <div class="form-inline ax-button-group" style="min-height:20px;"> 
                                <div class="right" style="padding: 0px 0px 0px 0px"> 
                                    <input type="text" data-ax-path="searchKeyWrod" id="searchKeyWrod" class="form-control W200" value=""/>
                                    <button type="button" class="btn btn-primary" data-searchview-btn="search">
                                        <i class="cqc-magnifier"></i>
                                        <ax:lang id="ax.admin.search"/> 
                                    </button>
                                </div>
                            </div>
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
                    <div class="right">
                        <button type="button" class="btn btn-default" data-tree-view-01-btn="add"><i class="cqc-circle-with-plus"></i> <ax:lang id="ax.admin.add"/></button>
                    </div>
                </div>

                <!-- <div data-z-tree="tree-view-01" data-fit-height-content="tree-view-01" style="height: 200px;" class="ztree"></div>
				 -->
				<div id="folderList" data-z-tree="tree-view-01" style="height: 300px;" class="ztree"></div>
				
            </ax:split-panel>
            
            
            <ax:splitter></ax:splitter>
            
            <ax:split-panel width="*" style="padding-left: 10px;" id="split-panel-form">
				
				<div style="position: fixed;left:0;top:0;width:100%;height:100%;background: #ccc;z-index: 1000;display: none;opacity: 0.8;text-align: center;color: #000;" id="dragover">
				    <table width="100%" height="100%">
				        <tr>
				            <td valign="middle" align="center"><h1>Drop the file here.</h1></td>
				        </tr>
				    </table>
				</div>
 
				<div class="ax-button-group" data-fit-height-aside="tree-view-01">
                    <div class="left">
                       <div data-ax5uploader="upload1" data-btn-wrap>
                        <input type="hidden" name="targetId"  data-ax-path="targetId" value="" />
                        <input type="hidden" name="targetType" data-ax-path="targetType" value="${targetType}"/>
                        
				    	<button  data-ax5uploader-button="selector" class="btn btn-default" ><i class="cqc-plus"></i>Select File (*/*)</button>
				   		 (Upload Max fileSize 20MB)
						</div>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-default" data-page-btn="delete"><i class="cqc-circle-with-plus"></i> <ax:lang id="ax.admin.delete"/></button>
                    </div> 
                </div>
				
                <div data-fit-height-aside="form-view-01">
                    
                    <div id="fileList" data-ax5grid="first-grid" data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: true,
					                    multipleSelect: true,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					                }" style="height:300px;"></div>   
                    </div>  
                  
                    
            </ax:split-panel>
        </ax:split-layout>
        
        
                    
           



               


   
   </div><!-- main -->	

	
</jsp:body>

</ax:layout>