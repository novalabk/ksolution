<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags"%>
<% 
    
	request.setAttribute("pageName", "자재 상세보기");
	//request.setAttribute("menuId", request.getParameter("menuId"));
	
%> 

<ax:set key="title" value="${pageName}" />
<ax:set key="page_desc" value="${pageRemark}" />
<ax:set key="page_auto_height" value="false" />


<ax:layout name="base">

	
 	
    <jsp:attribute name="js">
<!--     <script type="text/javascript" src="/assets/plugins/ax5core/dist/ax5core.min.js"></script> -->
	<script type="text/javascript" src="/assets/plugins/ax5ui-dialog/dist/ax5dialog.js"></script>
	<script type="text/javascript" src="/assets/plugins/ax5ui-uploader/dist/ax5uploader.js"></script>
	<script type="text/javascript" src="/assets/plugins/ax5ui-grid/dist/ax5grid.min.js"></script>
	<script src="https://cdn.rawgit.com/thomasJang/jquery-direct/master/dist/jquery-direct.min.js"></script>
	<script type="text/javascript" src="/assets/plugins/select2-4.0.3/dist/js/select2.min.js"></script>
	
	<script src="/assets/plugins/bootstrap-fileinput-master/js/plugins/sortable.js" type="text/javascript"></script>
    <script src="/assets/plugins/bootstrap-fileinput-master/js/fileinput.js" type="text/javascript"></script>
    <script src="/assets/plugins/bootstrap-fileinput-master/js/locales/fr.js" type="text/javascript"></script>
    <script src="/assets/plugins/bootstrap-fileinput-master/js/locales/es.js" type="text/javascript"></script>
    <script src="/assets/plugins/bootstrap-fileinput-master/themes/explorer/theme.js" type="text/javascript"></script>
    <script src="/assets/js/common/jquery.form.js" type="text/javascript"></script>
    
	<script type="text/javascript" src="/assets/plugins/bootstrap/dist/js/bootstrap.min.js"></script>
	
	<script type="text/javascript" src="/assets/plugins/mustache.js/mustache.js"></script>
	
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.js"></script>
	
	
	
 
	
<!-- 	<script type="text/javascript" src="/assets/plugins/ax5ui-toast/dist/ax5toast.min.js"></script> -->
    </jsp:attribute>
    
    
    
   
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <ax:script-lang key="ax.admin" var="COL" />
        
        <script type="text/javascript">
            //http://postcode.map.daum.net/guide
       
            var fnObj = {};
            var ACTIONS = axboot.actionExtend(fnObj, {
            	FOLDER_CREATE: function (caller, act, data) {
                    axboot.modal.open({
                        modalType: "BSFolder-MODAL",
                        param: "",
                        param: "",
                        header:{title: "폴더 생성"},
                        sendData: function(){
                            return {
                                "sendData": "AX5UI"
                            };
                        },
                        onStateChanged: function () {
                            // mask
                            if (this.state === "open") {
                                //alert("open");
                            }
                            else if (this.state === "close") {
                            	window.location.reload();
                            	
                            }
                        },
                        callback: function (data) {
                            
                        	/*caller.formView01.setEtc3Value({
                                key: data.key,
                                value: data.value
                            });*/
                            this.close();
                        }
                    });
                    
                   
                },
                
                ADD_IN_FOLDER: function (caller, act, data) {
                	
                	
                	var sendData = $.extend({}, this.pageButtonView.getData());
                	
                	//console.log("sendData", sendData);
                	
                    axboot.ajax({
                        type: "PUT",
                        url : [ "spBasket", "saveLink" ],
                        data: JSON.stringify(sendData),  
                        callback: function (res) {
							//console.log("data", res);
                        	axToast.push(res.message);
                            // caller.gridView01.setData(res);
                           //ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});
                        }
                    });

                    return false;
                },
                
                ADDCOMMENT: function(caller, act, data){
                	axMask.open();
               		$('#fileForm').ajaxForm({
               		url: "/api/v1/material/comment",
               		type: "POST",
               		enctype: "multipart/form-data", // 여기에 url과 enctype은 꼭 지정해주어야 하는 부분이며 multipart로 지정해주지 않으면 controller로 파일을 보낼 수 없음
               		success: function(result){
               			//if(result.status == 0){
               				
               			//   alert(result.message);
               			 //	axToast.push(result.message);
               			//}  
               				axMask.close();
               				
               			//	console.log("kkkdkfjdklfj " ,  $(".fileinput-remove-button"));
               				$(".fileinput-remove.fileinput-remove-button").click();
               				 //var target = $("#fileForm");
               				 $('#fileForm').find('[data-ax-path="comment"]').val("");
               			 	// target.find('[data-ax-path="file"]').val(""); 
               				 
               			 	// $(".fileinput-remove .fileinput-remove-button").click();
               				
               				 //$("#fileopen").val("");
               		        //this.model.setModel(this.getDefaultData(), this.target);
               		        //this.modelFormatter = new axboot.modelFormatter(this.model); 
               		        
               				ACTIONS.dispatch(ACTIONS.COMMENTLIST);
               				
               			}
               		});
               		// 여기까지는 ajax와 같다. 하지만 아래의 submit명령을 추가하지 않으면 백날 실행해봤자 액션이 실행되지 않는다.
               		$("#fileForm").submit();
                	
                },
                
                DELTECOMMENT: function (caller, act, data) {
                	
                	
                	var sendData = $.extend({}, data);
                	
                //	console.log("sendData", sendData);
                	
                   axboot.ajax({
                        type: "GET",
                        url : [ "material", "deleteComment" ],
                        data: sendData,  
                        callback: function (res) {
							//console.log("data", res);
                        	axToast.push(res.message);
                        	ACTIONS.dispatch(ACTIONS.COMMENTLIST);
                            // caller.gridView01.setData(res);
                           //ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});
                        }
                    }); 

                   
                },
                
                COMMENTLIST: function (caller, act, data) {
                	
                	
                	//console.log("sendData", sendData);
                	var sendData = $.extend({}, this.pageButtonView.getData());
                    axboot.ajax({
                        type: "GET",
                        url : [ "material", "commentlist" ],
                        data: sendData,  
                        callback: function (res) {
                        	res.list.forEach(function (n) {
                        		n.comments = [];
                        		if(n.comment != null){
                        			
                        			list = n.comment.split("\n")
									
									
                        			
                        			list.forEach(function (c) {
                        				var a = new Object();
                        				a.comment = c;
                        				n.comments.push(a);
                        			});
                        			//console.log("n.comments", n.comments);
                        			//n.comment = n.comment.replace(/\n\r?/g, '&#13;&#10');
                        			//alert(n.comment);
                        		}
                             });
                        	 
							 console.log("data", res.list);
						//	 console.log("this.commentView", caller.commentView);
							 caller.commentView.setData(res.list);
							 
                        	//axToast.push(res.message);
                            // caller.gridView01.setData(res);
                           //ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});
                        }
                    });

                    return false;
                },
                
                dispatch: function (caller, act, data) {
                	var result = ACTIONS.exec(caller, act, data);
                    if (result != "error") {
                        return result;
                    } else {
                    	axMask.close();
                        // 직접코딩
                        return false;
                    }
                }
            });

            fnObj.pageStart = function () {
                //window.resizeTo(630, 700);
                this.pageButtonView.initView();
                this.commentView.initView();
                //console.log("this.commentView  ddd", this.commentView);
                ACTIONS.dispatch(ACTIONS.COMMENTLIST);
                
                
                
            };

            fnObj.pageButtonView = axboot.viewExtend({
                initView: function () {
                    
                	this.folderOid = $("#folderOid");
                	this.oid = $("[name='oid']");
                	
                	axboot.buttonClick(this, "data-form-view-01-btn", {
                        
                        "folder": function () {
                        	
                            ACTIONS.dispatch(ACTIONS.FOLDER_CREATE);
                        },
                        "addFolder": function(){
                        	 if($("#folderOid").val() == null){
                        		 axDialog.alert({
                                     theme: "primary",
                                     msg: "먼저 폴더를 생성해 주십시오."
                                 });
                        		 return;
                        	 }
                        	 
                        	 axDialog.confirm({
                                theme: "primary",
                                msg: "즐겨찾기에 추가하시겠습니까?"//LANG("ax.script.alert.test")
                            },function () {
                                if (this.key == "ok") {
                                	 ACTIONS.dispatch(ACTIONS.ADD_IN_FOLDER);
                                    //caller.gridView02.clear();
                                }
                            });                        	
                        },
                        "commendSave": function(){
                        	 ACTIONS.dispatch(ACTIONS.ADDCOMMENT);
                        },
                        "update" : function(){
                        	//alert("${isModify}");
                        	location.href="/jsp/material/material-create.jsp?&menuId=${menuId}&oid=" + $("[name='oid']").val();
                        }
                        
                        
                        
                    });
                	
                	 /* $('#commendSave').click(function() {
                		 alert("call..");
                		 ACTIONS.dispatch(ACTIONS.ADDCOMMENT);
                	 }); */
                },
                getData : function(){
                	return {
                        
                        folderOid: this.folderOid.val(),
                        oid : this.oid.val()
                    }
                }
            });
            
            fnObj.commentView = axboot.viewExtend({
                initView: function () {
                	this.template =$('#commenttemplate').html(); 
                	Mustache.parse(this.template);
                	  
                },
                setData : function(datas){
                	$('#comment-target').html(Mustache.render(this.template, datas));
                }
            });

        </script>
        
    </jsp:attribute>
     
    <jsp:attribute name="css">
        <!--  <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-dialog/dist/ax5dialog.css"/>
		 <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-uploader/dist/ax5uploader.css"/> -->
		 
		 <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
		 <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />
		 <link href="/assets/plugins/select2-4.0.3/dist/css/select2.min.css" rel="stylesheet" />
		 <link href="/img/test.css" rel="stylesheet" />
    	<link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">
    	<link href="/assets/plugins/bootstrap-fileinput-master/css/fileinput.css" media="all" rel="stylesheet" type="text/css"/>
   		<link href="/assets/plugins/bootstrap-fileinput-master/themes/explorer/theme.css" media="all" rel="stylesheet" type="text/css"/>
   		
   		
   		<link href="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.min.css" media="all" rel="stylesheet" type="text/css"/>
   		<link href="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.css" media="all" rel="stylesheet" type="text/css"/>
   		
   		
		 <link href="/assets/css/axboot.css" rel="stylesheet" />  
		
		
    </jsp:attribute>
      
    
	<jsp:body>

  	 <ax:form name="formView01">
  	 	
  <div data-page-buttons="">
    <div class="button-warp">
    	 <ax:folderSelect id="folderOid"  style="width:200px;height:28px"/>
         <button class="btn btn-default" data-form-view-01-btn="addFolder"  style="margin-left:5px"><i class="cqc-magnifier"></i>즐겨찾기 추가</button>
         <button class="btn btn-default" data-form-view-01-btn="folder"  style="margin-left:5px"><i class="cqc-magnifier"></i>폴더 생성</button>
          <c:if test="${isModify==true}">

         <button type="button" class="btn btn-info" style="margin-left:5px" data-form-view-01-btn="update"><i class="axi axi-file-excel-o"></i>수정</button>
		</c:if>
	</div>
  </div>
				<%-- <div class="ax-button-group" role="panel-header">
                    <div class="left">
                        <h2><i class="cqc-news"></i>
                            <ax:lang id="ax.admin.sample.parent.information"/>
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-default" data-form-view-01-btn="form-clear">
                            <i class="cqc-erase"></i>
                            <ax:lang id="ax.admin.clear"/>
                        </button>
                    </div>
                </div>  --%>
                
               
               
                    <c:if test="${not empty imgList}" >
   
   



                     <div data-ax5grid="img-grid" id="target" data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: true,
					                    multipleSelect: false,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					                }" style="height: 150px;">
					     
					    
					     <c:forEach items="${imgList}" var="imgItem">
     	        
     	        			    <!-- <a href="/api/v1/ax5uploader/thumbnail.jpg?id=31" data-toggle="lightbox" data-gallery="example-gallery" class="col-sm-4">
									<img src="/api/v1/ax5uploader/thumbnail?id=31" class="img-fluid">
								</a> -->
								 <a href="${imgItem._thumbnail}" data-toggle="lightbox" data-gallery="example-gallery" style="margin-left:5px" data-title="이미지 파일" > 
									<img src="${imgItem._thumbnail}" class="img-rounded" width="160" height="160">
								</a>
								
						  </c:forEach>
						</c:if>   
					           <!--  <a href="https://unsplash.it/1200/768.jpg?image=252" data-toggle="lightbox" data-gallery="example-gallery" style="margin-left:5px">
					                <img src="https://unsplash.it/600.jpg?image=252" class="img-rounded" width="204" height="150">
					            </a> -->
					    
					      
					         
        
					   </div>


                	<div class="DH20"></div>
                	
                	
                	<div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i>상세정보</h3>
                        </div>
                        
                    </div>
                
                	<input type="hidden" name="oid" data-ax-path="oid"  value="${material.oid}" />
                    <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        
                        <ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   			            
				                         <ax:tr style="border:0px;width:*">
				                           <div data-ax-td-label="" class="" style="width:200px;height:40px">일련번호</div>
				                           <div data-ax-td-wrap="" style="vertical-align:middle;width:500px">
				                           		
				                           		<%-- <pre class="form-control for-prettify" style="height:auto;padding: 0;" data-ax-path="discussion">${material.discussion}</pre>
				                           		 --%>
				                           		${material.serialNumber}
				                           	</div>
				                        </ax:tr>
				                        
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
                        <div data-ax-tr="" id="" class="" style="">
	                        <div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class="" style="width:200px">분류</div>
	                           <div data-ax-td-wrap="" style="vertical-align:middle;width:200px">
							        ${material.typePath}
	                           	</div>
	                           	
	                           
	                           	
	                        <div data-ax-td-label="" class="" style="width:100px" >자재유무</div>
				                           <div data-ax-td-wrap="" style="vertical-align:middle;width:200px">
				                           		 ${material.m_exist_str}
				                           	</div>
	                         </div>
	                        
				        </div>
	                         
                        <div data-ax-tr="" id="" class="" style="">
	                        <div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class=""
									style="width: 200px">브랜드</div>
	                           <div data-ax-td-wrap=""
									style="vertical-align: middle; width: 200px">
							        ${material.mfCompany.brand}
	                           	</div>
	                           	
	                           
	                           	
	                        <div data-ax-td-label="" class=""
									style="width: 100px">홈페이지</div>
				                           <div data-ax-td-wrap=""
									style="vertical-align: middle; width: 200px">
				                           		
				                           	<a href="${material.mfCompany.home_addr}" target="_blank" data-ax-path="mfCompany.home_addr">
				                           	${material.mfCompany.home_addr}</a>
				                           	</div>
	                         </div>
	                        
				        </div>
                           	
                     
	                    <ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">명칭</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<%-- <ax:tr  style="">
				                            <div data-ax-td-label="" class="" style="width:100px" >브랜드</div>
				                            <div data-ax-td-wrap="" style="vertical-align:middle;width:200px">
				                           		${material.brand}
				                           	</div>
				                           	<div data-ax-td-label="" class="" style="width:100px" >콜렉션</div>
				                           <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="collection" >
				                           		 ${material.collection}
				                           	</div>
				                        </ax:tr> --%>
				                        
				                        <ax:tr style="border:0px;">
				                           <div data-ax-td-label="" class="" style="width:100px" >시리즈</div>
				                           <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="seriese">
				                           		 ${material.seriese}
				                           	</div>
				                           	 <div data-ax-td-label="" class="" style="width:100px" >품번</div>
				                           <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="number">
				                           		 ${material.number}
				                           	</div>
				                        </ax:tr>
				                   
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   					<ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">가격</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%;height:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="border:0px;">
				                            <div data-ax-td-label="" class="" style="width:100px" >소비자가(${material.unit})</div>
				                            <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="cmprice">
				                            
				                            <fmt:formatNumber type = "number" maxIntegerDigits = "10" value = "${material.cmprice}" />
		                           		     							
				                           		<!-- <input type="text" data-ax-path="cmprice" class="form-control" data-ax5formatter="money"/> -->
				                           	</div>
				                           	
				                           	 <div data-ax-td-label="" class="" style="width:100px" >구매제안가(${material.unit})</div>
				                             <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="dpprice">
				                           		  
				                           		  <fmt:formatNumber type = "number" maxIntegerDigits = "10" value = "${material.dpprice}" />
		                          
				                             </div>
				                        </ax:tr>
				                        
				                     
				
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   	<%-- 				<ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">제조사 정보</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%;height:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="border:0px;">
				                            <div data-ax-td-label="" class="" style="width:100px" >제조사</div>
				                            <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="cmprice">
				                           		  ${material.mfCompanyName}				                           		
				                           		<!-- <input type="text" data-ax-path="cmprice" class="form-control" data-ax5formatter="money"/> -->
				                           	</div>
				                           	
				                           	 <div data-ax-td-label="" class="" style="width:100px" >제조사 홈페이지</div>
				                             <div data-ax-td-wrap="" style="vertical-align:middle;width:200px;height:40px" data-ax-path="dpprice">
				                           		  <c:if test="${material.mfCompany ne null}">
				                           		  ${material.mfCompany.home_addr}
				                           		  </c:if>
				                           		  
				                             </div>
				                        </ax:tr>
				                        
				                     
				
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr> --%>
	   					
	   					
	   					<ax:tr>
	                        <div data-ax-td="" id="" class=""
								style="width: 100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width: 101px">디자인 속성</div>
		   						
		   						<div data-ax-td="" class="" style="width: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">광택</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												${material.gloss}  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">표면강도</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
												${material.hardness}
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">표면질감</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												${material.feel}
												 <div data-ax-path="feel"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">패턴</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 ${material.pattern}
				                           		  <div
													data-ax-path="pattern"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">밝기</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												 ${material.brightness}
												 <div data-ax-path="brightness"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">색조</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 ${material.shade}
				                           		  <div
													data-ax-path="shade"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        
				                        
				                        
				                        
				                        <ax:tr style="border:0px;width:*">
				                           <div data-ax-td-label="" class=""
												style="width: 100px; : height: 100px">유통사 추천</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 500px">
				                           		${material.recommend}
				                           		<div
													data-ax-path="recommend"
													style="display: inline-block;"></div>
				                           	</div>
				                        </ax:tr>
				                        
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   					<ax:tr>
	                        <div data-ax-td="" id="" class=""
								style="width: 100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width: 101px">유통사</div>
		   						
		   						<div data-ax-td="" class="" style="width: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">회사명</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												${material.disCompany.companyNm}
												 <div data-ax-path="disCompany.companyNm"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">홈페이지</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 <%--  <c:if test="${material.disCompany ne null}">
				                           		       ${material.disCompany.disLocation}
				                           		  </c:if> --%>
				                           		  <a href="${material.disCompany.home_addr}" target="_blank" data-ax-path="disCompany.home_addr">
				                           		  ${material.disCompany.home_addr}
				                           		  <div
													data-ax-path="disCompany.home_addr"
													style="display: inline-block;"></div>
			                                	</a>
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">담당자</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												${material.disCompany.dep_name}
												 <div data-ax-path="disCompany.dep_name"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">담당자 연락처</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 <%--  <c:if test="${material.disCompany ne null}">
				                           		       ${material.disCompany.disLocation}
				                           		  </c:if> --%>
				                           		  ${material.disCompany.dep_phnumber}
				                           		  <div
													data-ax-path="disCompany.dep_phnumber"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="border:0px;">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">배송가능 지역</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												${material.disCompany.dis_area}
												 <div data-ax-path="disCompany.dis_area"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">배송정책</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 <%--  <c:if test="${material.disCompany ne null}">
				                           		       ${material.disCompany.disLocation}
				                           		  </c:if> --%>
				                           		  ${material.disCompany.dis_pirce_type}
				                           		  <div
													data-ax-path="disCompany.dis_pirce_type"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
               


                     
                        
                        <%-- <ax:tr>
                            <ax:td label="ax.admin.sample.form.value" width="300px">
                                <input type="text" data-ax-path="value" class="form-control" />
                            </ax:td>
                        </ax:tr> --%>
                        <%-- <ax:tr>
                            <div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class="" style="width:200px">규격</div>
	                           <div data-ax-td-wrap="" style="width:200px">
	                           		<input type="text" data-ax-path="spec" class="form-control" />
	                           	</div>
	                           	
	                           <div data-ax-td-label="" class="" style="width:100px">컬러</div>
	                           <div data-ax-td-wrap="" style="width:200px">
	                           		<select data-ax-path="color" class="form-control W100">
	                                    <option value="ko_KR">화이트</option>
	                                    <option value="en_US">베이지</option>
	                                    <option value="en_US">샌드베이지</option>
	                                    <option value="en_US">월넛</option>
                                	</select>
	                           	</div>
	                         </div>
                            
                            
                        </ax:tr> --%>
                        
                        
                        <ax:tr>
	                        <div data-ax-td="" id="" class=""
								style="width: 100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width: 101px">제품설명</div>
		   						
		   						<div data-ax-td="" class="" style="width: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">용도</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	${material.useName}
			                                	<div data-ax-path="useName"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">규격</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                 					 ${material.spec}
			                                	<div data-ax-path="spec"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">제조사</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	${material.mcName}
			                                	<div data-ax-path="mcName"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">출시년도</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                 				    ${material.releaseYear}
			                                	<div data-ax-path="releaseYear"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">원산지</div>
				                           
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	 ${material.origin}
			                                	<div data-ax-path="origin"
													style="display: inline-block;"></div>
				                           	</div>
				                           	
				                             <div data-ax-td-label="" class=""
												style="width: 100px">기술적 성능지표</div>
				                           
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	${material.tec_des}
			                                	<div data-ax-path="tec_des"
													style="display: inline-block;"></div>
				                           	</div>
				                        </ax:tr>
				                       
				                        
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class=""
												style="width: 100px; : height: 100px">설명</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 500px">
				                           	
				                           	<%-- 	<pre class="form-control for-prettify" style="height:auto;padding: 0;" data-ax-path="product_des">${material.product_des}</pre>
				                           	 --%>
				                           	 <textarea data-ax-path="product_des"
													class="form-control" rows="6">${material.product_des}</textarea>
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class=""
												style="width: 100px; : height: 100px">동영상 URL</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 500px">
				                           	<%-- 	<pre class="form-control for-prettify" style="height:auto;padding: 0;" data-ax-path="product_des">${material.product_des}</pre>
				                           	 --%>
				                           	 <a href = "${material.product_des_url}" target="_blank" data-ax-path="product_des_url">
				                           	${material.product_des_url}
				                           	<div data-ax-path="product_des_url"
													style="display: inline-block;"></div>
													</a>
				                           	</div>
				                        </ax:tr>
				                        
				                        
				                        
				                        
				                         <ax:tr style="border:0px;width:*">
				                           <div data-ax-td-label="" class=""
												style="width: 100px; : height: 100px">시공사 유의 사항</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 500px">
				                           		
				                           		<%-- <pre class="form-control for-prettify" style="height:auto;padding: 0;" data-ax-path="discussion">${material.discussion}</pre>
				                           		 --%>
				                           		 <textarea data-ax-path="discussion"
													class="form-control" rows="6">${material.discussion}</textarea>
				                           	</div>
				                        </ax:tr>
				                        
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   					
                    </ax:tbl>
                    
                    <div class="H5"></div>
                    <div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i> 시공특이사항 (첨부 파일)</h3>
                        </div>
                        
                    </div>
                    
                   
					 
					<div class="DH20"></div>
					 
					<div data-ax5grid="first-grid" data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: true,
					                    multipleSelect: false,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					                }" style="height: 100px;"></div>

                    

 </ax:form>
 

<div class="H5"></div>
                    <div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i> 사용자 건의 사항</h3>
                        </div>
                        
                    </div>

<div class="container-full" id="comment-target"> 

</div><!-- /container -->


    <div class="row">
        <div class="col-lg-12">
            <div class="panel panel-info">
                <div class="panel-body">
                <form class="form-inline" id="fileForm" action="/api/v1/material/commend" enctype="multipart/form-data">
                    <input type="hidden" name="oid" data-ax-path="oid"  value="${material.oid}" />
                    <textarea placeholder="Write your comment here!" name="comment" data-ax-path="comment" class="pb-cmnt-textarea"></textarea>
                    
                    	
                        <div class="pull-left">
                           <input id="input-1a" type="file" name="file" size="40" data-ax-path="file" data-show-preview="false" > 
                        </div>
                        
                        <button class="btn btn-primary pull-right" type="button" data-form-view-01-btn="commendSave" id="commendSave">Share</button>
                    </form>
                </div>
            </div>
        </div>
    </div>




</jsp:body>
</ax:layout>


<script id="template" type="x-tmpl-mustache">
{{#.}}



 <a href="{{thumbnail}}" data-toggle="lightbox" data-gallery="example-gallery" style="margin-left:5px" > 
									<img src="{{thumbnail}}" class="img-rounded" width="160" height="160">
								</a>
  
{{/.}} 
</script>


<script id="modaltemplate" type="x-tmpl-mustache">

  {{#.}}
    <div class="mySlides">
      <div class="numbertext">1 / 3</div>
      <img src="{{download}}" style="width:100%;height:450px">
    </div>
  {{/.}}

    <a class="prev" onclick="plusSlides(-1)">&#10094;</a>
    <a class="next" onclick="plusSlides(1)">&#10095;</a>

    <div class="caption-container">
      <p id="caption"></p>
    </div>
{{#.}}
    <div class="column">
      <img class="demo cursor" src="{{download}}" style="width:100%;height:120px" onclick="currentSlide(1)" alt="Nature and sunrise">
    </div>
{{/.}}
    
</script>

<script id="commenttemplate" type="x-tmpl-mustache">
{{#.}}
<div class="row">
  

<div class="col-sm-10">
    <div class="panel panel-default">
     <div class="panel-heading">
     <strong>{{createdBy}}</strong> <span class="text-muted">{{generatedcreatedAt}}</span>
     {{#existFile}}<a href="{{file.thumbnail}}" class="text-red" data-toggle="lightbox" data-title="이미지 파일" style="margin-left:10px"><i class="fa fa-files-o"></i>{{file.fileNm}}</a>{{/existFile}}
 
 	 {{#isDelete}} <button type="button" class="btn btn-default pull-right" style="position:relative;top:-3px" onclick="deleteComment('{{oid}}')"><i class="fa fa-trash-o"></i>삭제</button>{{/isDelete}}
    </div>
	<div class="panel-body">
	
{{#comments}}
    {{comment}}<br/>
{{/comments}}
 </div><!-- /panel-body -->
 </div><!-- /panel panel-default -->
 </div><!-- /col-sm-5 -->
</div><!-- /row -->
  {{/.}}    
</script>


<script>

$(document).on('click', '[data-toggle="lightbox"]', function(event) {
	 	event.preventDefault();
	$(this).ekkoLightbox();
});
function deleteComment(oid){
	ACTIONS.dispatch(ACTIONS.DELTECOMMENT, {oid: oid});
}


$(document).ready(function () {

	
    $("#input-1a").fileinput({
		 'showUpload':false,
		 'showCancel':false,
		 
		 'showClose':false,
		 'showPreview':false,
		 'showUploadedThumbs':false
   });
   $(".kv-upload-progress").css("display", "none"); 
   
   var template = $('#template').html();
   Mustache.parse(template);
   var modaltemplate =$('#modaltemplate').html(); 
   Mustache.parse(modaltemplate); 
   $.ajax({
       method: "GET",
       url: API_SERVER + "/api/v1/ax5uploader/list?contentType=IMG_FILE&targetType=Material_M&id=" + '${material.oid}',
       success: function (res) {
         // console.log("res...", res);
				// console.log(data);
				//  console.log("kkk = " , Mustache.render(modaltemplate, res));
		 // console.log("kkkkkkkkkkkkkkkkggggggggggggggggg" ,  res);
		 // $('#target').html(Mustache.render(template, res));
		  $('#modal-content-target').html(Mustache.render(modaltemplate, res));
       }
   });
  
    

   prettify();
   //console.log($("#input-1a"));
});

function prettify() {
	   $("#formView01").find(".for-prettify").each(function () {
		
        var $this = $(this);
        var path = $this.attr("data-ax-path");

        var po = [];

        if (path == "parameterMap" || path == "headerMap" || path == "userInfo") {
            po.push('<pre class="prettyprint linenums lang-js" style="margin:0;">');
            try {
                po.push(JSON.stringify(JSON.parse($this.text()), null, '    '));
            } catch (e) {

            }
        } else {
            po.push('<pre class="prettyprint linenums" style="margin:0;">');
            po.push($this.html());
        }
        po.push('</pre>');
        $this.html(po.join(''));
    });
    if (window["prettyPrint"]) window["prettyPrint"]();
}


function openModal() {

    document.getElementById('myModal').style.display = "block";
}

function closeModal() { 
   document.getElementById('myModal').style.display = "none";
}

var slideIndex = 1;
showSlides(slideIndex);

function plusSlides(n) {
  showSlides(slideIndex += n);
}

function currentSlide(n) {
  showSlides(slideIndex = n);
} 

function showSlides(n) {
  var i;
  var slides = document.getElementsByClassName("mySlides");
  var dots = document.getElementsByClassName("demo");
  var captionText = document.getElementById("caption");
  if (n > slides.length) {slideIndex = 1}
  if (n < 1) {slideIndex = slides.length}
  for (i = 0; i < slides.length; i++) {
      slides[i].style.display = "none";
  }
  for (i = 0; i < dots.length; i++) {
      dots[i].className = dots[i].className.replace(" active", "");
  }
  slides[slideIndex-1].style.display = "block";
  dots[slideIndex-1].className += " active";
  captionText.innerHTML = dots[slideIndex-1].alt;
}
</script>


<script type="text/javascript">
   //  alert("${distributionId}")
    

    //$(function () {
      var API_SERVER = "";

      var DRAGOVER = $("#dragover");

      /// dialog
      var DIALOG = new ax5.ui.dialog({
          title: "AX5UI"
      });

      /// upload
      var UPLOAD2 = new ax5.ui.uploader({
          //debug: true,
          target: $('[data-ax5uploader="upload2"]'),
          form: {
              action: API_SERVER + "/api/v1/ax5uploader/upload",
              fileName: "file"
          },
          multiple: true,
          dropZone: {
              target: $(document.body),
              onclick: function () {
                  // 사용을 원하는 경우 구현
                  return;
                  if (!this.self.selectFile()) {
                      console.log("파일 선택 지원 안됨");
                  }
              },
              ondragover: function () {
                  //this.self.$dropZone.addClass("dragover");
                  DRAGOVER.show();
                  DRAGOVER.on("dragleave", function () {
                      DRAGOVER.hide();
                  });
              },
              ondragout: function () {
                  //this.self.$dropZone.removeClass("dragover");
              },
              ondrop: function () {
                  DRAGOVER.hide();
              }
          },
          validateSelectedFiles: function () {
              //console.log(this);
              // 10개 이상 업로드 되지 않도록 제한.
              if (this.uploadedFiles.length + this.selectedFiles.length > 10) {
                  alert("You can not upload more than 10 files.");
                  return false;
              }
              return true;
          },
          onuploaderror: function () {
              console.log(this.error);
              dialog.alert(this.error.message);
          },
          onuploadComplete: function () {
              UPACTIONS["UPDATE_uploaded"](this.self.uploadedFiles);
          }
      });

      
      
      
      /// grid
      var GRID = new ax5.ui.grid({
          target: $('[data-ax5grid="first-grid"]'),
          columns: [
              {key: "fileNm", label: "파일명", width: 200},
              {key: "fileSize", label: "파일사이즈", align: "right", formatter: function () {
                  return ax5.util.number(this.value, {byte: true});
              }},
              {key: "extension", label: "확장자", align: "center", width: 60},
              {key: "createdAt", label: "생성자ID", align: "center", width: 140, formatter: function () {
                  return ax5.util.date(this.value, {"return": "yyyy/MM/dd hh:mm:ss"});
              }},
              {key: "thumbnail", label: "받기", width: 60, align: "center", formatter: function () {
                  return '<i class="fa fa-download" aria-hidden="true"></i>'
              }}
          ],
          body: {
              onClick: function () {
                  if(this.column.key == "thumbnail" && this.item.download){
                  	alert(API_SERVER + this.item.download);
                      location.href = API_SERVER + this.item.download;
                  }
              }
          }
      });

      /// ACTIONS
      var UPACTIONS = {
          "INIT": function () {
              // 컨트롤 버튼 이벤트 제어
              uploadView.initView();
          },
          "GET_grid": function (data) {
              return GRID.getList(data);
          },
          "GET_uploaded": function () {
              // 업로드 파일 가져오기
              $.ajax({
                  method: "GET",
                  url: API_SERVER + "/api/v1/ax5uploader/list?contentType=DOC_FILE&targetType=Material_M&id=" + '${material.oid}',
                  success: function (res) {
                      uploadView.setData(res);
                  }
              });
          },
          "DELETE_files": function (data) {
              $.ajax({
                  contentType: "application/json",
                  method: "post",
                  url: API_SERVER + "/api/v1/ax5uploader/delete",
                  data: JSON.stringify(data),
                  success: function (res) {
                      if (res.error) {
                          alert(res.error.message);
                          return;
                      }
                      UPACTIONS["GET_uploaded"]();
                  }
              });
          },
          "UPDATE_uploaded": function (data) {
              GRID.setData(data);
          }
      };

      /// uploadView
      var uploadView = {
          initView: function () {
              $('[data-btn-wrap]').clickAttr(this, "data-upload-btn", {
                  "removeFile":  
                  	
                  	
                  	function () {
                      var deleteFiles = UPACTIONS["GET_grid"]("selected");
                      if (deleteFiles.length == 0) {
                          alert("No list selected.");
                          return;
                      }
                      DIALOG.confirm({
                          title: "AX5UI",
                          msg: "Are you sure you want to delete it?"
                      }, function () {
                          if (this.key == "ok") {
                              UPACTIONS["DELETE_files"](deleteFiles);
                          }
                      });
                  }
              });
          },
          setData: function (data) {
              UPLOAD2.setUploadedFiles(data);
              GRID.setData(UPLOAD2.uploadedFiles);
          }
      };

      UPACTIONS["INIT"]();
      UPACTIONS["GET_uploaded"]();
        
        
       
 //   });
</script>