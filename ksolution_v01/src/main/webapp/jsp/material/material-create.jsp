<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags"%>
<% 
    request.setAttribute("oid", request.getParameter("oid"));
	request.setAttribute("menuId", request.getParameter("menuId"));
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
	<script type="text/javascript" src="/assets/plugins/bootstrap/dist/js/bootstrap.min.js"></script>
	<script type="text/javascript" src="/assets/plugins/select2-4.0.3/dist/js/select2.min.js"></script>
<!-- 	<script type="text/javascript" src="/assets/plugins/ax5ui-toast/dist/ax5toast.min.js"></script> -->
    </jsp:attribute>
    
    <jsp:attribute name="css">
        <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-dialog/dist/ax5dialog.css"/>
		 <link rel="stylesheet" type="text/css" href="/assets/plugins/ax5ui-uploader/dist/ax5uploader.css"/>
		 <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
		 <link href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css" rel="stylesheet" type="text/css" />
		 <link href="/assets/plugins/select2-4.0.3/dist/css/select2.min.css" rel="stylesheet" />
		 <link href="/assets/css/axboot.css" rel="stylesheet" />  
<!-- 		 <link href="/img/test.css" rel="stylesheet" /> -->
    </jsp:attribute>
    
   
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/material/material.js' />"></script>
    </jsp:attribute>
           
    
	<jsp:body>

  		
  		<ax:page-buttons></ax:page-buttons>
		<div class="ax-button-group" role="panel-header">
                    <div class="left">
                        <h2><i class="cqc-news"></i>
                            <ax:lang id="ax.admin.sample.parent.information"/>
                        </h2>
                    </div>
                   <%--  <div class="right">
                        <button type="button" class="btn btn-default" data-form-view-01-btn="form-clear">
                            <i class="cqc-erase"></i>
                            <ax:lang id="ax.admin.clear"/>
                        </button>
                    </div> --%>
                </div>
                <ax:form name="formView01">
                	<input type="hidden" name="oid" data-ax-path="oid"  value="${oid}" />
                	<input type="hidden" name="menuId" data-ax-path="menuId"  value="${menuId}" />
              
                    <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        
                        <div data-ax-tr="" id="" class="" style="">
	                        
	                           	<div data-ax-td="" id="" class="" style="">
	                           <div data-ax-td-label="" class="" style="width:200px">자재유무</div>
	                           <div data-ax-td-wrap="" style="width:200px">
			<!-- 				        <select class="js-example-basic-single js-states form-control" title="분류" name="typeOid" data-ax-path="typeOid" id="id_label_single" data-ax-validate="required" ></select>
	         -->
	         					<ax:common-code groupCd="M_EXIST" defaultValue="0" dataPath="m_exist" name="m_exist" type="radio"/>
	                            	
            
	                           	
	                        </div>
	                           	
	                        <div data-ax-td-label="" class="" style="width:100px" >분류 *</div>
				                    <div data-ax-td-wrap="" style="width:300px">	
				                    <!--<select class="js-example-basic-single js-states form-control" title="분류" name="typeOid" data-ax-path="typeOid" id="id_label_single" data-ax-validate="required" ></select>-->
							            <select class="form-control inline-block W90" id="level1" data-ax-path="level1"></select>
				                        <select class="form-control inline-block W90" id="level2" data-ax-path="level2"></select>
				                        <select class="form-control inline-block W90" id="level3" data-ax-path="level3" title="분류"></select>
				                    </div>
	                         </div>
	                         
	                        
				        </div>
	                         
                           	
                     
	                    <ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">명칭</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="">
				                            <div data-ax-td-label="" class="" style="width:100px" >브랜드</div>
				                            <div data-ax-td-wrap="" style="width:200px">
				                           		<select class="js-data-manufacturerId js-states form-control" name=manufacturerId data-ax-path="manufacturerId" width=100%>
												</select>
				                           		<!-- <input type="text" data-ax-path="brand" class="form-control" /> -->
				                           	</div>
				                           	<!-- <div data-ax-td-label="" class="" style="width:100px" >콜렉션</div>
				                           <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="collection" class="form-control" />
				                           	</div> -->
				                        </ax:tr>
				                        
				                        <ax:tr style="border:0px;">
				                           <div data-ax-td-label="" class="" style="width:100px" >시리즈</div>
				                           <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="seriese" class="form-control" />
				                           	</div>
				                           	 <div data-ax-td-label="" class="" style="width:100px" >품번*</div>
				                           <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="number" class="form-control"  title="품번" data-ax-validate="required" />
				                           	</div>
				                        </ax:tr>
				                   
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   					<ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">       
	    						<div data-ax-td-label="" class="" style="width:100px">가격</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="border:0px;">
				                            <div data-ax-td-label="" class="" style="width:100px" >소비자가</div>
				                            <div data-ax-td-wrap="" style="width:200px">				                           		
				                           		<input type="text" data-ax-path="cmprice" class="form-control" data-ax5formatter="money" value=""/>
				                           		
				                           	</div>
				                           	
				                           	 <div data-ax-td-label="" class="" style="width:100px" >구매제안가</div>
				                             <div data-ax-td-wrap="" style="width:300px">
				                           		<input type="text" data-ax-path="dpprice" class="form-control inline-block W190" data-ax5formatter="money"/>
				                           		<ax:common-code groupCd="UNIT" clazz="inline-block W80" defaultValue="0" dataPath="unit" name="unit" type="select"/>
				                           	</div>
				                        </ax:tr>
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   					
	   					
                        <ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">디자인 속성</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						<ax:tbl clazz="ax-form-tbl" minWidth="600px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						
				   						
				   						<ax:tr  style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >광택</div>
				                            <div data-ax-td-wrap="" style="width:600px">
				                           		<ax:common-code groupCd="D1"  defaultValue="유광" dataPath="gloss" name="gloss" type="radio"/>
				                           	</div>
				                        </ax:tr>
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" type="radio">표면강도</div>
				                            <div data-ax-td-wrap="" style="width:600px">
				                           		<ax:common-code groupCd="D2"  defaultValue="" dataPath="hardness" name="hardness" type="radio"/>
				                           	</div>
				                        </ax:tr>
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >표면질감</div>
				                            <div data-ax-td-wrap="" style="width:600px">
				                           		<ax:common-code groupCd="D3"  defaultValue="" dataPath="feel" name="feel" type="radio"/>
				                           	</div>
				                        </ax:tr>
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >패턴</div>
				                            <div data-ax-td-wrap="" style="width:600px">
				                           		<ax:common-code groupCd="D4"  defaultValue="" dataPath="pattern" name="pattern" type="radio"/>
				                           	</div>
				                        </ax:tr>
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >밝기</div>
				                            <div data-ax-td-wrap="" style="width:600px">
				                           		<ax:common-code groupCd="D5"  defaultValue="" dataPath="brightness" name="brightness" type="radio" />
				                           	</div>
				                        </ax:tr>
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >색조</div>
				                            <div data-ax-td-wrap="" style="width:620px">
				                           		<ax:common-code groupCd="D6"  defaultValue="" dataPath="shade" name="shade" type="radio" />
				                           	</div>
				                        </ax:tr>
				                        <ax:tr style="border:0px;">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >유통사 추천</div>
				                            <div data-ax-td-wrap="" style="width:600px">
				                           		<ax:common-code groupCd="D7"  defaultValue="" dataPath="recommend" name="recommend" type="radio"/>
				                           	</div>
				                        </ax:tr>
				                       
				                     
			                        </ax:tbl>
								</div>
							</div>
	   					</ax:tr>
	   					
	   					<%-- <ax:tr>
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">제조사 정보</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="border:0px;">
				                            <div data-ax-td-label="" class="" style="width:100px" >제조사</div>
				                            <div data-ax-td-wrap="" style="width:200px">				                           		
				                           		<select class="js-data-manufacturerId js-states form-control" name=manufacturerId data-ax-path="manufacturerId" width=100%>
												</select>
				                           	</div>
				                           	
				                           	 <!-- <div data-ax-td-label="" class="" style="width:100px" >홈페이지</div>
				                             <div data-ax-td-wrap="" style="width:200px"> 
				                           		
				                           	</div>-->
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
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">유통사</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="border:0px;">
				                            <div data-ax-td-label="" class="" style="width:100px" >회사명</div>
				                            <div data-ax-td-wrap="" style="width:200px">				                           		
			                           		    <select class="js-data-example-ajax js-states form-control" name="distributionId" data-ax-path="distributionId" width=100%>
												       
												</select>
				                           	</div>
				                           	
				                           <!-- <div data-ax-td-label="" class="" style="width:100px" >유통지위</div>
				                           <div data-ax-td-wrap="" style="width:200px"> -->
				                           	    <!--  <select data-ax-path="location" class="form-control W100">
				                                    <option value="L1">본사</option>
				                                    <option value="l2">총판</option>
				                                    <option value="L3">대리점</option>
				                                    <option value="L4">판매자</option>
				                                    <option value="L5">수입총판</option>
			                                	</select>
				                           	</div>-->
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
	                        <div data-ax-td="" id="" class="" style="width:100%">
	                           
				                
	    						<div data-ax-td-label="" class="" style="width:100px">제품설명</div>
		   						
		   						<div data-ax-td="" class="" style="width:100%">
			   						 <ax:tbl clazz="ax-form-tbl" minWidth="500px" style="border-left:0;border-top:0;border-bottom:0;border-right:0;">
				   						<ax:tr  style="">
				                            <div data-ax-td-label="" class="" style="width:100px" >용도</div>
				                            <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="useName" class="form-control" />
				                           	</div>
				                           	 <div data-ax-td-label="" class="" style="width:100px" >규격</div>
				                           <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="spec" class="form-control" />
				                           	</div>
				                        </ax:tr>
				                        <ax:tr  style="">
				                            <div data-ax-td-label="" class="" style="width:100px" >제조사</div>
				                            <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="mcName" class="form-control" />
				                           	</div>
				                            <div data-ax-td-label="" class="" style="width:100px" >출시년도</div>
				                           	<div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="releaseYear" class="form-control" />
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr  style="">
				                            <div data-ax-td-label="" class="" style="width:100px" >원산지</div>
				                            <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="origin" class="form-control" />
				                           	</div>
				                           	 <div data-ax-td-label="" class="" style="width:100px" >기술적 성능지표</div>
				                           <div data-ax-td-wrap="" style="width:200px">
				                           		<input type="text" data-ax-path="tec_des" class="form-control" />
				                           	</div>
				                        </ax:tr>
				                       
				                        
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >설명</div>
				                           <div data-ax-td-wrap="" style="width:500px">
				                           		<textarea data-ax-path="product_des" class="form-control" rows="3"></textarea>
				                           	</div>
				                        </ax:tr>
				                        
				                        <ax:tr style="">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >동영상 URL</div>
				                           <div data-ax-td-wrap="" style="width:500px">
				                           		<input type="text" data-ax-path="product_des_url" class="form-control"></input>
				                           	</div>
				                        </ax:tr>
				                        
				                         <ax:tr style="border:0px;width:*">
				                           <div data-ax-td-label="" class="" style="width:100px;:height:100px" >시공사 유의 사항</div>
				                           <div data-ax-td-wrap="" style="width:500px">
				                           		<textarea data-ax-path="discussion" class="form-control" rows="3"></textarea>
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
                        <div class="right">
                        	<div data-ax5uploader="upload2" data-btn-wrap>
	                         	<button data-ax5uploader-button="selector" class="btn btn-default">
	                                <i class="cqc-plus"></i>
	                                	주가
	                            </button>
                               
	                            <button type="button" class="btn btn-default" data-upload-btn="removeFile">
	                                <i class="cqc-minus"></i>
	                                	삭제
	                            </button>
	                          
                          </div>
                        </div>
                    </div>
                    
                    <!-- <div class="DH20"></div>
 
					<div data-ax5uploader="upload1">
					    <button data-ax5uploader-button="selector" class="btn btn-primary">Select File (*/*)</button>
					    (Upload Max fileSize 20MB)
					</div> --> 
					 
					<div class="DH20"></div>
					 
					<div data-ax5grid="first-grid" data-ax5grid-config="{
					                    header: {align: 'center'},
					                    showLineNumber: false,
					                    showRowSelector: true,
					                    multipleSelect: false,
					                    lineNumberColumnWidth: 20,
					                    rowSelectorColumnWidth: 27
					                }" style="height: 100px;"></div>

                    <div class="H5"></div>
                    <div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i> 사진 파일</h3>
                        </div>
                        <div class="right">
                        	<div data-ax5uploader="upload1" data-btn-wrap>
	                            <button data-ax5uploader-button="selector" class="btn btn-default">
	                                <i class="cqc-plus"></i>
	                                	주가
	                            </button>
                               
	                            
                            </div>
                        </div>
                    </div>

                    <div class="DH20"></div>
 
					<div data-ax5uploader="upload1">
						<input type="hidden" name="targetId" value="111"/>
					  <!--   <button data-ax5uploader-button="selector" class="btn btn-primary">Select File (*/*)</button>
					    (Upload Max fileSize 20MB) -->
					    <div data-uploaded-box="upload1" data-ax5uploader-uploaded-box="thumbnail"></div>
					</div>
					 
					 <!-- <div style="padding: 0;" data-btn-wrap>
					    <h3>control</h3>
					    <button class="btn btn-default" data-upload-btn="getUploadedFiles">getUploadedFiles</button>
					    <button class="btn btn-default" data-upload-btn="removeFileAll">removeFileAll</button>
					</div> -->
					
				
					
                </ax:form>
</jsp:body>
</ax:layout>

<script type="text/javascript">



  //  $(function () {
        var API_SERVER = "";
        var DIALOG = new ax5.ui.dialog({
            title: "AX5UI"
        });
        var UPLOAD = new ax5.ui.uploader({
            //debug: true,
            target: $('[data-ax5uploader="upload1"]'),
            form: {
                action: API_SERVER + "/api/v1/ax5uploader/upload",
                fileName: "file"
            },
            multiple: true,
            manualUpload: false,
            progressBox: true,
            progressBoxDirection: "left",
            dropZone: {
                target: $('[data-uploaded-box="upload1"]')
            },
            uploadedBox: {
                target: $('[data-uploaded-box="upload1"]'),
                icon: {
                    "download": '<i class="fa fa-download" aria-hidden="true"></i>',
                    "delete": '<i class="fa fa-minus-circle" aria-hidden="true"></i>'
                },
                columnKeys: {
                    apiServerUrl: "",
                    name: "fileNm",
                    type: "ext",
                    size: "fileSize",
                    uploadedName: "saveName",
                    thumbnail: "thumbnail"
                },
                lang: {
                    supportedHTML5_emptyListMsg: '<div class="text-center" style="padding-top: 30px;">이미지 파일을 드래그 하여 올려 놓으세요</div>',
                    emptyListMsg: '<div class="text-center" style="padding-top: 30px;">파일이 없습니다</div>'
                },
                onchange: function () {
 
                },
                onclick: function () {
                	
                	
                    // console.log(this.cellType);
                    var fileIndex = this.fileIndex;
                    var file = this.uploadedFiles[fileIndex];
                    switch (this.cellType) {
                        case "delete": UPLOAD.removeFile(fileIndex);
                      /*  DIALOG.confirm({
                                title: "AX5UI",
                                msg: "Are you sure you want to delete it?"
                            }, function () {
                                if (this.key == "ok") {
                                	
                                	
                                     $.ajax({
                                        contentType: "application/json",
                                        method: "post",
                                        url: API_SERVER + "/api/v1/ax5uploader/delete",
                                        data: JSON.stringify([{
                                            id: file.id
                                        }]),
                                        success: function (res) {
                                            if (res.error) {
                                                alert(res.error.message);
                                                return;
                                            }
                                            UPLOAD.removeFile(fileIndex);
                                        }
                                    }); 
                                }
                            }); */
                       
                            break;
 
                        case "download":
                            if (file.download) {
                                location.href = API_SERVER + file.download;
                            }
                            break;
                    }
                }
            },
            validateSelectedFiles: function () {
                /* console.log("validateSelected ", this);
                
                this.selectedFiles.forEach(function (file) {
                    
                });
 */
                
                // 10개 이상 업로드 되지 않도록 제한.
                if (this.uploadedFiles.length + this.selectedFiles.length > 3) {
                    alert("이미지 파일은 3개 까지만 올릴 수 있습니다.");
                    return false;
                }
 
                return true;
            },
            onprogress: function () {
 
            },
            onuploaderror: function () {
                console.log(this.error);
                DIALOG.alert(this.error.message);
            },
            onuploaded: function () {
 
            },
            onuploadComplete: function () {
 
            },
            accept : "image/*"
        });
        
   
 
        // 파일 목록 가져오기
        $.ajax({
            method: "GET",
            url: API_SERVER + "/api/v1/ax5uploader/list?id=${oid}&contentType=IMG_FILE&targetType=Material_M",
            success: function (res) {
                console.log("list get", res);
                UPLOAD.setUploadedFiles(res);
            }
        });
 
        //console.log("$('[data-btn-wrap]')", $('[data-btn-wrap]'));
        // 컨트롤 버튼 이벤트 제어
        $('[data-btn-wrap]').clickAttr(this, "data-upload-btn", {
            "getUploadedFiles": function () {
            	
                var files = ax5.util.deepCopy(UPLOAD.uploadedFiles);
                console.log(files);
                DIALOG.alert(JSON.stringify(files));
            },
            "removeFileAll": function () {
 
                DIALOG.confirm({
                    title: "AX5UI",
                    msg: "Are you sure you want to delete it?"
                }, function () {
 
                    if (this.key == "ok") {
 
                        var deleteFiles = [];
                        UPLOAD.uploadedFiles.forEach(function (f) {
                            deleteFiles.push({id: f.id});
                        });
 
                        $.ajax({
                            contentType: "application/json",
                            method: "post",
                            url: API_SERVER + "/api/v1/ax5uploader/delete",
                            data: JSON.stringify(deleteFiles),
                            success: function (res) {
                                if (res.error) {
                                    alert(res.error.message);
                                    return;
                                }
 
                                UPLOAD.removeFileAll();
                            }
                        });
 
                    }
                });
            }
        });
    //});
    
    
</script>


<script type="text/javascript">



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
                console.log(this);
                // 10개 이상 업로드 되지 않도록 제한.
                if (this.uploadedFiles.length + this.selectedFiles.length > 5) {
                    alert("파일은 5개 까지만 올릴 수 있습니다.");
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
                    url: API_SERVER + "/api/v1/ax5uploader/list?id=${oid}&contentType=DOC_FILE&targetType=Material_M",
                    success: function (res) {
                        uploadView.setData(res);
                    }
                });
            },
            "DELETE_files": function (data) {
            	//console.log("DELETE_files ", data);
            	
            	data.forEach(function (f) {
                    f.__deleted__ = true ;
                });
            	
            	
            	GRID.deleteRow("selected");
            	
            	data.forEach(function (f) {
                   alert(f.__deleted__);
            		//f.__deleted__ = true ;
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