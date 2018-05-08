<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags"%>

<ax:set key="system-auth-user-version" value="1.0.0" />
<ax:set key="title" value="${pageName}" />
<ax:set key="page_desc" value="${pageRemark}" />
<ax:set key="page_auto_height" value="true" />

<ax:layout name="base">
	<jsp:attribute name="script">
        <ax:script-lang key="ax.script" var="LANG" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript"
			src="<c:url value='/assets/js/axboot/material/material-list.js' />"></script>
    	 <script type="text/javascript">

				$(document).on('click', '[data-toggle="lightbox"]', function(event) {
					 	event.preventDefault();
					$(this).ekkoLightbox();
				});
		</script>
    </jsp:attribute>

	<jsp:attribute name="js">
<!--     <script type="text/javascript" src="/assets/plugins/ax5core/dist/ax5core.min.js"></script> -->
	<script type="text/javascript"
			src=<c:url value="/assets/plugins/ax5ui-dialog/dist/ax5dialog.js" /> ></script>
	<script type="text/javascript"
			src=<c:url value="/assets/plugins/ax5ui-uploader/dist/ax5uploader.js" />></script>
	<script type="text/javascript"
			src=<c:url value="/assets/plugins/ax5ui-grid/dist/ax5grid.min.js" />></script>
	<script
			src="https://cdn.rawgit.com/thomasJang/jquery-direct/master/dist/jquery-direct.min.js"></script>
	<script type="text/javascript"
			src="<c:url value="/assets/plugins/select2-4.0.3/dist/js/select2.min.js" />></script>
	
	<script
			src=<c:url value="/assets/plugins/bootstrap-fileinput-master/js/plugins/sortable.js" />
			type="text/javascript"></script>
    <script
			src="<c:url value='/assets/plugins/bootstrap-fileinput-master/js/fileinput.js' />" 
			type="text/javascript"></script>
    <script
			src="<c:url value='/assets/plugins/bootstrap-fileinput-master/js/locales/fr.js' />"
			type="text/javascript"></script>
    <script
			src="<c:url value='/assets/plugins/bootstrap-fileinput-master/js/locales/es.js' />"
			type="text/javascript"></script>
    <script
			src=<c:url value='/assets/plugins/bootstrap-fileinput-master/themes/explorer/theme.js'/>
			type="text/javascript"></script>
    <script src="<c:url value='/assets/js/common/jquery.form.js' />"
			type="text/javascript"></script>
    <script src="<c:url value='/assets/plugins/bootstrap/dist/js/bootstrap.min.js' />"
			type="text/javascript"></script>
	<script src="<c:url value='/assets/plugins/mustache.js/mustache.js' />"
			type="text/javascript"></script>

	<script type="text/javascript"
			src="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.min.js"></script>
	<script type="text/javascript"
			src="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.js"></script>
	</jsp:attribute>
	<jsp:attribute name="css">
        <!--  <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-dialog/dist/ax5dialog.css"/>
		 <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-uploader/dist/ax5uploader.css"/> -->
		 
		 <link
			href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css"
			rel="stylesheet" type="text/css" />
		 <link
			href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css"
			rel="stylesheet" type="text/css" />
		 <link href="/assets/plugins/select2-4.0.3/dist/css/select2.min.css"
			rel="stylesheet" />
		 <link href="/img/test.css" rel="stylesheet" />
    	<link
			href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"
			rel="stylesheet">
    	<link
			href="/assets/plugins/bootstrap-fileinput-master/css/fileinput.css"
			media="all" rel="stylesheet" type="text/css" />
   		<link
			href="/assets/plugins/bootstrap-fileinput-master/themes/explorer/theme.css"
			media="all" rel="stylesheet" type="text/css" />
   		
   		
   		<link
			href="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.min.css"
			media="all" rel="stylesheet" type="text/css" />
   		<link
			href="https://cdnjs.cloudflare.com/ajax/libs/ekko-lightbox/5.1.1/ekko-lightbox.css"
			media="all" rel="stylesheet" type="text/css" />
   		
   		
		 <link href=<c:url value="/assets/css/axboot.css" /> rel="stylesheet" />  
		
    </jsp:attribute>
	<jsp:body>

        <ax:page-buttons></ax:page-buttons>

        <!-- 검색바 -->
        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="900px">
                    <ax:tr>        
                        <ax:td label="일련 번호" width="300px">
                            <input type="text" data-ax-path="seqNumber"
								class="form-control" value=""
								placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        
                          <ax:td label="소비자가" width="300px">
                                <input type="text" data-ax-path="price1"
								class="form-control inline-block W80" data-ax5formatter="money" />~
                                <input type="text" data-ax-path="price2"
								class="form-control inline-block W80" data-ax5formatter="money" />  
                            </ax:td>  
                            
                        <ax:td label="브랜드" width="300px">
                            <input type="text" data-ax-path="mfCompany"
								class="form-control" value=""
								placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="유통사" width="300px">
                            <input type="text" data-ax-path="disCompany"
							    class="form-control" value=""
								placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td> 
                       
                            
                        <%-- <ax:td label="소비자가" width="300px"> 
                          <div class="button-warp">
                            <input type="text" data-ax-path="price1" class="form-control W100" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                            <input type="text" data-ax-path="price1" class="form-control W100" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                           </div> 
                        </ax:td>
                         --%>
                           <%--  <ax:td label="ax.admin.sample.form.code" width="300px">
                                <input type="text" data-ax-path="etc3" class="form-control W60" />
                                <input type="text" data-ax-path="etc4" class="form-control W60" />
                            </ax:td> --%>
                    </ax:tr>
                    <ax:tr>
                    
    <!--                   <div data-ax-td="" id="" class="" style="">
                        <div data-ax-td-label="" class="" style="width:100px">분류</div>
                        <div class="button-warp">
                          <div class="form-group">
        					<div data-ax5select="select1" style="width:150px;height:28px" ></div>
    				
    					    <div data-ax5select="select2" style="width:150px;height:28px"></div>      
	
					        <div data-ax5select="select3" style="width:150px;height:28px"></div>
					      </div>
					    </div>
                        </div>
                         -->
                        
                        <ax:td label="분류" width="600px"> 
                        
	                        <select class="form-control inline-block W160"
									id="level1" data-ax-path="level1"></select>
	                        <select class="form-control inline-block W160"
									id="level2" data-ax-path="level2"></select>
	                        <select class="form-control inline-block W160"
									id="level3" data-ax-path="level3"></select>
                        
                              
                       </ax:td>
                       
                        <%-- <ax:td label="브랜드" width="300px"> 
                            <input type="text" data-ax-path="mfCompany"
								class="form-control" value=""
								placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>  --%> 
                        
                        <ax:td label="규격" width="300px">
                            <input type="text" data-ax-path="specName"
								class="form-control" value=""
								placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td>
                        <ax:td label="원산지" width="300px">
                            <input type="text" data-ax-path="location"
								class="form-control" value=""
								placeholder="<ax:lang id="ax.admin.input.search"/>" />
                        </ax:td> 
                        
                    </ax:tr>
                    <ax:tr>
                        <ax:td label="광택" width="300px">
                            <ax:common-code groupCd="D1"  emptyValue="" emptyText="전체" defaultValue="" dataPath="gloss" name="gloss"/>
                        </ax:td>
                        <ax:td label="표면강도" width="300px">
                        	<ax:common-code groupCd="D2"   emptyValue="" emptyText="전체" dataPath="hardness" name="hardness"/>
                        </ax:td>
                        <ax:td label="표면질감" width="300px">
                            <ax:common-code groupCd="D3"  emptyValue="" emptyText="전체" dataPath="feel" name="feel" />
                        </ax:td> 
                        <ax:td label="패턴" width="300px">
                            <ax:common-code groupCd="D4"  emptyValue="" emptyText="전체" dataPath="pattern" name="pattern" />
                        </ax:td> 
                    </ax:tr>
                    
                    <ax:tr>
                        <ax:td label="밝기" width="300px">
                            <ax:common-code groupCd="D5"  emptyValue="" emptyText="전체" defaultValue="" dataPath="brightness" name="brightness"/>
                        </ax:td>
                        <ax:td label="색조" width="300px">
                        	<ax:common-code groupCd="D6"   emptyValue="" emptyText="전체" dataPath="shade" name="shade"/>
                        </ax:td>
                        <ax:td label="유통사 추천" width="300px">
                            <ax:common-code groupCd="D7"  emptyValue="" emptyText="전체" dataPath="recommend" name="recommend" />
                        </ax:td> 
                    </ax:tr>
                   
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>
        <div data-thumbview
			style="position: absolute; border: 1px solid black; display: none; z-index: 99999999999999999;"></div>
        <ax:split-layout name="ax1" orientation="vertical">
        	<ax:split-panel width="450" style="padding-right: 10px;">
        	
                <!-- 목록 -->
                <div class="ax-button-group"
					data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2>
							<i class="cqc-list"></i>
                            자재목록
                        </h2>
                    </div>
                    <div class="right">
                    
                    </div>
                </div>
                <div data-ax5grid="grid-view-01"
					data-fit-height-content="grid-view-01" style="height: 300px;"></div>
             </ax:split-panel>
             <%-- <ax:splitter></ax:splitter> --%>
             <ax:split-panel width="*" style="padding-left: 10px;"
				scroll="scroll">
             <div class="ax-button-group" role="panel-header">
                    <div class="left">
                        <h2>
							<i class="cqc-news"></i>
                            자재 정보
                        </h2>
                    </div>
                    <div class="right" id="actionButton"
						style="display: none">
                    	<%-- <ax:folderSelect id="folderOid"
							style="width:200px;height:28px" /> --%>
						<!-- <div data-ax5select="select2"  data-ax5select-config="{
                     		name: 'folderOid', minWidth: 150}"></div>
                     	 -->	
                     	<select id = "folderOid" class="folderSelect" style="width:200px;height:28px"  data-allow-clear="true" name="folderOid"></select>		
                    	<button class="btn btn-default"
							data-form-view-01-btn="addFolder" style="margin-left: 5px">
							<i class="cqc-magnifier"></i>즐겨찾기 추가</button>
        			    <button class="btn btn-default"
							data-form-view-01-btn="folder" style="margin-left: 5px">
							<i class="cqc-magnifier"></i>폴더 생성</button>
         				
         				<button type="button" id="updateButton" class="btn btn-info"
							style="margin-left: 5px" data-form-view-01-btn="update" >
							<i class="axi axi-file-excel-o"></i>수정</button>
         				
                        <%-- <button type="button" class="btn btn-default" data-form-view-01-btn="form-clear">
                            <i class="cqc-erase"></i>
                            <ax:lang id="ax.admin.clear"/>
                        </button> --%>
                    </div>
                </div>
                
  	 <ax:form name="formView01">
  	 	

	                
               
               
                  
   
   



                     <div data-ax5grid="img-grid" id="target"
						data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: true,
					                    multipleSelect: false,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					                }"
						style="height: 150px; display: none">
					     
					    
					    <%--  <c:forEach items="${imgList}" var="imgItem">
     	        
     	        			    <!-- <a href="/api/v1/ax5uploader/thumbnail.jpg?id=31" data-toggle="lightbox" data-gallery="example-gallery" class="col-sm-4">
									<img src="/api/v1/ax5uploader/thumbnail?id=31" class="img-fluid">
								</a> -->
								 <a href="${imgItem._thumbnail}" data-toggle="lightbox" data-gallery="example-gallery" style="margin-left:5px" data-title="이미지 파일" > 
									<img src="${imgItem._thumbnail}" class="img-rounded" width="204" height="150">
								</a>
								
						  </c:forEach> --%>
					
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
                
                	<input type="hidden" name="oid" data-ax-path="oid" />
                    <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        
                        <ax:tr>
	                        <div data-ax-td="" id="" class=""
								style="width: 100%">
	                           
				                
	    						
		   						<div data-ax-td="" class="" style="width: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   			            
				                         <ax:tr style="border:0px;width:*">
				                           <div data-ax-td-label="" class=""
												style="width: 200px; height: 40px">일련번호</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 500px">
				                       
				                           		 <div data-ax-path="serialNumber"
													style="display: inline-block;"></div>
				                           	
				                           	</div>
				                        </ax:tr>
				                        
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
                        <div data-ax-tr="" id="" class="" style="">
	                        <div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class=""
									style="width: 200px">분류</div>
	                           <div data-ax-td-wrap=""
									style="vertical-align: middle; width: 200px">
							        <div data-ax-path="typePath"
										style="display:inline-block;"></div>
	                           	</div>
	                           	
	                           
	                           	
	                        <div data-ax-td-label="" class=""
									style="width: 100px">자재유무</div>
				                           <div data-ax-td-wrap=""
									style="vertical-align: middle; width: 200px">
				                           		
				                           		 <div data-ax-path="m_exist_str"
										style="display: inline-block;"></div>
				                           	</div>
	                         </div>
	                        
				        </div>
	                    
	                    <div data-ax-tr="" id="" class="" style="">
	                        <div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class=""
									style="width: 200px">브랜드</div>
	                           <div data-ax-td-wrap=""
									style="vertical-align: middle; width: 200px">
							        <div data-ax-path="mfCompany.brand"
										style="display:inline-block;"></div>
	                           	</div>
	                           	
	                           
	                           	
	                        <div data-ax-td-label="" class=""
									style="width: 100px">홈페이지</div>
				                           <div data-ax-td-wrap=""
									style="vertical-align: middle; width: 200px">
				                           		
				                           	<a href="" target="_blank" data-ax-path="mfCompany.home_addr"><div data-ax-path="mfCompany.home_addr"
										style="display: inline-block;"></div></a>
				                           	</div>
	                         </div>
	                        
				        </div>
                           	
                     
	                    <ax:tr>
	                        <div data-ax-td="" id="" class=""
								style="width: 100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width: 101px">명칭</div>
		   						
		   						<div data-ax-td="" class="" style="width: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<%-- <ax:tr style="">
				                             <div data-ax-td-label="" class=""
												style="width: 100px">브랜드</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px">
				                           		
				                           		<div data-ax-path="mfCompany.brand"
													style="display: inline-block;"></div>
				                           	</div>
				                           	<div data-ax-td-label="" class=""
												style="width: 100px">홈페이지</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="mfCompany.home_addr">
				                           		
				                           		 <div data-ax-path="collection"
													style="display: inline-block;"></div>
				                           	</div> 
				                        </ax:tr> --%>
				                        
				                        <ax:tr style="border:0px;">
				                           <div data-ax-td-label="" class=""
												style="width: 100px">시리즈</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="seriese">
				                           		
				                           		 <div data-ax-path="seriese"
													style="display: inline-block;"></div>
				                           	</div>
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">품번</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="number">
				                           		
				                           		  <div data-ax-path="number"
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
	                           
				                
	    						<div data-ax-td-label="" class="" style="width: 101px">가격</div>
		   						
		   						<div data-ax-td="" class="" style="width: 100%; height: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr style="border:0px;">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">소비자가(<span data-ax-path="unit"></span>)</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="cmprice">
				                            
				                            <!-- <fmt:formatNumber type = "number" maxIntegerDigits = "10" data-ax-path="cmprice" />
		                           		     -->
		                           		      <div data-ax-path="cmprice"
													data-ax5formatter="money" style="display: inline-block;"></div>		
				                           		<!-- <input type="text" data-ax-path="cmprice" class="form-control" data-ax5formatter="money"/> -->
				                           	</div>
				                           	
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">구매제안가(<span data-ax-path="unit"></span>)</div>
				                             <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="dpprice">
				                           		  
				                           		  <div data-ax-path="dpprice"
													data-ax5formatter="money" style="display: inline-block;"></div>		
				                           		 
				                           	<%--  <fmt:formatNumber type = "number" maxIntegerDigits = "10" value = "${material.dpprice}" />
		                           --%>
				                             </div>
				                        </ax:tr>
				                        
				                     
				
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
<%-- 	   					<ax:tr>
	                        <div data-ax-td="" id="" class=""
								style="width: 100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width: 100px">제조사 정보</div>
		   						
		   						<div data-ax-td="" class="" style="width: 100%; height: 100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px"
										style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr style="border:0px;">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">제조사</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="cmprice">
				                           		 
				                           		  <div data-ax-path="mfCompany.brand"
													style="display: inline-block;"></div>				                            		
				                           		<!-- <input type="text" data-ax-path="cmprice" class="form-control" data-ax5formatter="money"/> -->
				                           	</div>
				                           	
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">제조사 홈페이지</div>
				                             <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px"
												data-ax-path="mfCompany.home_addr">
				                           		  <c:if test="${material.mfCompany ne null}">
				                           		  ${material.mfCompany.home_addr}
				                           		  </c:if>
				                           		  
				                           		  <div
													data-ax-path="mfCompany.home_addr"
													style="display: inline-block;"></div>
				                           		  
				                             </div>
				                        </ax:tr>
				                        
				                     
				
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr> --%>
	   					
	   					<!-- <div data-ax-tr="" id="" class="" style="">
	                        <div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class="" style="width:200px">원산지</div>
	                           <div data-ax-td-wrap="" style="width:200px">
	                           		<input type="text" data-ax-path="origin" class="form-control" />
	                           	</div>
	                         </div>  
                        </div> -->
                        
                        
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
												
												 <div data-ax-path="gloss"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">표면강도</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		  <div
													data-ax-path="hardness"
													style="display: inline-block;"></div>
				                           	</div>
				                        </ax:tr>
				                        
				                        <%-- <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">표면질감</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												
												 <div data-ax-path="feel"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">패턴</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 
				                           		  <div
													data-ax-path="pattern"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr> --%>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">밝기</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												
												 <div data-ax-path="brightness"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">색조</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 
				                           		  <div
													data-ax-path="shade"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">표면질감</div>
				                            <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">				                           		
												
												 <div data-ax-path="feel"
													style="display: inline-block;"></div>
				                           		  
				                           	</div>
				                           	
				                           <div data-ax-td-label="" class=""
												style="width: 100px">패턴</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
				                           		 
				                           		  <div
													data-ax-path="pattern"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        
				                        
				                        <ax:tr style="border:0px;width:*">
				                           <div data-ax-td-label="" class=""
												style="width: 100px; : height: 100px">유통사 추천</div>
				                           <div data-ax-td-wrap=""
												style="vertical-align: middle; width: 500px">
				                           		
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
				                           		  <a href="" target="_blank" data-ax-path="disCompany.home_addr">
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
			                                	
			                                	<div data-ax-path="useName"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">규격</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                  
			                                	<div data-ax-path="spec"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">제조사</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	
			                                	<div data-ax-path="mcName"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                           	 <div data-ax-td-label="" class=""
												style="width: 100px">출시년도</div>
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                  
			                                	<div data-ax-path="releaseYear"
													style="display: inline-block;"></div>
			                                	
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                            <div data-ax-td-label="" class=""
												style="width: 100px">원산지</div>
				                           
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	
			                                	<div data-ax-path="origin"
													style="display: inline-block;"></div>
				                           	</div>
				                           	
				                             <div data-ax-td-label="" class=""
												style="width: 100px">기술적 성능지표</div>
				                           
				                           	<div data-ax-td-wrap=""
												style="vertical-align: middle; width: 200px; height: 40px">
			                                	
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
				                           	 <a href = "" target="_blank" data-ax-path="product_des_url">
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
                        
          
                        
                        
                       <%--  
                        <ax:tr>
                            <ax:td label="ax.admin.sample.form.etc3" width="300px">
                                <select data-ax-path="etc3" class="form-control W100">
                                    <option value="Y"><ax:lang id="ax.admin.used"/></option>
                                    <option value="N"><ax:lang id="ax.admin.not.used"/></option>
                                </select>
                            </ax:td>
                            <ax:td label="ax.admin.sample.form.etc4" width="220px">
                                <ax:common-code groupCd="USER_STATUS" dataPath="userStatus"/>
                            </ax:td>
                        </ax:tr>
                        <ax:tr>
                            <ax:td label="ax.admin.sample.form.etc5" width="100%">
                                <textarea data-ax-path="etc5" class="form-control"></textarea>
                            </ax:td>
                        </ax:tr> --%>
                    </ax:tbl>
                    
                    <div class="H5"></div>
                    <div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i> 시공특이사항 (첨부 파일)</h3>
                        </div>
                        
                    </div>
                    
                   
					 
					<div class="DH20"></div>
					 
					<div data-ax5grid="first-grid"
						data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: true,
					                    multipleSelect: false,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					                }"
						style="height: 100px;"></div>
					                
		
		
					                                   
</ax:form>
 
 <div class="H5"></div>
                    <div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i> 사용자 리뷰</h3>
                        </div>
                        
                    </div>

<div class="container-full" id="comment-target"> 
</div><!-- /container -->
<div class="row">
    <div class="col-lg-12"> 
        <div class="panel panel-info">
            <div class="panel-body">
            <form class="form-inline" id="fileForm" action="/api/v1/material/commend" enctype="multipart/form-data">
                <input type="hidden" name="oid" data-ax-path="oid" />
                <textarea placeholder="의견을 적으세요" name="comment" data-ax-path="comment" class="pb-cmnt-textarea"></textarea>
                
                	
                    <div class="pull-left">
                       <input id="input-1a" type="file" name="file" size="40" data-ax-path="file" data-show-preview="false" > 
                    </div>
                    
                    <button class="btn btn-primary pull-right" type="button" data-form-view-01-btn="commendSave" id="commendSave">Share</button>
                </form>
            </div>
        </div>
    </div>
</div>
 
 <div data-manual-content="tmpl" style="display: none">
 {{#.}}
 <a href="{{thumbnail}}" data-toggle="lightbox"
						data-gallery="example-gallery" data-title="이미지 파일"
						style="margin-left: 5px"> 
									<img src="{{thumbnail}}" class="img-rounded" width="160"
						height="160">						</a>
  {{/.}} 
 </div>


<div id="commenttemplate" style="display: none">
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
</div>



                
             </ax:split-panel>    
        </ax:split-layout>
    </jsp:body>
</ax:layout>

<script type="text/javascript">
/* var options = [];
for (var i = 0; i < 100; i++) {
    options.push({value: "optionValue" + i, text: "optionText" + i});
}
$(document.body).ready(function(){
    $('[data-ax5select]').ax5select({
        options: options
    });
}); */

function deleteComment(oid){
	ACTIONS.dispatch(ACTIONS.DELTECOMMENT, {oid: oid});
}
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
                  	//alert(API_SERVER + this.item.download);
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
              var oid = $("[name='oid']").val();
            //  alert(oid);
              $.ajax({
                  method: "GET",
                  url: API_SERVER + "/api/v1/ax5uploader/list?contentType=DOC_FILE&targetType=Material_M&id=" + oid,
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

      /* UPACTIONS["INIT"]();
      UPACTIONS["GET_uploaded"](); */
        
        
       
 //   });
</script>