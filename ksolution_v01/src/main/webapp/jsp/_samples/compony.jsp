<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base">
    <jsp:attribute name="script">
        <ax:script-lang key="ax.script" />
        <script type="text/javascript" src="<c:url value='/assets/js/view/_samples/compony-form.js' />"></script>
    </jsp:attribute>
    <jsp:body>

        <ax:page-buttons></ax:page-buttons>

        <div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='회사명' width="300px">
                            <input type="text" class="form-control" />
                        </ax:td>
                    </ax:tr>
                </ax:tbl>
            </ax:form>
            <div class="H10"></div>
        </div>

        <ax:split-layout name="ax1" orientation="vertical">
            <ax:split-panel width="400" style="padding-right: 10px;">
                <!-- 목록 -->
                <div class="ax-button-group" data-fit-height-aside="grid-view-01">
                    <div class="left">
                        <h2><i class="cqc-list"></i>
                            <ax:lang id="ax.admin.sample.parent.list"/> </h2>
                    </div>
                    <div class="right">

                    </div>
                </div>
                <div data-ax5grid="grid-view-01" data-fit-height-content="grid-view-01" style="height: 300px;"></div>
            </ax:split-panel>
            <ax:splitter></ax:splitter>
            <ax:split-panel width="*" style="padding-left: 10px;" scroll="scroll">
                <!-- 폼 -->
                <div class="ax-button-group" role="panel-header">
                    <div class="left">
                        <h2><i class="cqc-news"></i>
                            <ax:lang id="ax.admin.sample.parent.information"/>
                        </h2>
                    </div>
                    <div class="right">
                       
                       <button type="button" class="btn btn-default"  data-page-btn="save"><i class="axi axi-save"></i> 저장</button>
                       
                        <button type="button" class="btn btn-default" data-form-view-01-btn="form-clear">
                            <i class="cqc-erase"></i>
                            <ax:lang id="ax.admin.clear"/>
                        </button>
                    </div>
                </div>
                <ax:form name="formView01">
                    <ax:tbl clazz="ax-form-tbl" minWidth="500px">
                        <ax:tr>
                            <ax:td label="companyId" width="300px">
                                <input type="text" data-ax-path="companyId" title="companyId" class="form-control"  readonly="readonly"   />
                            </ax:td>
                        </ax:tr>
                        <ax:tr>
                            <ax:td label="회사명" width="300px">
                                <input type="text" data-ax-path="name" class="form-control" data-ax-validate="required"/>
                            </ax:td>
                            <ax:td label="분야" width="300px">
                                 <select data-ax-path="sector" class="form-control W100">
                                    <option value="IT">IT</option>
                                    <option value="패션">패션</option>
                                </select>
                            </ax:td>
                            
                        </ax:tr>
                        
                        <ax:tr>
                            <ax:td label="회사 위치" width="100%">
                                <textarea data-ax-path="location" class="form-control" data-ax-validate="required"></textarea>
                            </ax:td>
                        </ax:tr>
                    </ax:tbl>

                    <div class="H5"></div>
                    <div class="ax-button-group">
                        <div class="left">
                            <h3>
                                <i class="cqc-list"></i>
                                <ax:lang id="ax.admin.sample.child.list"/></h3>
                        </div>
                        <div class="right">
                            <button type="button" class="btn btn-default" data-grid-view-02-btn="item-add">
                                <i class="cqc-plus"></i>
                                <ax:lang id="ax.admin.add"/>
                            </button>
                            <button type="button" class="btn btn-default" data-grid-view-02-btn="item-remove">
                                <i class="cqc-minus"></i>
                                <ax:lang id="ax.admin.delete"/>
                            </button>
                        </div>
                    </div>

                    <div data-ax5grid="grid-view-02" style="height: 300px;"></div>

                </ax:form>
            </ax:split-panel>
        </ax:split-layout>

    </jsp:body>
</ax:layout>