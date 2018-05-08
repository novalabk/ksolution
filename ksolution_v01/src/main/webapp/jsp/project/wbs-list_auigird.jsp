<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags" %>

<ax:set key="title" value="${pageName}"/>
<ax:set key="page_desc" value="${pageRemark}"/>
<ax:set key="page_auto_height" value="true"/>

<ax:layout name="base"> 

<jsp:attribute name="css">
  <link rel="stylesheet" type="text/css" href="<c:url value='/grid/AUIGrid/AUIGrid_style.css'/>"/>
  <style type="text/css">
/* 커스텀 페이징 패널 정의 */
.my-grid-paging-panel {
	width:1200px;
	margin:4px auto;
	font-size:12px;
	height:34px;
	border: 1px solid #ccc;
}

/* aui-grid-paging-number 클래스 재정의*/
.aui-grid-paging-panel .aui-grid-paging-number {
	border-radius : 4px;
}
</style>
</jsp:attribute>
<jsp:attribute name="script">
   <ax:script-lang key="ax.script" var="LANG" />
   <ax:script-lang key="ax.admin" var="COL" />
   <script type="text/javascript" src="<c:url value='/grid/AUIGrid/AUIGridLicense.js' />"></script>
   <script type="text/javascript" src="<c:url value='/grid/AUIGrid/AUIGrid.js' />"></script>
   
   <script type="text/javascript" src="<c:url value='/grid/samples/ajax.js' />"></script>
   <script type="text/javascript" src="<c:url value='/grid/samples/common.js' />"></script>
   		
   <script type="text/javascript">
   var fnObj = {};
   
   var ACTIONS = axboot.actionExtend(fnObj, {
   	   PAGE_SEARCH : function (caller, act, data){
		   
		   
		 var target = $("#searchView0");  
      	 
      	 var name = target.find('[data-ax-path="' + "name" + '"]').val();
      	 var code = target.find('[data-ax-path="' + "code" + '"]').val();
      	 var state = target.find('[data-ax-path="' + "state" + '"]').val();
         
  		 
      	 data = {
      			 name : name,
      			 code : code,
      			 state : state
      	 };
      	 
      	 var sendData = $.extend({},data);
      	  
      	 axboot.ajax({
   			type : "GET", 
   			url : [ "gantt", "list"],
   			data : sendData,// $.extend({}, 
   			// this.gridView01.getPageData()),
   			callback : function(res) {
   				//console.log("res", res);
   				AUIGrid.setGridData(myGridID, res);
   				
   				//console.log("res", res);
   				//caller.gridView01.setData(res);
   				//ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
   				//roleList:[]});
   			}
   		  });
      	  
	   },
	   
	   
	   TAB_OPEN : function(caller, act, data) {
			
			var oid = data.oid;
			var code = data.code;
		    var url = CONTEXT_PATH + '/jsp/project/gantt-save.jsp?&oid=' + oid;
                 
			item = {
				menuId : code,
				id : code,
				progNm : 'GANNTVIEW',
				menuNm : code,
				progPh : '/jsp/project/gantt-save.jsp',
				url : url,
				status : "on",
				fixed : true
			};
  
			parent.fnObj.tabView.open(item);
	   },
	   
	   
	   dispatch : function(caller, act, data) {
			var result = ACTIONS.exec(caller, act, data);
			if (result != "error") {
				return result;
			} else {
				// 직접코딩
				return false;
			}
		}
   });
   
   fnObj.pageStart = function () {
	   var _this = this;
	   
	   createAUIGrid();
	   calculateGanttWrapSizing();
	   //requestData("<c:url value='/grid/samples/data/normal_500.json' />");
	   _this.pageButtonView.initView();
	   
	   AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
		   
		  // ACTIONS.dispatch(ACTIONS.SEARCH_AUTH, {menuId: _data.menuId});
		   var oid = AUIGrid.getCellValue(myGridID, event.rowIndex, "oid"); 
		   var code = AUIGrid.getCellValue(myGridID, event.rowIndex, "code"); 
		   ACTIONS.dispatch(ACTIONS.TAB_OPEN, {oid: oid, code: code}); 
		   //alert("mhyValue = " + myValue);
		   
		   //alert(" ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + event.value + " double clicked!!");
	    });
   }
   
   fnObj.pageButtonView = axboot.viewExtend({
	    initView: function () {
	        axboot.buttonClick(this, "data-page-btn", {
	            "search": function () {
	                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	            }
	        });
	    }
   });

   
   
   
   var myGridID;
   
   function createAUIGrid() {
		
		// AUIGrid 칼럼 설정
		var columnLayout = [
			
			{
				dataField : "oid",
				headerText : "OID",
			},
			{
				dataField : "code",
				headerText : "CODE",
				width : 120
			}, {
				dataField : "name",
				headerText : "Name",
				width : 340
			},
			{
				dataField : "state",
				headerText : "상태",
				width : 140
			},
			{
				dataField : "startDate",
				headerText : "시작일",
				width : 140
			},
			{
				dataField : "endDate",
				headerText : "종료일",
				width : 140
			}/*,  {
				dataField : "flag",
				headerText : "Flag",
				prefix : "./assets/",
				enableGrouping : false,
				width : 100,
				disableGrouping : true,
				renderer : {
					type : "ImageRenderer",
					imgHeight : 24, // 이미지 높이, 지정하지 않으면 rowHeight에 맞게 자동 조절되지만 빠른 렌더링을 위해 설정을 추천합니다.
					altField : "country" // alt(title) 속성에 삽입될 필드명, 툴팁으로 출력됨
				}
			} */
		];
		
		// 그리드 속성 설정
		var gridPros = {
			
			// 그룹핑 패널 사용
			useGroupingPanel : false,
		
			showRowNumColumn : true,
			
			displayTreeOpen : true,
			
			//groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다."
		};

		// 실제로 #grid_wrap 에 그리드 생성
		myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
		
		
		AUIGrid.hideColumnByDataField(myGridID, ["oid"]);
		// 그리드 페이징 네비게이터 생성
		createPagingNavigator(1);
		
		
		
	}

    
   
   
   
   var totalRowCount = 500; // 전체 데이터 건수
   var rowCount = 20;	// 1페이지에서 보여줄 행 수
   var pageButtonCount = 10;		// 페이지 네비게이션에서 보여줄 페이지의 수
   var currentPage = 1;	// 현재 페이지
   var totalPage = Math.ceil(totalRowCount / rowCount);	// 전체 페이지 계산

   // 페이징 네비게이터를 동적 생성합니다.
   function createPagingNavigator(goPage) {
   	var retStr = "";
   	var prevPage = parseInt((goPage - 1)/pageButtonCount) * pageButtonCount;
   	var nextPage = ((parseInt((goPage - 1)/pageButtonCount)) * pageButtonCount) + pageButtonCount + 1;

   	prevPage = Math.max(0, prevPage);
   	nextPage = Math.min(nextPage, totalPage);
   	
   	// 처음
   	retStr += "<a href='javascript:moveToPage(1)'><span class='aui-grid-paging-number aui-grid-paging-first'>first</span></a>";

   	// 이전
   	retStr += "<a href='javascript:moveToPage(" + prevPage + ")'><span class='aui-grid-paging-number aui-grid-paging-prev'>prev</span></a>";

   	for (var i=(prevPage+1), len=(pageButtonCount+prevPage); i<=len; i++) {
   		if (goPage == i) {
   			retStr += "<span class='aui-grid-paging-number aui-grid-paging-number-selected'>" + i + "</span>";
   		} else {
   			retStr += "<a href='javascript:moveToPage(" + i + ")'><span class='aui-grid-paging-number'>";
   			retStr += i;
   			retStr += "</span></a>";
   		}
   		
   		if (i >= totalPage) {
   			break;
   		}

   	}

   	// 다음
   	retStr += "<a href='javascript:moveToPage(" + nextPage + ")'><span class='aui-grid-paging-number aui-grid-paging-next'>next</span></a>";

   	// 마지막
   	retStr += "<a href='javascript:moveToPage(" + totalPage + ")'><span class='aui-grid-paging-number aui-grid-paging-last'>last</span></a>";

   	document.getElementById("grid_paging").innerHTML = retStr;
   }

   function moveToPage(goPage) {
   	
   	// 페이징 네비게이터 업데이트
   	createPagingNavigator(goPage);
   	
   	// 현재 페이지 보관
   	currentPage = goPage;
   	
   	// rowCount 만큼 데이터 요청
   	preRequestData(rowCount, goPage);
   }

   // 데이터 요청
   function preRequestData(count, goPage) {
   	// 요청 주소
   	  var url = "./data/normal_100.json"; //"./data/getJson.php?count=" + count + "&page=" + goPage;
      requestData(url);
   }
   
   
   $(window).resize(function(event) {
	   
		//alert($(this).hasVerticalScrollbar());
		calculateGanttWrapSizing(); 
	});
	 

	 

		


		// 윈도우 크기에 간트 맞추기
	function calculateGanttWrapSizing() {
		 
		var winHeight = $(this).height(); 
		var height = (winHeight - 165); // 헤더와 푸터 높이 빼줌     
		var winWidth = $(this).width();
		
		//alert($(this).parent().prop("scrollHeight"));
		//alert( $(this).prop("scrollHeight") + " , " +  winWidth);
		//alert($(this).hasHorizontalScrollbar());  
			 
		//$("#element").hasVerticalScrollbar()
	    //alert($(this).outerWidth() + ", " + $(this).hasVerticalScrollbar());  
		if(winWidth > 1820)  
			winWidth = 1820;
		if(winWidth < 980)
			winWidth = 980;
		if(height < 300) {
			height = 300; 
		} else if(height > 1000) { 
			height = 1000;
		} 
		
		//console.log("$(this)", $(this));
		  
		//$("#right_menu").css("height",height);
	 
		// 윈도우 높이를 구해 간트 부모의 높이를 맞춤
		$("#grid_wrap").css({
			"width" : winWidth - 31,  
			"height": height 
		});
		$("#grid_paging").css({
			"width" : winWidth - 31
		});
		
		
		if(typeof myGridID !== "undefined" && myGridID) {
			// width, height 파라메터 설정하지 않으면 부모(#gantt_wrap) 100% 적용시킴
			AUIGrid.resize(myGridID); 
		}
	};
   
   </script>
   
   
</jsp:attribute>
    

<jsp:body>
<ax:page-buttons></ax:page-buttons>
	<div role="page-header">
            <ax:form name="searchView0">
                <ax:tbl clazz="ax-search-tbl" minWidth="500px">
                    <ax:tr>
                        <ax:td label='프로젝트 코드' width="300px">
                            <input type="text" class="form-control" data-ax-path="code"/>
                        </ax:td>
                        <ax:td label='프로젝트명' width="300px">
                            <input type="text" class="form-control" data-ax-path="name"/>
                        </ax:td> 
                        <ax:td label='상택' width="300px">
                            <input type="text" class="form-control" data-ax-path="state"/>
                        </ax:td>
                    </ax:tr>
                    <%-- <ax:tr>
                        <ax:td label='ax.admin.sample.search.condition1' width="300px">
                            <input type="text" class="form-control" />
                        </ax:td>
                        <ax:td label='ax.admin.sample.search.condition1' width="300px">
                        
                         <button type="submit" class="btn btn-default" data-left-view-01-btn="add"><ax:lang id="ax.admin.button"/> FN0</button>
                           </ax:td>
                    </ax:tr> --%>
                </ax:tbl>
          </ax:form>
          <div class="H10"></div>
     </div>
     
     <div id="main">
     	<div>
		<!-- 에이유아이 그리드가 이곳에 생성됩니다. -->
			<div id="grid_wrap" style="width:1200px; height:480px; margin:0 auto;"></div>
			<div id="grid_paging" class="aui-grid-paging-panel my-grid-paging-panel"></div>
		</div>
		<div class="desc_bottom">
			<p id="ellapse"></p>
		</div>
     </div><!-- main --> 
      
</jsp:body>

</ax:layout>