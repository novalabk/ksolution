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
        <script type="text/javascript">
        var fnObj = {};
        
        fnObj.pageStart = function () {
        	
        	var initData = parent.getInitData();
        	
        	console.log("initData", initData);
        	
        	var target = $("#formView01");
       	 
       	 	var name = target.find('[data-ax-path="' + "name" + '"]').val(initData.prj_name);
       		var desc = target.find('[data-ax-path="' + "desc" + '"]').val(initData.desc);
       		var pjtState = target.find('[data-ax-path="' + "pjtState" + '"]').val(initData.pjtState);
       		
        }
        
        function saveGantt(){
        	 var target = $("#formView01");
        	 
        	 var name = target.find('[data-ax-path="' + "name" + '"]').val();
        	 var desc = target.find('[data-ax-path="' + "desc" + '"]').val();
        	 var pjtState = target.find('[data-ax-path="' + "pjtState" + '"]').val();
        	 
        	 
        	 data = {
        			 name : name,
        			 description : desc,
        			 pjtState: pjtState
        	        };
        	 parent.axboot.modal.callback(data);
        }
        
        function closeModal(){
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
                        	<ax:td label="ax.admin.use.or.not" width="100%">
                               <ax:common-code groupCd="PJT_STATE" dataPath="pjtState" clazz="form-control W150"/>
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