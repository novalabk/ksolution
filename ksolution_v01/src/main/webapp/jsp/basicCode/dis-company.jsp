<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="system-auth-user-version" value="1.0.0"/>
<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="js">

	  <script type="text/javascript" src=<c:url value="/assets/plugins/select2-4.0.3/dist/js/select2.min.js"/> ></script>
	
    </jsp:attribute>
    
    <jsp:attribute name="css">
       	 <link href=<c:url value="/assets/plugins/select2-4.0.3/dist/css/select2.min.css"/> rel="stylesheet" />
    </jsp:attribute>
	<jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <ax:script-lang key="ax.admin" var="COL" />
        <script type="text/javascript" src="<c:url value='/assets/js/axboot/basicCode/dis-company.js'/>"></script>
    </jsp:attribute>
    
    <jsp:body>

        <ax:page-buttons></ax:page-buttons>

        <!-- 검색바 -->
        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label="ax.admin.search" width="300px">
                            <input type="text" name="filter" id="filter" class="form-control" value="" placeholder="<ax:lang id="ax.admin.input.search"/>"/>
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="50%" style="padding-right: 10px;">

                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>
                            유통업체 목록
                        </h2>
                    </div>
                    <div class="right"></div>
                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>

            </ax:split-panel>
            
            <ax:splitter></ax:splitter>
            
            <ax:split-panel width="*" style="padding-left: 10px;" scroll="scroll">

                <!-- 폼 -->
                <div class="ax-button-group" role="panel-header">
                    <div class="left">
                        <h2><i class="cqc-news"></i>
                         	기업정보	
                        </h2>
                    </div>
                    <div class="right">
                        <button type="button" class="btn btn-default" data-form-view-01-btn="form-clear">
                            <i class="cqc-erase"></i>
                            <ax:lang id="ax.admin.clear"/>
                        </button>
                        
                        <button type="button" class="btn btn-default" data-form-view-01-btn="form-delete">
                            <i class="cqc-erase"></i>삭제
                        </button>
                    </div>
                </div>


                <ax:form name="formView01">
                    <input type="hidden" name="oid" id="oid" value=""/>
                    <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        <ax:tr labelWidth="120px">
                            <ax:td label="취급품목" width="500px" >
                               
                            <!--     <select class="js-example-basic-single js-states form-control" multiple="multiple" id="id_label_single" data-ax-validate="required"></select>
                             -->
                             <input type="text" name="type_des" data-ax-path="type_des" maxlength="100" title="취급품목" class="av-required form-control W220" value=""/>
                            </ax:td>
                        </ax:tr>
                        
                        <ax:tr labelWidth="120px">
                           <ax:td label="배송가능 지역" width="300px">
                                <input type="text" name="dis_area" data-ax-path="dis_area" maxlength="100" title="배송가능 지역" class="av-required form-control W150" value="" />
                            </ax:td>
                            <ax:td label="배송정책" width="300px">
                            	<ax:common-code groupCd="DPRICE_TYPE" defaultValue="배송비 포함" dataPath="dis_pirce_type" name="dis_pirce_type" type="radio"/>
                            </ax:td>
                            
                        </ax:tr>
                        
                        
                        
                        <ax:tr labelWidth="120px">
                           <ax:td label="상호 *" width="300px">
                                <input type="text" name="companyNm" data-ax-path="companyNm" maxlength="100" title="상호" class="av-required form-control W150" value="" data-ax-validate="required"/>
                            </ax:td>
                            <ax:td label="대표자" width="300px">
                                <input type="text" name="ceo_name" data-ax-path="companyNm" maxlength="15" title="대표자" class="av-required form-control W150" value=""/>
                            </ax:td>
                            
                        </ax:tr>
                        
                        <ax:tr labelWidth="120px">
                           <ax:td label="사업자등록번호" width="300px">
                                <input type="text" name="businessNumber" data-ax-path="businessNumber" maxlength="100" title="아이디" class="av-required form-control W150" value=""/>
                            </ax:td>
                            <ax:td label="대표연락처" width="300px">
                                <input type="text" name="title_phnumber" data-ax-path="title_phnumber" maxlength="50" title="" placeholder="" class="av-phone form-control W150" data-ax5formatter="phone" value=""/>
                            </ax:td>
                            
                        </ax:tr>
                        <ax:tr labelWidth="120px">
                            <ax:td label="소재지" width="500px" >
                                <input type="text" name="location" data-ax-path="location" class="form-control" value=""/>
                            </ax:td>
                   
                        </ax:tr>
                         <ax:tr labelWidth="120px">
                         	   <ax:td label="유통지위" width="300px" >
		                           <select data-ax-path="disLocation" class="form-control W100">
	                                    <option value="본사">본사</option>
	                                    <option value="총판">총판</option>
	                                    <option value="대리점">대리점</option>
	                                    <option value="판매자">판매자</option>
	                                    <option value="수입총판">수입총판</option>
                                	</select>
		                       </ax:td>
		                       <ax:td label="홈페이지" width="300px" >
		                           <input type="text" name="home_addr" data-ax-path="home_addr" placeholder="http://www.naver.com" class="form-control"  value=""/>
		                       </ax:td>
                          </ax:tr>
                          <ax:tr labelWidth="120px">
                              <ax:td label="비고" width="500px" >
		                           <textarea data-ax-path="etc" class="form-control" rows="5"></textarea>
		                       </ax:td>
                           
                        </ax:tr>
                    </ax:tbl>

                    <div class="H5"></div>
                    <div class="ax-button-group sm">
                        <div class="left">
                            <h3>담당자 정보</h3>
                        </div>
                    </div>
                    <ax:tbl clazz="ax-form-tbl">
                        <ax:tr labelWidth="120px">
                             <ax:td label="이름" width="300px">
                                <input type="text" name="dep_name" data-ax-path="dep_name" maxlength="15" title="이름" class="av-required form-control W150" value=""/>
                            </ax:td>
                            <ax:td label="직급" width="220px">
                                <input type="text" name="dep_duty" data-ax-path="dep_duty" maxlength="15" title="아이디" class="av-required form-control W150" value=""/>
                            </ax:td>
                        </ax:tr>
                        <ax:tr labelWidth="120px">
                             <ax:td label="핸드폰" width="300px">
                                <input type="text" name="dep_phnumber" data-ax-path="dep_phnumber" maxlength="15" title="이름" class="av-required form-control W150" data-ax5formatter="phone" value=""/>
                            </ax:td>
                            <ax:td label="이메일" width="220px">
                                <input type="text" name="email" data-ax-path="email" maxlength="50" title="이메일" placeholder="abc@abc.com" class="av-email form-control W150" value=""/>
                            </ax:td>
                        </ax:tr>
                        <ax:tr labelWidth="120px">
                            <ax:td label="직통번호" width="300px">
                                <input type="text" name="direct_phnumber" data-ax-path="direct_phnumber" maxlength="15" title="이름" class="av-required form-control W150" value=""/>
                            </ax:td>
                            
                            <ax:td label="아이디" width="300px">
                                <input type="text" name="dep_userId" data-ax-path="dep_userId" maxlength="15" title="아이디" class="av-required form-control W150" value=""/>
                            </ax:td>
                            
                        </ax:tr>
                    </ax:tbl>
                </ax:form>

            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>


<script type="text/javascript">




	/* var data = [{ id: 0, text: 'enhancement' }, { id: 1, text: 'bug' }, { id: 2, text: 'duplicate' }, { id: 3, text: 'invalid' }, { id: 4, text: 'wontfix' }];
	var test =  [{
		  text: 'Group label',
		  children: data
		}]; */
	 
	</script>