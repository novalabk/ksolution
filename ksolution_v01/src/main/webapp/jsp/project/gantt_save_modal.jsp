<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>


<ax:set key="title" value="${pageName}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
	<jsp:attribute name="js">
		<script type="text/javascript" src="<c:url value='/assets/plugins/bootstrap/dist/js/bootstrap.min.js' />"></script>
	</jsp:attribute>
	
	<jsp:attribute name="css">
		<link rel="stylesheet" href="<c:url value='/assets/plugins/bootstrap/dist/css/bootstrap.min.css'/>"/>
    </jsp:attribute>
      
    <jsp:attribute name="script">
    
        <ax:script-lang key="ax.script" var="LANG"/>
        <ax:script-lang key="ks.Msg" var="MSG"/>
    
        <script type="text/javascript">
        var fnObj = {};
        
        fnObj.pageStart = function () {
        	
        	var initData = parent.getInitData();
        	
        	//console.log("initData", initData);
        	
        	var target = $("#formView01");
       	 
       	 	var name = target.find('[data-ax-path="' + "name" + '"]').val(initData.name);
       		var desc = target.find('[data-ax-path="' + "desc" + '"]').val(initData.description);
       		var pjtState = target.find('[data-ax-path="' + "pjtState" + '"]').val(initData.pjtState);
       		
  
       		target.find('[data-ax-path="' + "calTempId" + '"]').val(initData.calTempId);
       		
       		
       		if(initData.oid){
       			target.find('[data-ax-path="' + "calTempId" + '"]').prop("disabled", true);
       		}
        }
        
        function saveGantt(){
        	 var target = $("#formView01");
     
        	 var name = target.find('[data-ax-path="' + "name" + '"]').val();
        	 var desc = target.find('[data-ax-path="' + "desc" + '"]').val();
        	 var pjtState = target.find('[data-ax-path="' + "pjtState" + '"]').val();
        	 var calTempId = target.find('[data-ax-path="' + "calTempId" + '"]').val();
        	 
        	 if(checkSpace(name)){
        		 alert(LANG("ax.script.ks.17"));
        		 return;
        	 }
        	 
        	 if(checkSpace(pjtState)){
        		 alert(LANG("ax.script.ks.18"));
        		 return;
        	 }
        	 
        	 if(checkSpace(calTempId)){
        		 alert(LANG("ax.script.ks.19"));
        		 return;
        	 }
        	 
        	 data = {
        			 name : name,
        			 description : desc,
        			 pjtState: pjtState,
        			 calTempId : calTempId
        	};
        	 parent.axboot.modal.callback(data);
        }
        
        function checkSpace(str) { 
        	return (!str || /^\s*$/.test(str));
        } 

     
        
        function closeModal(){
        	var initData = parent.getInitData();
        	
        	if(initData.oid == null || initData.oid ==''){
        		var isConfirm = confirm(LANG("ax.script.ks.15"));
            	if(isConfirm){
            		
            		parent.close();
            	}
        	}
        	
        	parent.axboot.modal.close();
        	
        }
        
        </script>
    </jsp:attribute>
	   	
	<jsp:body>
	
		<ax:form name="formView01">
		
		   <%--  <input type="hidden" name="oid" data-ax-path="oid"  value="${param.oid}" />
		    --%> 
			<ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        <ax:tr>
                            <ax:td label="name" width="100%">
                                <input type="text" data-ax-path="name" title="name" class="form-control" data-ax-validate="required"/>
                            </ax:td> 
                        </ax:tr>
                        
                        <ax:tr>
                        	<ax:td label="ks.Msg.36" width="100%">
                               <ax:common-code groupCd="PJT_STATE" dataPath="pjtState" clazz="form-control W150"/>
                         	</ax:td>
                    	</ax:tr>
                    	
                    	<ax:tr>
                        	<ax:td label="ks.Msg.45" width="100%">
                               <ax:calendarTempList  dataPath="calTempId" clazz="form-control W150"/>
                         	</ax:td>
                    	</ax:tr>
                    	
                        <%-- <ax:tr>
                            <ax:td label="ax.admin.sample.form.address" width="100%">
                                <input type="text" data-ax-path="etc1" class="form-control inline-block W100" readonly="readonly"/>
                                <button class="btn btn-default" data-form-view-01-btn="etc1find"><i class="cqc-magnifier"></i> <ax:lang id="ax.admin.sample.form.find"/></button>
                                <div class="H5"></div>
                                <input type="text" data-ax-path="etc2" class="form-control"/>
                            </ax:td>
                        </ax:tr> --%>
                        <ax:tr>
                            <ax:td label="ax.admin.sample.form.etc5" width="100%" >
                                <textarea data-ax-path="desc" class="form-control" rows="7"></textarea>
                            </ax:td>
                        </ax:tr>
                    </ax:tbl>
                    
                    <div class="H5"></div>
                    <div class="ax-button-group">
                        <%-- <div class="left">
                            <h3>
                                <i class="cqc-list"></i>
                                <ax:lang id="ax.admin.sample.child.list"/></h3>
                        </div> --%>
                        <div class="right">
                            <button type="button" class="btn btn-default" data-grid-view-02-btn="item-add" onclick="saveGantt()">
                                <i class="cqc-plus"></i>
                               <c:choose>                               
                               <c:when test="${ 'true' eq param.isSaveAs }">
     									Save As
    							</c:when>
    							<c:otherwise>
        							   <ax:lang id="ax.admin.menu.auth.save"/> 
   								 </c:otherwise> 
   								</c:choose>
                            </button>
                            <button type="button" class="btn btn-default" data-grid-view-02-btn="item-remove" onclick="closeModal()">
                                <i class="cqc-minus"></i>
                                <ax:lang id="ks.Msg.20"/>
                            </button>
                        </div>
                    </div>
                    
                    
		</ax:form>
	</jsp:body>
</ax:layout>