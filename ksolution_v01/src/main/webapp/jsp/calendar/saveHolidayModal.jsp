<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>


<ax:set key="title" value="${pageName}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="modal">
	<jsp:attribute name="js">
		
		
	</jsp:attribute>
	
	<jsp:attribute name="css">
		<link rel="stylesheet" href="<c:url value='/assets/plugins/bootstrap/dist/css/bootstrap.min.css'/>"/>
   		<link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/bootstrap/latest/css/bootstrap.css" />
        <link rel="stylesheet" type="text/css" href="//cdn.jsdelivr.net/bootstrap.daterangepicker/2/daterangepicker.css" />
    	<link href=<c:url value="/assets/css/axboot.css" /> rel="stylesheet" />  
    </jsp:attribute>
      
    <jsp:attribute name="script">
    	<ax:script-lang key="ax.script" var="LANG"/>
		<ax:script-lang key="ks.Msg" var="MSG"/> 
        <script type="text/javascript" src="<c:url value='/assets/plugins/bootstrap/dist/js/bootstrap.min.js' />"></script>
		
        <script type="text/javascript" src="//cdn.jsdelivr.net/momentjs/latest/moment.min.js"></script>
        <script type="text/javascript" src="//cdn.jsdelivr.net/bootstrap.daterangepicker/2/daterangepicker.js"></script>
       
        <script type="text/javascript">
        var fnObj = {};
        
        fnObj.pageStart = function () {
        	
        	var initData = parent.axboot.modal.getData();
        	
        	var target = $("#formView01");
       	 
       	 	var name = target.find('[data-ax-path="' + "title" + '"]').val(initData.title);
       		var desc = target.find('[data-ax-path="' + "desc" + '"]').val(initData.description);
       		
       		if(initData.isHoliday){
       			$(':input:radio[name=isHoliday]').filter('[value='+ initData.isHoliday + ']').attr('checked', true);
       		}
       		
       		
       		
       		$("input[value='1']").attr('checked', true);
       		//var pjtState = target.find('[data-ax-path="' + "pjtState" + '"]').val(initData.pjtState);
       		
       		//$('.daterange').daterangepicker();
       		var dayOfWeek = LANG("ax.script.ks.22");
       		var dayOfWeeks = dayOfWeek.split(',');
       		var monthStr = LANG("ax.script.ks.23");
       		var months = monthStr.split(',');
       		
       		$('.daterange').daterangepicker({
       			
       			 "startDate": initData.start,
                 "endDate": initData.end,
       			 locale: {
                 	format: 'YYYY-MM-DD',
                 	"separator": " - ",
                    "applyLabel": "Apply",
                    "cancelLabel": "Cancel",
                    "fromLabel": "From",
                    "toLabel": "To",
                    "customRangeLabel": "Custom",
                    "daysOfWeek": dayOfWeeks,
                    "monthNames": months,
                    //"firstDay": 1
       		 	 }
       		  
       		 });
       		
        }
        
        function saveEvent(){
        	 var target = $("#formView01");
        	 
        	 var name = target.find('[data-ax-path="' + "title" + '"]').val();
        	 var desc = target.find('[data-ax-path="' + "desc" + '"]').val();
        	 //isHoliday var pjtState = target.find('[data-ax-path="' + "pjtState" + '"]').val();
        	 var isHoliday = $(":input:radio[name=isHoliday]:checked").val();
        	 
        	 var endDate = $('.daterange').data('daterangepicker').endDate;
        	 var real_end = moment(endDate).add(1, 'days');
        	 
        	 //alert( moment(real_end).format("YYYY-MM-DD"));
        	 
        	 if(checkSpace(name)){
        		 alert(LANG("ax.script.ks.21"));
        		 return;
        	 }
        	 
        	 data = {
        		 action:'save',	 
       			 title : name,
       			 description : desc,
       			 start: $('.daterange').data('daterangepicker').startDate.format('YYYY-MM-DD'),
       			 end: moment(real_end).format("YYYY-MM-DD"),
       			 isHoliday : isHoliday
       			 //pjtState: pjtState
        	 };
        	 parent.axboot.modal.callback(data);
        }
        
        function checkSpace(str) { 
        	return (!str || /^\s*$/.test(str));
        } 
        
        
        function deleteEvent(){
	       	 var target = $("#formView01");
	       	 
	       	 var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
	       	 	       	 
	       	 data = {
	       			 action:'delete',
	      			 oid: oid
	       	 };
	       	 
	       	 
	       	axDialog.confirm({
	    	    msg: LANG("ax.script.deleteconfirm")
	    	}, function () {
	    	    if (this.key == "ok") {
	    	    	parent.axboot.modal.callback(data);
	    	    }
	    	});
	       	
	       
       	}
        
        function closeModal(){
        	parent.axboot.modal.close();
        }
        
        </script>
    </jsp:attribute>
	   	
	<jsp:body>
	
		<ax:form name="formView01">
		 
		    <input type="hidden" name="oid" data-ax-path="oid"  value="${param.oid}" />
		     
			<ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        <ax:tr>
                            <ax:td label="title" width="100%">
                                <input type="text" data-ax-path="title" title="title" class="form-control" data-ax-validate="required"/>
                            </ax:td> 
                        </ax:tr>
                        
                        <ax:tr>
                        	<ax:td label="ks.Msg.46" width="100%">
                        	<input type="text" data-ax-path="period" title="period" class="daterange W300"  data-date-format="yyyy-mm-dd" data-ax-validate="required"/>
                               
                         	</ax:td>
                    	</ax:tr>
                    	<ax:tr>
                    	<ax:td label="ks.Msg.42" width="100%">
                    	
                    	<input type="radio" name="isHoliday" data-ax-path="isHoliday" value="YES" checked /> <ax:lang id="ks.Msg.40"/> &nbsp;
                    	<input type="radio" name="isHoliday" data-ax-path="isHoliday" value="NO" /> <ax:lang id="ks.Msg.41"/> 
                    	
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
                                <textarea data-ax-path="desc" class="form-control" rows="12"></textarea>
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
                            <button type="button" class="btn btn-default" data-grid-view-02-btn="item-add" onclick="saveEvent()">
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
                            <c:if test="${not empty param.oid}">
								<button type="button" class="btn btn-default" data-grid-view-02-btn="item-remove" onclick="deleteEvent()">
                                <i class="cqc-minus"></i>
                                <ax:lang id="ax.admin.menu.auth.delete"/>
                           		</button>
							</c:if>
                            
                            <button type="button" class="btn btn-default" data-grid-view-02-btn="item-close" onclick="closeModal()">
                                <i class="cqc-erase"></i>
                                <ax:lang id="ks.Msg.20"/>
                            </button>
                        </div>
                    </div>
                    
                    
		</ax:form>
	</jsp:body>
</ax:layout>