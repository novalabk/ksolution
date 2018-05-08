<%@page import="com.boot.ksolution.core.utils.RequestUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ax" tagdir="/WEB-INF/tags"%>

<%
	RequestUtils requestUtils = RequestUtils.of(request);
	
	String activeTab = requestUtils.getString("tab", "task");
	
	requestUtils.setAttribute("activeTab", activeTab);
%>

<ax:set key="page_auto_height" value="true" />
<ax:layout name="base" title=""> 

<jsp:attribute name="css"> 
    <link rel="stylesheet" href="<c:url value='/assets/plugins/bootstrap/dist/css/bootstrap.min.css'/>"/>
	<link rel="stylesheet" type="text/css" href="<c:url value='/gantt/AUIGantt/AUIGantt_style.css'/>"/>
	<%-- <link rel="stylesheet" href="<c:url value='/assets/plugins/select2-4.0.3/dist/css/select2.min.css" rel="stylesheet'/>" />
	 --%>
	<link rel="stylesheet" href="<c:url value='/webjars/mjolnic-bootstrap-colorpicker/2.4.0/dist/css/bootstrap-colorpicker.min.css'/>"/>
	<link rel="stylesheet" href="<c:url value='/jsp/project/assets/project_style.css'/>"/>
	<link href="<c:url value='/assets/css/axboot.css'/>" rel="stylesheet" /> 
</jsp:attribute>


<jsp:attribute name="script">
    <ax:script-lang key="ax.script" var="LANG"/>
    <ax:script-lang key="ks.Msg" var="MSG"/>
    
    <script type="text/javascript" src="<c:url value='/gantt/AUIGantt/AUIGanttLicense.js' />"></script>
	<script type="text/javascript" src="<c:url value='/webjars/mjolnic-bootstrap-colorpicker/2.4.0/dist/js/bootstrap-colorpicker.min.js' />"></script>
	<script type="text/javascript" src="<c:url value='/gantt/AUIGantt/AUIGantt.js' />"></script>
	<script type="text/javascript" src="<c:url value='/gantt/AUIGantt/resources/' /><ax:lang id='ks.Msg.4'/>"></script>
    <script type="text/javascript" src="<c:url value='/assets/plugins/bootstrap/dist/js/bootstrap.min.js' />"></script>
   <%--  <script type="text/javascript" src="<c:url value='/assets/plugins/select2-4.0.3/dist/js/select2.min.js' />"></script>
    --%>  
 <script type="text/javascript">
 
 var fnObj = {};
 var ACTIONS = axboot.actionExtend(fnObj, {
	 GET_PROJECTINFO : function(caller, act, data){
		 var sendData = $.extend({},data);
      	 console.log("sendData ", sendData);
      	 var mappingValue = "get/" + data.oid;
      	 axboot.ajax({
   			type : "GET", 
   			url : [ "gantt", mappingValue],
   			data : sendData,// $.extend({}, 
   			// this.gridView01.getPageData()),
   			callback : function(res) {
   				//console.log("res", res);
   				setInitData(res);
   				//$(this).addClass("class_name");
   				//$(this).removeClass("class_name");
   				AUIGantt.setGanttData(myGanttID, res.ganttData); 
   				AUIGantt.fitToContent(myGanttID); 
   				//console.log("res", res);
   				//caller.gridView01.setData(res);
   				//ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
   				//roleList:[]});
   			}
   		  });
	 },
	 
	 REPLACE : function(caller, act, data){
		 var oid = data.oid;
		 var code = data.code;
		 var url = CONTEXT_PATH + '/jsp/project/gantt-save.jsp?&oid=' + oid;
	  	
		 
 
		 var item = {
				menuId : code,
				id : code,
				progNm : 'GANNTVIEW',
				menuNm : code,
				progPh : '/jsp/project/gantt-save.jsp',
				url : url,
				status : "on",
				fixed : true
		 };
		 parent.fnObj.tabView.replace(item);
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
 
 

 
 var myGanttID;

 // 윈도우 onload
 // DOM 완료 후 간트 차트 생성함.
 fnObj.pageStart = function () {
	
 	
	
	var target = $("#formView01");
	 
	handleButtons();
 	
    $("#${activeTab}_tab").addClass("active");
    $("#${activeTab}_tabpanel").addClass("active");
    
    target.find('[data-ax5picker="date"]').ax5picker({
        direction: "auto",
        content: {
            type: 'date',
            
        }
    });
 	
 	//alert(target.find('[role="tablist"]').find(".active").length);
 	
 	//console.log(target.find('[role="tablist"]').find(".active.tab-menu-btn"));
 	
 	
 	// 간트차트를 생성합니다. 
 	createAUIGanttChart();
 	calculateGanttWrapSizing();
 	
 	
 	 
 	var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
 	
 	if(oid != '' && oid.length > 0){
 		ACTIONS.dispatch(ACTIONS.GET_PROJECTINFO, {oid: oid}); 
 	}else{
 		
 		AUIGantt.createNewDocument(myGanttID, 100);
 	 	
 		
 	}
 	 
 };

 // AUIGantt 를 생성합니다.
 function createAUIGanttChart() {
 	
 	// 간트 그리드(시트) 에 출력할 칼럼 필드 들 작성함.
 	// 아래는 기본값으로 위치 또는 임의 작성으로 개발자는 작성 가능합니다.
 	var myColumnLayout = [
          AUIGantt.defaultColumnInfo.index, // 기본 정보 필드
          AUIGantt.defaultColumnInfo.name, // 작업 이름 필드
          AUIGantt.defaultColumnInfo.period, // 기간 필드
          AUIGantt.defaultColumnInfo.start, // 작업 시작 날짜 필드
          AUIGantt.defaultColumnInfo.end, // 작업 종료 날짜 필드
          AUIGantt.defaultColumnInfo.predecessor, // 선행 관계 필드
          AUIGantt.defaultColumnInfo.resource, // 자원 필드
          AUIGantt.defaultColumnInfo.progress // 진행률 필드
 	];
 	
 	myColumnLayout.push({
 	     dataField : "product",
 	     headerText : "Product",
 	     width : 120,
 	     editRenderer : { // 편집 모드 진입 시 콤보박스리스트 출력하고자 할 때
 	            type : "ComboBoxRenderer",
 	            list : ["IPhone 5S", "Galaxy S5", "IPad Air", "Galaxy Note3", "LG G3", "Nexus 10"],
 	            historyMode : true // 히스토리 모드 사용
 	      }
 	});
 	                      
 	// 간트차트 속성 설정
 	var ganttProps = {
 			
 			// 편집 가능 여부
 			editable : true,
 			
 			
 			exportURL : "<c:url value='/api/v1/gantt/export' />", 
 			
 			gridWidth : "45%",
 			
 			// 인덱스 1에 트리 칼럼을 만듬. 즉, 설정한 columnLayout 기준임.
 			treeColumnIndex: 1, 
 			
 			// 간트 그리드(시트) 레이아웃 (필수 정의해야 함)
 			columnLayout : myColumnLayout
 			
 	};
 	

 	// 실제로 #gantt_wrap 에 간트차트 생성
 	myGanttID = AUIGantt.create("#gantt_wrap", ganttProps);
 	
 	// ready 이벤트 바인딩
 	AUIGantt.bind(myGanttID, "ready", function(event) {
 		// 처음에 rowIndex 0, columnIndex 1 에 엑셀처럼 선택자 만들기.
 		AUIGantt.setSelectionByIndex(myGanttID, 0, 1);
 	});
 	
 	 
     AUIGantt.bind(myGanttID, "timeUnitChange", function(event) {
    	
		var index = -1;
		var options = document.getElementById("timeSelect").options;
		
		// 시간 단위 select 를 현재 간트 시간에 맞추기.
		// 즉, 간트 차트에 데이터를 삽입하면 해당 데이터에 맞게 select 를 맞추기
		for(var i = 0, len = options.length; i < len; i++) {
			if(options[i].value == event.timeUnit) {
				index = i;
				break;
			}
		}
		document.getElementById("timeSelect").selectedIndex =  index; 
	}); 
 	
 	// 헤더 메뉴 아이콘 클릭 이벤트 바인딩
 	AUIGantt.bind(myGanttID, "headerIconClick", function(event) {
 		alert(event.headerText + " 헤더 메뉴 아이콘 클릭!!");
 	});
 	
 	
 	AUIGantt.bind(myGanttID, "beforeRemoveRow", function(event) {
		if(confirm("선택 작업을 삭제 하시겠습니까?")) {
			return true;
		}
		return false;
	});
	
	// Insert 키로 행 추가 한 경우
	AUIGantt.bind(myGanttID, "beforeInsertRow", function(event) {
		return {
			name : LANG("ax.script.gantt.save.title"),  /* < 새 작업 > */
			progress : 0
		};
	});
	
	AUIGantt.bind(myGanttID, "editCellCondition", function( event ) {
	      //alert("rowIndex : " + event.rowIndex + ", " +  "columnIndex : " + event.columnIndex + " editCellCondition");
	      // return true;
	      // return false; // false, true 반환으로 동적으로 수정, 편집 제어 
	});
 };

 // 새 문서
 function newDocument() {
 	// 새 간트 다큐멘트 작성하기
 	// 파라메터 100 은 최초 문서에 100개의 행을 만듭니다.
 	if(confirm("새로 문서를 작성하시겠습니까?")) {
 		AUIGantt.createNewDocument(myGanttID, 100);
 	}
 }; 
//http://localhost/pms/jsp/project/assets/info-icon_24_24.png
 // 간트 데이터 삽입
 /* function setGanttData() {
 	AUIGantt.setGanttData(myGanttID, myGanttData);
 }; */
 
 //http://www.auisoft.net/demo/auigantt/assets/info-icon_24_24.png

 // 간트 데이터 얻기
 function saveGanttData(infoData, isSaveAs) {
 	var ganttData = AUIGantt.getGanttData(myGanttID);
 	
 	var decodedData = decodeURIComponent(ganttData);
 	var jsonData = JSON.parse(decodedData);
 	
 	var target = $("#formView01");
	var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
	var code = target.find('[data-ax-path="' + "code" + '"]').val();
	
	if(isSaveAs){
		oid = '';
		code = '';
	}
	
    var sendData = {
    	ganttData : jsonData,
    	oid : oid,
    	code : code
    }
    
    sendData = $.extend(sendData, infoData);
    
   // console.log("jsonData.tasks", jsonData.tasks);

 	axboot.call({
        type: "PUT", 
        url: ["gantt"], 
        data: JSON.stringify(sendData),
        callback: function (res) {
            // ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            //caller.formView01.setData(res);
            if (res.error) {
                alert(res.error.message);
                return;
            }
           // console.log("res1ddd1", res);
            
            
             
            axToast.push(LANG("ax.script.menu.category.saved"));
            ACTIONS.dispatch(ACTIONS.REPLACE, res); 
            //console.log("kk", kk); 
            //alert(res.code);
             
            
            //alert(LANG("ax.script.menu.category.saved")); 
             
          	/* if(confirm(dateString + " 로 프로젝트 시작날짜를 변경하시겠습니까?")) {
				// 간트 프로젝트 시작 날짜 변경 적용
				AUIGantt.setProjectStartDate(myGanttID, date);
			} */
             
           
            // setInitData(res);
            // AUIGantt.setGanttData(myGanttID, res.ganttData); 
            
        }
    }).done(function() {
    	
    	//axDialog.alert(LANG("ax.script.menu.category.saved"));
    	
	});
 	

 };
 
 /* function replace(data){
	 
	 var oid = data.oid;
	 var code = data.code;
	 var url = CONTEXT_PATH + '/jsp/project/gantt-save.jsp?&oid=' + oid;
  	
	 var item = {
			menuId : code,
			id : code,
			progNm : 'GANNTVIEW',
			menuNm : code,
			progPh : '/jsp/project/gantt-save.jsp',
			url : url,
			status : "on",
			fixed : true
	 };
	 parent.fnObj.tabView.replace(item);
 } */

 function autoCal(){
	 var ganttData = AUIGantt.getGanttData(myGanttID);
	 var decodedData = decodeURIComponent(ganttData);
	 var jsonData = JSON.parse(decodedData);
	 var sendData = jsonData.tasks;
	 axboot.ajax({
	        type: "PUT", 
	        url: ["gantt", "autoCal"], 
	        data: JSON.stringify(sendData),
	        callback: function (res) {
	            // ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	            //caller.formView01.setData(res);
	            if (res.error) {
	                alert(res.error.message);
	                return;
	            }
	            //console.log("res", res);
	            
	            for(var i = 0; i < res.length; i++){
	            	settingProgress(res[i]);
	            }
	            
	            /* axToast.push(LANG("ax.script.menu.category.saved"));
	            AUIGantt.setGanttData(myGanttID, res.ganttData);  */
	        }
	    });
  }
 
  function settingProgress(task){
	  
	  if(task.childCount > 0){
		  AUIGantt.updateRowsById(myGanttID, {
			"uuid" : task.uuid,
			progress : task.progress
		  });
	  }
	  
	  for (var i = 0; i < task.childCount; i++) {
	  	settingProgress(task.children[i]);
	  }
  }  


$(window).resize(function(event) {
	//alert($(this).hasVerticalScrollbar());
	calculateGanttWrapSizing();
});
 

 

	


	// 윈도우 크기에 간트 맞추기
function calculateGanttWrapSizing() {
	 
	var winHeight = $(this).height(); 
	var height = (winHeight - 85); // 헤더와 푸터 높이 빼줌   
	var winWidth = $(this).width();
	

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
	$("#gantt_wrap").css({
		"width" : winWidth - 31,  
		"height": height 
	});
	if(typeof myGanttID !== "undefined" && myGanttID) {
		// width, height 파라메터 설정하지 않으면 부모(#gantt_wrap) 100% 적용시킴
		AUIGantt.resize(myGanttID); 
	}
};


function handleButtons() {
	var defaultColors={"transparent":"transparent","#C90000":"#C90000","#ff0000":"#ff0000","#FF5E00":"#FF5E00","#FFFF00":"#FFFF00","#1DDB16":"#1DDB16","#00D8FF":"#00D8FF","#0054FF":"#0054FF","#5F00FF":"#5F00FF"};
	$("#btnBgColor-picker").colorpicker({color:"#ffff00",format:"hex",colorSelectors:defaultColors}).on("changeColor",function(evt){var c=evt.color.toHex();c=(c=="transparent")?"inherit":c;$("#btnBgColor > span").css("background-color",c).attr("data-color",c);
	AUIGantt.setCellBgColor(myGanttID,c)}).on("showPicker",function(evt){$(".colorpicker .colorpicker-selectors > i:first-child").css("background","url('<c:url value="/gantt/AUIGantt/images/close-icon-10-10.png"/>') 50% 50%")});
	$("#btnColor-picker").colorpicker({color:"#ff0000",format:"hex",colorSelectors:defaultColors}).on("changeColor",function(evt){var c=evt.color.toHex();c=(c=="transparent")?"inherit":c;$("#btnColor > span").css("background-color",c).attr("data-color",c);
	AUIGantt.setCellFontColor(myGanttID,c)}).on("showPicker",function(evt){$(".colorpicker .colorpicker-selectors > i:first-child").css("background","url('<c:url value="/gantt/AUIGantt/images/close-icon-10-10.png"/>') 50% 50%")});
    
	$('#task_menus button').on('click', function (e) {
		var $this = $(this);
		if($this.hasClass("disabled")) {
			return;
		}
		
		var id = $this.prop("id");
		switch(id) {
		case "btnBold":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.toggleBoldStyle(myGanttID);
			}
			break;
		case "btnItalic":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.toggleItalicStyle(myGanttID);
			}
			break;
		case "btnUnderline":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.toggleUnderlineStyle(myGanttID);
			}
			break;
		case "btnOutdent":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.outdentTreeDepth(myGanttID);
			}
			break;
		case "btnBgColor":
			AUIGantt.setCellBgColor(myGanttID, $("#btnBgColor > span").attr("data-color"));
			break;
		case "btnColor":
			AUIGantt.setCellFontColor(myGanttID, $("#btnColor > span").attr("data-color"));
			break;
		case "btnIndent":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.indentTreeDepth(myGanttID);
			}
			break;
		case "btnMoveUp":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.moveRowsToUp(myGanttID);
			}
			break;
		case "btnMoveDown":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.moveRowsToDown(myGanttID);
			}
			break;
		case "btnInsert":
			if(AUIGantt.getEditable(myGanttID)) {
				addRow('selectionUp');
			}
			break;
		case "btnMgInsert":
			if(AUIGantt.getEditable(myGanttID)) {
				addRow('selectionUp', 'milestone');
			}
			break;
		case "btnBlankInsert":
			if(AUIGantt.getEditable(myGanttID)) {
				addRow('selectionUp', 'blank');
			}
			break;
		case "btnAddLast":
			if(AUIGantt.getEditable(myGanttID)) {
				addRow('last');
			}
			break;
		case "btnDel":
			if(AUIGantt.getEditable(myGanttID)) {
				AUIGantt.removeSelectedItems(myGanttID);
			}
			break;
		case "autoCal":
			if(AUIGantt.getEditable(myGanttID)) {
				autoCal();
			}
			break;
		case "btnDetails":
			$('#detailsWindow').modal('show');
			break;
		case"btnFit": 
			AUIGantt.fitToContent(myGanttID);
			break;
		case"btnMove":
			AUIGantt.moveToSelectedItem(myGanttID);
			break;	
		case "btnBgColor-picker":
		case "btnColor-picker":
			alert("컬러 픽커(colorPicker)를 연결하여 사용하십시오.");
			break;
		}
		
		// 간트에 포커싱 유지
		AUIGantt.setFocus(myGanttID);
	});
};

function getInitData(){
	var target = $("#formView01");
	var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
	var prj_name = target.find('[data-ax-path="' + "prj_name" + '"]').val();
	var desc = target.find('[data-ax-path="' + "desc" + '"]').val();
	
	return {oid : oid,
			prj_name : prj_name,
			desc : desc
	}
	
}

function setInitData(initData){
	var target = $("#formView01");
	target.find('[data-ax-path="' + "oid" + '"]').val(initData.oid);
	target.find('[data-ax-path="' + "code" + '"]').val(initData.code);
	target.find('[data-ax-path="' + "prj_name" + '"]').val(initData.name);
	target.find('[data-ax-path="' + "desc" + '"]').val(initData.description);
}

//행 추가, 삽입
function addRow(position, type) {
	var item;
	
	if(type == "blank") {
		item = null;
	} else {
		if(position == "last") {
			item = [];
			for(var i=0; i < 10; i++) {
				item.push({});
			}
		} else {
			item = {
					name : "< 새 작업 >",
					progress : 0
			};
		}
		
		if(type == "milestone") {
			item.period = 0;
			item.progress = 0;
			item.isFixedPeriod = true;
			item.isMilestone = true;
			item.name ="< 새 중요 시점 >" 
		}
	}
	
	// item 이 null 이면 초기 세팅 하지 않음. 즉 빈행 삽입
	AUIGantt.addRow(myGanttID, item, position);
};

//확대
function zoomIn() {
	AUIGantt.zoomIn(myGanttID);
};

// 축소
function zoomOut() {
	AUIGantt.zoomOut(myGanttID);
};
	
// 시간 단위 변경 이벤트
function timeSelectChangeHandler() {
	var value = document.getElementById("timeSelect").value;
	AUIGantt.setTimeScaleUnit(myGanttID, value);
};


function saveAsExcel( timeUnit ) {
	var exportProps = {
		fileName : "AUIGantt", // 파일 명 지정  
		sheetName : "일정 관리표", // 엑셀 시트명 지정
		//fontFamily : "Calibri", // 폰트명 지정
		timeLabelWidth : 30, // 타임 1유닛의 크기
		includeGantt : true,  // 간트 차트 엑셀 포함 여부
		displayTimeUnit : timeUnit, // 시간 단위
		headers : [ {
			text : "", height:5, style : { background:"#555555"} // 빈줄 색깔 경계 만듬
		}, {
			text : "AUIGantt 차트 엑셀 저장", height:24, style : { fontSize:14, textAlign:"left", fontWeight:"bold", underline:true, background:"#DAD9FF"}
		}, {
			text : "작성자 : 에이유아이"
		}, {
			text : "작성일 : 2017. 06. 26."
		}, {
			text : "추가 정보 : 원하는 문구를 헤더에 넣을 수 있습니다."
		}, {
			text : "", height:5, style : { background:"#555555"} // 빈줄 색깔 경계 만듬
		}],
	footers : [ {
			text : "", height:5, style : { background:"#555555"} // 빈줄 색깔 경계 만듬
		}, {
			text : "원하는 행 만큼", height:24, style : { color: "#0000aa" }
		}, {
			text : "푸터에도 뭔가를 넣을 수 있습니다.", height:24, style : { textAlign:"left", fontSize:14, fontWeight:"bold", color:"#ffffff", background:"#222222"}
		}]
	};
   
	AUIGantt.exportToXlsx(myGanttID, exportProps);
};
// 간트 차트에 출력 시킬 데이터 
//var myGanttData = "%7B%22columns%22%3A%5B%7B%22headerText%22%3A%22%3Cimg%20style%3D%5C%22margin-top%3A6px%5C%22%20src%3D%5C%22.%2Fassets%2Finfo-icon_24_24.png%5C%22%3E%22%2C%22dataField%22%3A%22index%22%2C%22width%22%3A60%2C%22visible%22%3Atrue%7D%2C%7B%22headerText%22%3A%22%EC%9E%91%EC%97%85%20%EC%9D%B4%EB%A6%84%22%2C%22dataField%22%3A%22name%22%2C%22width%22%3A280%2C%22visible%22%3Atrue%7D%2C%7B%22headerText%22%3A%22%EA%B8%B0%EA%B0%84%22%2C%22dataField%22%3A%22period%22%2C%22width%22%3A50%2C%22visible%22%3Atrue%7D%2C%7B%22headerText%22%3A%22%EC%8B%9C%EC%9E%91%20%EB%82%A0%EC%A7%9C%22%2C%22dataField%22%3A%22start%22%2C%22width%22%3A120%2C%22visible%22%3Atrue%2C%22dataType%22%3A%22date%22%2C%22formatString%22%3A%22yyyy-mm-dd%20(ddd)%22%7D%2C%7B%22headerText%22%3A%22%EC%99%84%EB%A3%8C%20%EB%82%A0%EC%A7%9C%22%2C%22dataField%22%3A%22end%22%2C%22width%22%3A120%2C%22visible%22%3Atrue%2C%22dataType%22%3A%22date%22%2C%22formatString%22%3A%22yyyy-mm-dd%20(ddd)%22%7D%2C%7B%22headerText%22%3A%22%EC%84%A0%ED%96%89%20%EC%9E%91%EC%97%85%22%2C%22dataField%22%3A%22predecessor%22%2C%22width%22%3A80%2C%22visible%22%3Atrue%7D%2C%7B%22headerText%22%3A%22%EC%9E%90%EC%9B%90%20%EC%9D%B4%EB%A6%84%22%2C%22dataField%22%3A%22resource%22%2C%22width%22%3A80%2C%22visible%22%3Atrue%7D%2C%7B%22headerText%22%3A%22%EC%99%84%EB%A3%8C%EC%9C%A8%22%2C%22dataField%22%3A%22progress%22%2C%22width%22%3A60%2C%22visible%22%3Atrue%7D%5D%2C%22props%22%3A%7B%22version%22%3A%223.0%22%2C%22projectStart%22%3A1499040000000%2C%22projectEnd%22%3A1501059600000%2C%22viewStart%22%3A1498632173989%2C%22viewEnd%22%3A1500964973989%2C%22scrollPosition%22%3A0%2C%22minorUnit%22%3A%22day%22%2C%22unitSize%22%3A36%2C%22chartLeftLabelField%22%3A%22%22%2C%22chartRightLabelField%22%3A%22resource%22%2C%22milestoneLabelField%22%3A%22start%22%2C%22gridWidth%22%3A894%2C%22showTodayLine%22%3Atrue%2C%22todayLineText%22%3A%22Today%22%2C%22showProjectStartLine%22%3Afalse%2C%22showProjectEndLine%22%3Afalse%2C%22projectStartLineText%22%3A%22Project%20Start%22%2C%22projectEndLineText%22%3A%22Project%20End%22%7D%2C%22calendarProps%22%3A%7B%22startHour%22%3A9%2C%22endHour%22%3A18%2C%22saturday%22%3Atrue%2C%22sunday%22%3Atrue%2C%22exceptDays%22%3A%5B%7B%22start%22%3A%222015%2F08%2F14%22%2C%22end%22%3A%222015%2F08%2F14%22%2C%22text%22%3A%22%EC%B6%94%EC%84%9D%20%EB%8C%80%EC%B2%B4%20%EA%B3%B5%ED%9C%B4%EC%9D%BC%22%7D%5D%7D%2C%22styles%22%3A%7B%22FF0F126B-2FA6-5814-C725-CAF8AB2CDB87%22%3A%7B%22index%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22name%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22period%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22start%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22end%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22predecessor%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22resource%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22progress%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%7D%2C%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%3A%7B%22index%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22name%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22period%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22start%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22end%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22predecessor%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22resource%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%2C%22progress%22%3A%7B%22fontWeight%22%3A%22bold%22%7D%7D%7D%2C%22chartStyles%22%3A%7B%22headerBgColors%22%3A%5B%22%23F8F8F8%22%2C%22%23EEEEEE%22%5D%2C%22headerLineColor%22%3A%22%23BDBDBD%22%2C%22headerMajorFont%22%3A%22bold%2012px%20%EB%A7%91%EC%9D%80%20%EA%B3%A0%EB%94%95%22%2C%22headerMinorFont%22%3A%22normal%2012px%20%EB%A7%91%EC%9D%80%20%EA%B3%A0%EB%94%95%22%2C%22headerMajorColor%22%3A%22%23000000%22%2C%22headerMinorColor%22%3A%22%23000000%22%2C%22headerSatColor%22%3A%22%230000FF%22%2C%22headerSunColor%22%3A%22%23FF0000%22%2C%22headerUserColor%22%3A%22%23FF0000%22%2C%22rowBgColors%22%3A%5B%22%23FAFAFA%22%2C%22%23FFFFFF%22%5D%2C%22verticalLineColor%22%3A%22%23DCDCDC%22%2C%22horizontalLineColor%22%3A%22%23DCDCDC%22%2C%22holidayBgColor%22%3A%22rgba(200%2C200%2C200%2C%200.25)%22%2C%22branchBgColor%22%3A%22%23555555%22%2C%22branchProgressColor%22%3A%22%23008299%22%2C%22taskBgColor%22%3A%22%23B2CCFF%22%2C%22taskProgressColor%22%3A%22%236A84B7%22%2C%22milestoneBgColor%22%3A%22%230B7903%22%2C%22connectorColor%22%3A%22%234374D9%22%2C%22projectStartLineColor%22%3A%22%23008299%22%2C%22projectEndLineColor%22%3A%22%23008299%22%2C%22todayLineColor%22%3A%22%23FF5E00%22%2C%22projectStartLineWidth%22%3A1%2C%22projectEndLineWidth%22%3A1%2C%22todayLineWidth%22%3A1%2C%22font%22%3A%22bold%2012px%20%EB%A7%91%EC%9D%80%20%EA%B3%A0%EB%94%95%22%2C%22color%22%3A%22%23222%22%2C%22leftColor%22%3A%22%23222%22%2C%22barLabelFont%22%3A%22bold%2012px%20%EB%A7%91%EC%9D%80%20%EA%B3%A0%EB%94%95%22%2C%22barLabelFontColor%22%3A%22%23222222%22%2C%22barLabelLeftFontColor%22%3A%22%23222222%22%2C%22textPadding%22%3A10%2C%22textTopPadding%22%3A0%7D%2C%22tasks%22%3A%5B%7B%22index%22%3A1%2C%22period%22%3A10%2C%22start%22%3A1499040000000%2C%22end%22%3A1500022800000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A75%2C%22name%22%3A%22%3C%EC%9A%94%EC%95%BD%20%EC%9E%91%EC%97%85%3E%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Atrue%2C%22children%22%3A%5B%7B%22index%22%3A2%2C%22period%22%3A2%2C%22start%22%3A1499040000000%2C%22end%22%3A1499158800000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A100%2C%22name%22%3A%22%EC%9E%91%EC%97%851%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22isMilestone%22%3Afalse%2C%22resource%22%3A%22%ED%99%8D%EA%B8%B8%EB%8F%99%22%2C%22uuid%22%3A%22D3648497-647F-AC68-90BF-CAF8AB2C311B%22%2C%22_%24oldDataIndex%22%3A2%2C%22_%24parent%22%3A%22FF0F126B-2FA6-5814-C725-CAF8AB2CDB87%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%2C%22fixedDate%22%3A1499040000000%2C%22fixedDateName%22%3A%22afterStart%22%7D%2C%7B%22index%22%3A3%2C%22period%22%3A3%2C%22start%22%3A1499212800000%2C%22end%22%3A1499418000000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A100%2C%22name%22%3A%22%EC%9E%91%EC%97%852%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22predecessor%22%3A%222%22%2C%22isMilestone%22%3Afalse%2C%22resource%22%3A%22%EA%B9%80%EC%A7%80%EC%9A%B0%22%2C%22uuid%22%3A%22EF5356AD-8046-7886-3533-CAF8AB2C909F%22%2C%22_%24oldDataIndex%22%3A3%2C%22_%24parent%22%3A%22FF0F126B-2FA6-5814-C725-CAF8AB2CDB87%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A4%2C%22period%22%3A4%2C%22start%22%3A1499644800000%2C%22end%22%3A1499936400000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A50%2C%22name%22%3A%22%EC%9E%91%EC%97%853%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22predecessor%22%3A%223%22%2C%22isMilestone%22%3Afalse%2C%22resource%22%3A%22%22%2C%22uuid%22%3A%22580D8D4E-6E6D-B405-9F93-CAF8AB2CEE75%22%2C%22_%24oldDataIndex%22%3A4%2C%22_%24parent%22%3A%22FF0F126B-2FA6-5814-C725-CAF8AB2CDB87%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A5%2C%22period%22%3A0%2C%22start%22%3A1499990400000%2C%22end%22%3A1500022800000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%A4%91%EC%9A%94%EC%8B%9C%EC%A0%90%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22predecessor%22%3A%224%22%2C%22isMilestone%22%3Atrue%2C%22resource%22%3A%22%22%2C%22uuid%22%3A%22F85AAAE7-59D1-5ADC-0CDA-CAF8AB2CE56F%22%2C%22_%24oldDataIndex%22%3A5%2C%22_%24parent%22%3A%22FF0F126B-2FA6-5814-C725-CAF8AB2CDB87%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%5D%2C%22_%24isOpen%22%3Atrue%2C%22uuid%22%3A%22FF0F126B-2FA6-5814-C725-CAF8AB2CDB87%22%2C%22isMilestone%22%3Afalse%2C%22fixedDateName%22%3Anull%2C%22fixedDate%22%3Anull%2C%22_%24oldDataIndex%22%3A1%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A4%2C%22hasMemo%22%3Atrue%2C%22memoData%22%3A%5B%7B%22subject%22%3A%22%EC%9D%B4%EC%8A%88%EA%B0%80%20%EC%9E%88%EC%8A%B5%EB%8B%88%EB%8B%A4..%22%2C%22content%22%3A%22%ED%95%B4%EB%8B%B9%20%EC%9E%91%EC%97%85%EC%9D%80%207%EC%9B%94%2015%EC%9D%BC%EA%B9%8C%EC%A7%80%20%EB%AC%B4%EC%A1%B0%EA%B1%B4%20%EC%99%84%EB%A3%8C%ED%95%B4%EC%95%BC%20%ED%95%A9%EB%8B%88%EB%8B%A4.%22%2C%22date%22%3A1498884508517%7D%5D%7D%2C%7B%22index%22%3A6%2C%22period%22%3A18%2C%22start%22%3A1499040000000%2C%22end%22%3A1501059600000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A0%2C%22name%22%3A%22%3C%EC%9A%94%EC%95%BD%20%EC%9E%91%EC%97%852%3E%22%2C%22children%22%3A%5B%7B%22index%22%3A7%2C%22period%22%3A3%2C%22start%22%3A1499040000000%2C%22end%22%3A1499245200000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A75%2C%22name%22%3A%22%EC%9E%91%EC%97%851%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22isMilestone%22%3Afalse%2C%22predecessor%22%3A%222SS%22%2C%22uuid%22%3A%2256C4C860-03C7-24F9-3A0B-CAF8AB2C3370%22%2C%22_%24oldDataIndex%22%3A7%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A8%2C%22period%22%3A4%2C%22start%22%3A1499299200000%2C%22end%22%3A1499763600000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A30%2C%22name%22%3A%22%EC%9E%91%EC%97%852%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22predecessor%22%3A%227%22%2C%22isMilestone%22%3Afalse%2C%22uuid%22%3A%22AEA546C7-C65B-4CDA-C39B-CAF8AB2CE363%22%2C%22_%24oldDataIndex%22%3A8%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A9%2C%22period%22%3A5%2C%22start%22%3A1499817600000%2C%22end%22%3A1500368400000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A10%2C%22name%22%3A%22%EC%9E%91%EC%97%853%22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22predecessor%22%3A%228%22%2C%22isMilestone%22%3Afalse%2C%22resource%22%3A%22%22%2C%22uuid%22%3A%22F462C58C-C386-36FC-15C8-CAF8AB2CC108%22%2C%22_%24oldDataIndex%22%3A9%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A10%2C%22period%22%3A1%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22start%22%3A1500422400000%2C%22end%22%3A1500454800000%2C%22isFixedPeriod%22%3Afalse%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%9E%91%EC%97%854%22%2C%22predecessor%22%3A%229%22%2C%22uuid%22%3A%22740E6F17-17C2-E488-25C8-CAF8AB2C4FBB%22%2C%22_%24oldDataIndex%22%3A10%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A11%2C%22period%22%3A1%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22start%22%3A1500508800000%2C%22end%22%3A1500541200000%2C%22isFixedPeriod%22%3Afalse%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%9E%91%EC%97%855%22%2C%22predecessor%22%3A%227%2C10%22%2C%22uuid%22%3A%2223AF777E-7D86-11D5-2A06-CAF8AB2C6564%22%2C%22_%24oldDataIndex%22%3A11%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A12%2C%22period%22%3A1%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22start%22%3A1500595200000%2C%22end%22%3A1500627600000%2C%22isFixedPeriod%22%3Afalse%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%9E%91%EC%97%856%22%2C%22predecessor%22%3A%2211%22%2C%22uuid%22%3A%222023EA0A-F79B-6C93-0588-CAF8AB2C85BF%22%2C%22_%24oldDataIndex%22%3A12%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A13%2C%22period%22%3A1%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22start%22%3A1500854400000%2C%22end%22%3A1500886800000%2C%22isFixedPeriod%22%3Afalse%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%9E%91%EC%97%857%22%2C%22predecessor%22%3A%2212%22%2C%22uuid%22%3A%220C9812FD-DCA6-535D-5898-CAF8AB2CE917%22%2C%22_%24oldDataIndex%22%3A13%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A14%2C%22period%22%3A1%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22start%22%3A1500940800000%2C%22end%22%3A1500973200000%2C%22isFixedPeriod%22%3Afalse%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%9E%91%EC%97%858%22%2C%22predecessor%22%3A%2213%22%2C%22uuid%22%3A%22881A3225-B56D-24FD-760D-CAF8AB2C7D9D%22%2C%22_%24oldDataIndex%22%3A14%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A15%2C%22period%22%3A0%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22start%22%3A1501027200000%2C%22end%22%3A1501059600000%2C%22isFixedPeriod%22%3Atrue%2C%22progress%22%3A0%2C%22name%22%3A%22%EC%A4%91%EC%9A%94%EC%8B%9C%EC%A0%90%22%2C%22isMilestone%22%3Atrue%2C%22predecessor%22%3A%2211%2C14%22%2C%22resource%22%3A%22%22%2C%22uuid%22%3A%2266D3A320-3B65-9C24-F01E-CAF8AB2CA1AB%22%2C%22_%24oldDataIndex%22%3A15%2C%22_%24parent%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22_%24depth%22%3A2%2C%22_%24leafCount%22%3A0%7D%5D%2C%22_%24isOpen%22%3Atrue%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Atrue%2C%22predecessor%22%3A%22%22%2C%22uuid%22%3A%228C0CB729-BA85-836D-E983-CAF8AB2C470B%22%2C%22isMilestone%22%3Afalse%2C%22fixedDateName%22%3Anull%2C%22fixedDate%22%3Anull%2C%22_%24oldDataIndex%22%3A6%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A9%7D%2C%7B%22index%22%3A16%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22508E1057-4463-1DA1-6994-CAF8AB2C5030%22%2C%22_%24oldDataIndex%22%3A16%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A17%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2265F51B14-171C-E3ED-5FB3-CAF8AB2C9431%22%2C%22_%24oldDataIndex%22%3A17%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A18%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%225694E791-2D8D-905C-DE7F-CAF8AB2C688F%22%2C%22_%24oldDataIndex%22%3A18%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A19%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%221215E6AC-3D59-B98A-7E6A-CAF8AB2CC043%22%2C%22_%24oldDataIndex%22%3A19%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A20%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22390A80AD-9CDD-376B-9D44-CAF8AB2C08C7%22%2C%22_%24oldDataIndex%22%3A20%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A21%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22B06E0079-C0D6-CC89-916C-CAF8AB2C7DF8%22%2C%22_%24oldDataIndex%22%3A21%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A22%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22D6A06AB2-0DD1-19C3-CE54-CAF8AB2C0492%22%2C%22_%24oldDataIndex%22%3A22%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A23%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2299C0D4EA-FFCC-F3F5-239B-CAF8AB2C33E1%22%2C%22_%24oldDataIndex%22%3A23%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A24%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22E72EE3FB-7A37-DF18-D6DE-CAF8AB2C7F57%22%2C%22_%24oldDataIndex%22%3A24%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A25%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22C1923110-3588-735F-F5C5-CAF8AB2C97C5%22%2C%22_%24oldDataIndex%22%3A25%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A26%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2255F4AC8B-7445-4B2C-C5F8-CAF8AB2CCA70%22%2C%22_%24oldDataIndex%22%3A26%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A27%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2269BF4D0F-F299-BF7C-4071-CAF8AB2CA81F%22%2C%22_%24oldDataIndex%22%3A27%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A28%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22280C9D9F-985A-D4E8-3318-CAF8AB2C658A%22%2C%22_%24oldDataIndex%22%3A28%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A29%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22AAFB1ED9-7F8D-5CE4-1615-CAF8AB2C81EA%22%2C%22_%24oldDataIndex%22%3A29%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A30%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22A24FC433-C2C5-89CC-5781-CAF8AB2C59E7%22%2C%22_%24oldDataIndex%22%3A30%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A31%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%221549BF9D-5BB9-E2B3-6D5E-CAF8AB2C6B30%22%2C%22_%24oldDataIndex%22%3A31%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A32%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22E8B07BA4-123D-94ED-E73E-CAF8AB2CDBD3%22%2C%22_%24oldDataIndex%22%3A32%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A33%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22166DFECF-F68F-6E9B-39FF-CAF8AB2CF03D%22%2C%22_%24oldDataIndex%22%3A33%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A34%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%229A1C14D2-B506-F178-753D-CAF8AB2CE329%22%2C%22_%24oldDataIndex%22%3A34%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A35%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2279D367E4-5023-F56C-7231-CAF8AB2C1A5A%22%2C%22_%24oldDataIndex%22%3A35%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A36%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22ABEC145D-8B3A-2660-6ADC-CAF8AB2C236E%22%2C%22_%24oldDataIndex%22%3A36%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A37%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2283A0930B-135A-5557-0181-CAF8AB2C018E%22%2C%22_%24oldDataIndex%22%3A37%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A38%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22FE61EB49-E7A2-CD75-4D74-CAF8AB2C953B%22%2C%22_%24oldDataIndex%22%3A38%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A39%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2229482DD1-82DF-A825-ED5C-CAF8AB2C79CA%22%2C%22_%24oldDataIndex%22%3A39%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A40%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%225E938C69-2868-3F16-A9D9-CAF8AB2CBA98%22%2C%22_%24oldDataIndex%22%3A40%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A41%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22B3CC0678-7696-610D-7975-CAF8AB2C2C79%22%2C%22_%24oldDataIndex%22%3A41%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A42%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%222D10A522-258F-305E-E991-CAF8AB2C892A%22%2C%22_%24oldDataIndex%22%3A42%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A43%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22E25E54D2-0037-2F18-D8C3-CAF8AB2C71D9%22%2C%22_%24oldDataIndex%22%3A43%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A44%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2209D5551D-CC6D-FADA-B833-CAF8AB2C450C%22%2C%22_%24oldDataIndex%22%3A44%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A45%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%220316329D-5E59-C31C-4D2E-CAF8AB2C0DB8%22%2C%22_%24oldDataIndex%22%3A45%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A46%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22175872ED-F7B3-55D1-B708-CAF8AB2C6112%22%2C%22_%24oldDataIndex%22%3A46%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A47%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2291887FE3-3577-F086-BE81-CAF8AB2C5A4D%22%2C%22_%24oldDataIndex%22%3A47%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A48%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%224EBCB12F-6167-A4C1-4A55-CAF8AB2C6887%22%2C%22_%24oldDataIndex%22%3A48%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A49%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%220005D37F-2408-2A24-CD44-CAF8AB2C7E25%22%2C%22_%24oldDataIndex%22%3A49%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A50%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2285CF4B03-FA43-EF62-B798-CAF8AB2C96A3%22%2C%22_%24oldDataIndex%22%3A50%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A51%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22D1AABAA6-BDEA-2ED8-B206-CAF8AB2CD4C2%22%2C%22_%24oldDataIndex%22%3A51%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A52%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%224BB81BFB-5192-0468-4D2A-CAF8AB2C34F5%22%2C%22_%24oldDataIndex%22%3A52%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A53%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22638A40A1-B83C-D94C-1065-CAF8AB2CCD85%22%2C%22_%24oldDataIndex%22%3A53%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A54%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2200E6D7E0-70EA-9E8F-9068-CAF8AB2C4A18%22%2C%22_%24oldDataIndex%22%3A54%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A55%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2238B70E23-1EA7-3C8E-BBA4-CAF8AB2C29D0%22%2C%22_%24oldDataIndex%22%3A55%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A56%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22B54BF7D1-9220-6D17-E55D-CAF8AB2C400E%22%2C%22_%24oldDataIndex%22%3A56%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A57%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22BEDC0148-AC9E-A920-DA8E-CAF8AB2C44AE%22%2C%22_%24oldDataIndex%22%3A57%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A58%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%226A9B5AC4-A844-98F0-09DD-CAF8AB2CB53E%22%2C%22_%24oldDataIndex%22%3A58%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A59%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22C3A9B62A-6486-C26E-366D-CAF8AB2C5E85%22%2C%22_%24oldDataIndex%22%3A59%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A60%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%226C3BB144-19C1-1F35-6A3C-CAF8AB2C620D%22%2C%22_%24oldDataIndex%22%3A60%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A61%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22538148EA-A498-F140-0323-CAF8AB2C5141%22%2C%22_%24oldDataIndex%22%3A61%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A62%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%229A64CD6E-7981-6B6E-C5E1-CAF8AB2C42D9%22%2C%22_%24oldDataIndex%22%3A62%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A63%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22D9C924D3-A5E5-42EB-247E-CAF8AB2CBBC6%22%2C%22_%24oldDataIndex%22%3A63%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A64%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%224954419F-55BE-16E1-0EF9-CAF8AB2CFA4E%22%2C%22_%24oldDataIndex%22%3A64%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A65%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22E6F76D84-AC6B-604D-1563-CAF8AB2C85BC%22%2C%22_%24oldDataIndex%22%3A65%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A66%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2287352B74-E426-2E33-8853-CAF8AB2CCED6%22%2C%22_%24oldDataIndex%22%3A66%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A67%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%223AFFE182-A590-7030-0707-CAF8AB2C5529%22%2C%22_%24oldDataIndex%22%3A67%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A68%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22C92982D7-90C9-57E9-804F-CAF8AB2C6CD9%22%2C%22_%24oldDataIndex%22%3A68%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A69%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2290DDA8EF-6899-F060-75B2-CAF8AB2CE32D%22%2C%22_%24oldDataIndex%22%3A69%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A70%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2277DD69E7-7545-D213-23BB-CAF8AB2C5C19%22%2C%22_%24oldDataIndex%22%3A70%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A71%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22BA1988E8-FB63-8AE6-6E9A-CAF8AB2C9345%22%2C%22_%24oldDataIndex%22%3A71%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A72%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22BFBAA79C-7428-63E1-04A6-CAF8AB2C4604%22%2C%22_%24oldDataIndex%22%3A72%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A73%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22681495BE-8FC9-1DFA-C3C7-CAF8AB2CFADD%22%2C%22_%24oldDataIndex%22%3A73%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A74%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22B7AD7747-D2DE-7E11-B446-CAF8AB2C0E93%22%2C%22_%24oldDataIndex%22%3A74%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A75%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%223A3B10D8-8177-46B5-A049-CAF8AB2CED16%22%2C%22_%24oldDataIndex%22%3A75%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A76%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22221CEC34-4C9F-EFD0-7842-CAF8AB2CFB4F%22%2C%22_%24oldDataIndex%22%3A76%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A77%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%229C1B9EF1-FFBA-5C44-F88F-CAF8AB2C72B0%22%2C%22_%24oldDataIndex%22%3A77%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A78%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22AA73C8B9-2D56-A194-FAF0-CAF8AB2C7E2A%22%2C%22_%24oldDataIndex%22%3A78%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A79%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22AD876DC3-0809-7F61-606F-CAF8AB2C2B74%22%2C%22_%24oldDataIndex%22%3A79%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A80%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%226A29F24A-3541-544B-F97E-CAF8AB2C76EB%22%2C%22_%24oldDataIndex%22%3A80%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A81%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22EBDC7A37-1D27-8328-79C8-CAF8AB2C6007%22%2C%22_%24oldDataIndex%22%3A81%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A82%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2271C5EDA8-5EC7-8910-9030-CAF8AB2CDCC6%22%2C%22_%24oldDataIndex%22%3A82%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A83%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22BA66513C-0009-A9C1-8D98-CAF8AB2C64BB%22%2C%22_%24oldDataIndex%22%3A83%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A84%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%222AAD49EA-E83D-D89A-9DE5-CAF8AB2C3B38%22%2C%22_%24oldDataIndex%22%3A84%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A85%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2284C5A3B4-2BC3-50D3-7CB1-CAF8AB2C3037%22%2C%22_%24oldDataIndex%22%3A85%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A86%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2249A8D7A7-F88E-3C10-FC69-CAF8AB2C3FAB%22%2C%22_%24oldDataIndex%22%3A86%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A87%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22B1AF0176-8631-4F89-5F4E-CAF8AB2C2779%22%2C%22_%24oldDataIndex%22%3A87%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A88%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%227AFCCAB0-76B9-3065-D4FD-CAF8AB2CF7B0%22%2C%22_%24oldDataIndex%22%3A88%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A89%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22EDC3E77B-7083-905D-AD96-CAF8AB2CC53C%22%2C%22_%24oldDataIndex%22%3A89%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A90%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2278C2BD62-0F03-E392-6B24-CAF8AB2C5DE6%22%2C%22_%24oldDataIndex%22%3A90%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A91%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%221220127E-6995-C5C7-D180-CAF8AB2C4BF4%22%2C%22_%24oldDataIndex%22%3A91%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A92%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%223A986A8A-3BF7-4228-DD36-CAF8AB2CA846%22%2C%22_%24oldDataIndex%22%3A92%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A93%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22BCBA7B01-F4B9-A531-7144-CAF8AB2C0429%22%2C%22_%24oldDataIndex%22%3A93%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A94%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%2235A0D6ED-31E6-DD5F-BB81-CAF8AB2CB763%22%2C%22_%24oldDataIndex%22%3A94%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A95%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%229A9FD68E-C943-3EE2-27A7-CAF8AB2CADD5%22%2C%22_%24oldDataIndex%22%3A95%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A96%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22DEA4AD0F-A0D6-9EAA-DCD3-CAF8AB2C6273%22%2C%22_%24oldDataIndex%22%3A96%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A97%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22513D3792-B924-B8C5-F28D-CAF8AB2C60E0%22%2C%22_%24oldDataIndex%22%3A97%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A98%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22F327AD8A-532F-2736-AAC9-CAF8AB2CB8E9%22%2C%22_%24oldDataIndex%22%3A98%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A99%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22FDDF44E6-C4F6-168B-FA3E-CAF8AB2C160D%22%2C%22_%24oldDataIndex%22%3A99%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%2C%7B%22index%22%3A100%2C%22_%24isVisible%22%3Atrue%2C%22_%24isBranch%22%3Afalse%2C%22uuid%22%3A%22945AA10C-F537-1A38-929E-CAF8AB2C8C55%22%2C%22_%24oldDataIndex%22%3A100%2C%22_%24depth%22%3A1%2C%22_%24leafCount%22%3A0%7D%5D%7D";

function saveGantt(isSaveAs){
	var target = $("#formView01");  
	var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
	var param = "isSaveAs=" + isSaveAs;
	axboot.modal.open({
        modalType: "SAVE_GANTT",                                  
        param: param,
        header:{title:LANG("ax.script.gantt.save.title")},
        sendData: function(){
            return { oid : oid};
        },
        callback: function (data) {
            //console.log("data " , data);
          
           saveGanttData(data, isSaveAs);
           this.close();
           
        }
    });
	
}	  	
function deleteProjectInfo(){
	axDialog.confirm({
	    msg: LANG("ax.script.form.clearconfirm")
	}, function () {
	    if (this.key == "ok") {
	    	_deleteProjectInfo();
	    }
	});
	//console.log("kkkkkk", parent.fnObj.tabView.target.find('.tab-item'));
}

function _deleteProjectInfo(){
	var target = $("#formView01");
	var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
	var code = target.find('[data-ax-path="' + "code" + '"]').val();
	var sendData = {oid : oid};
	
	axboot.ajax({
        type: "PUT", 
        url: ["gantt", "delete"], 
        data: JSON.stringify(sendData),
        callback: function (res) {
            // ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            //caller.formView01.setData(res);
            if (res.error) {
                alert(res.error.message);
                return;
            }
            //console.log("res", res);
            axToast.push(LANG("ax.script.menu.category.saved"));
            
            parent.fnObj.tabView.closeAndOpen(code, '19');
 
                       
            //console.log("kkkkkk", parent.fnObj.tabView.target.find('.tab-item'));
            
        }
    });
}


/*프로젝트 산출물 보기 화면으로 이동시 */
function moveProjectOutput(){
	var target = $("#formView01");  
	var oid = target.find('[data-ax-path="' + "oid" + '"]').val();
	
    if(oid != '' && oid.length > 0){
		location.href = "<c:url value='/jsp/project/project-out.jsp'/>?oid=" + oid;
    } else{
		alert(MSG('ks.Msg.5'));   //프로젝트 저장후 장 후 이용가능합니다. 
		$( document.activeElement ).blur();
		return;
	}
	location.href = "<c:url value='/jsp/project/project-out.jsp'/>?oid=" + oid;
}

function changeProjectStartDate() {
	
	var target = $("#formView01");
	
	var dateString = target.find('[data-ax-path="pjtStartDate"]').val();
	//var dateString = document.getElementById("dateInput").value;
	var date = new Date(dateString);
	
	if(isNaN(date)) {
		alert(LANG("ax.script.ks.02"));
		return;
	}
	var message = dateString + LANG("ax.script.ks.03");
	if(confirm(message)) {
		// 간트 프로젝트 시작 날짜 변경 적용
		AUIGantt.setProjectStartDate(myGanttID, date);
	}
};

</script>
</jsp:attribute>
<jsp:body>

   
	<%-- <ax:page-buttons></ax:page-buttons> --%>
<ax:form name="formView01">
<input type="hidden" name="oid" data-ax-path="oid"  value="${param.oid}" />
<input type="hidden" name="prj_name" data-ax-path="prj_name"  value="" />
<input type="hidden" name="desc" data-ax-path="desc"  value="" />
<input type="hidden" name="code" data-ax-path="code"  value="" />

<div id="main">
	
	
			<!-- 부트스트랩으로 작업 메뉴 작성 -->
			
		<div role="tabpanel" id="main_top">
			<ul class="nav nav-tabs" role="tablist"> 

			<li role="presentation" class="text-center tab-menu-btn" id="task_tab">
			<a href="#task_tabpanel" aria-controls="taskTab" role="tab" data-toggle="tab"><ax:lang id="ks.Msg.1"/></a>  <!-- 작성 -->
			</li>



			<li role="presentation" class="text-center tab-menu-btn" id="view_tab">
			<a href="#view_tabpanel" aria-controls="viewTab" role="tab" data-toggle="tab"><ax:lang id="ks.Msg.2"/></a> <!-- 보기 -->
			</li>

			<li role="presentation" class="text-center tab-menu-btn">
			<a href="javaScript:moveProjectOutput();"   role="tab" ><ax:lang id="ks.Msg.3"/></a>  <!-- 산출물 -->
		
			</li>
  
			</ul>
<div id="task_menus">
	<div id="navTabContent" class="tab-content"> 
			<div role="tabpanel" class="tab-pane form-inline" id="task_tabpanel">
			
				<div class="btn-group" role="group"> 
				   		<button type="button" class="btn btn-default" id="btnOutdent" data-rel="tooltip-bottom" title="작업 수준 올리기. 계층 구조에서 요약 작업이 될 수 있습니다. (Alt + Shift + 왼쪽 화살표)">
				   			<span class="glyphicon glyphicon-arrow-left" aria-hidden="true"></span>
				   		</button> 
				   		<button type="button" class="btn btn-default" id="btnIndent" data-rel="tooltip-bottom" title="작업 수준 내리기. 하위 작업으로 만듭니다. 계층 구조가 됩니다. (Alt + Shift  + 오른쪽 화살표)"> 
				   			<span class="glyphicon glyphicon-arrow-right" aria-hidden="true"></span> 
				   		</button> 
				   		<button type="button" class="btn btn-default" id="btnMoveUp" data-rel="tooltip-bottom" title="선택 작업을 위로 올립니다.(Alt + Shift + 위 화살표)"> 
				   			<span class="glyphicon glyphicon-arrow-up" aria-hidden="true"></span> 
				   		</button> 
				   		<button type="button" class="btn btn-default" id="btnMoveDown" data-rel="tooltip-bottom" title="선택 작업을 아래로 내립니다.(Alt + Shift + 아래 화살표)"> 
				   			<span class="glyphicon glyphicon-arrow-down" aria-hidden="true"></span> 
				   		</button> 
				   	</div>  
				   	
				 <button type="button" class="btn btn-default" id="btnInsert" data-rel="tooltip" title="선택 행에 작업을 삽입합니다. (Insert)">
				   		<span class="glyphicon glyphicon-plus" aria-hidden="true"></span> <ax:lang id="ks.Msg.6"/>  <!--작업 삽입 --> 
				   </button> 
				   <button type="button" class="btn btn-default" id="btnMgInsert" data-rel="tooltip" title="선택 행에 중요시점 작업을 삽입합니다."> 
				   		<span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span> <ax:lang id="ks.Msg.7"/>  <!--중요시점 삽입  -->  
				   	</button> 
				   	<!--  
				   	<button type="button" class="btn btn-default" id="btnBlankInsert" data-rel="tooltip" title="선택 행에 빈행을 삽입합니다."> 
				   		<span class="glyphicon glyphicon-unchecked" aria-hidden="true"></span> 빈행 삽입 
				   	</button>
				   	-->
				   	<button type="button" class="btn btn-default" id="btnDel" data-rel="tooltip" title="선택 작업을 삭제합니다. (Ctrl + Del)"> 
				   		<span class="glyphicon glyphicon-remove" aria-hidden="true"></span> <ax:lang id="ks.Msg.8"/>  <!--작업 삭제-->  
				   	</button>
				   	
				   	<button type="button" class="btn btn-default" id="btnAddLast" data-rel="tooltip" title="선택 작업을 삭제합니다."> 
				   		<span class="glyphicon glyphicon-plus" aria-hidden="true"></span> <ax:lang id="ks.Msg.11"/> <!-행 추가-->  
				   	</button>
				   	
				   	
				   	<button type="button" class="btn btn-default" id="autoCal" data-rel="tooltip" title="선택 작업을 삭제합니다."> 
				   		<span class="glyphicon glyphicon-plus" aria-hidden="true"></span><ax:lang id="ks.Msg.19"/> <!-자동진척율계산-->  
				   	</button>
				   	
				   	
				   	
				   	<div class="btn-group" role="group">
			   		<button type="button" id="btnBold" class="btn btn-default" title="굵게 (Ctrl + B)">
			   				<span class="glyphicon glyphicon-bold" aria-hidden="true"></span> 
			   		</button> 
			   		<button type="button" id="btnItalic" class="btn btn-default " title="기울임꼴 (Ctrl + I)">
			   				<span class="glyphicon glyphicon-italic" aria-hidden="true"></span> 
			   		</button> 
			   		<button type="button" id="btnUnderline" class="btn btn-default " title="밑줄 (Ctrl + U)">
			   				<span class="glyphicon glyphicon-text-color" aria-hidden="true"></span> 
			   		</button> 
			   	</div> 
			   	
			   <div class="btn-group" role="group"> 
				   <button type="button" id="btnBgColor" class="btn btn-default " title="배경 색상"> 
				   		<span class="glyphicon glyphicon-text-color" data-color="#ffff00" style="background-color:#ffff00;" aria-hidden="true"></span> 
				   </button> 
				   <button type="button" id="btnBgColor-picker" class="btn btn-default colorpicker-element" style="padding:3px 2px;" title="배경 색상 선택"> 
				   		<span class="caret"></span>  
				   </button> 
			   </div>
			    
			   <div class="btn-group" role="group">
			   		<button type="button" id="btnColor" class="btn btn-default " title="글자 색상"> 
			   			<span class="glyphicon glyphicon-text-background" data-color="#ff0000" style="background-color:#ff0000" aria-hidden="true"></span>
			   		</button> 
			   		<button type="button" id="btnColor-picker" class="btn btn-default colorpicker-element" style="padding:3px 2px;" title="글자 색상 선택"> 
				   		<span class="caret"></span> 
				   	</button> 
			    </div>
			    
			    <div  data-ax5picker="date" class="input-group" style="width:120px" >
                    <input type="text" data-ax-path="pjtStartDate" class="form-control" placeholder="yyyy/mm/dd"/> 
                    <span class="input-group-addon"><i class="cqc-calendar"></i></span>
                 </div> 
			     <button type="button" class="btn btn-default" onclick="changeProjectStartDate();"><ax:lang id="ks.Msg.33"/> <!-- 프로젝트 시작일 변경 --></button>
			</div>
				
			<div role="tabpanel" class="tab-pane form-inline" id="view_tabpanel" > 
				<span class="bold" style="margin-left: 16px;"><ax:lang id="ks.Msg.12"/> : </span> <!-- 시간단위 --> 
				
				<select id="timeSelect"  onchange="timeSelectChangeHandler()">
                      <!--  
                      <option value="ko_KR"><ax:lang id="ax.admin.sample.language.korean"/></option>
                      <option value="en_US"><ax:lang id="ax.admin.sample.language.english"/></option>-->
                       
                    <option value="year"><ax:lang id="ks.Msg.21"/></option>  <!--년-->
					<option value="half"><ax:lang id="ks.Msg.22"/></option><!--반기--> 
					<option value="quarter"><ax:lang id="ks.Msg.23"/></option><!--분기-->
					<option value="month"><ax:lang id="ks.Msg.24"/></option><!--월-->
					<option value="month2"><ax:lang id="ks.Msg.25"/></option><!--월2-->
					<option value="week"><ax:lang id="ks.Msg.26"/></option><!--주-->
					<option value="week2"><ax:lang id="ks.Msg.27"/></option><!--주2-->
					<option value="day"><ax:lang id="ks.Msg.28"/></option><!--일-->
					<option value="day2"><ax:lang id="ks.Msg.29"/></option><!--일2-->
					<option value="6hours"><ax:lang id="ks.Msg.30"/></option><!--6시간-->
					<option value="hour"><ax:lang id="ks.Msg.31"/></option><!--1시간-->
					<option value="30minutes"><ax:lang id="ks.Msg.32"/></option><!--30분-->
                </select>
                  
				<button type="button" class="btn btn-default" onclick="zoomIn();"><ax:lang id="ks.Msg.13"/> <!-- 확대 --></button>
				<button type="button" class="btn btn-default" onclick="zoomOut();"><ax:lang id="ks.Msg.14"/> <!-- 축소 --></button>
				
				<button type="button" class="btn btn-default" id="btnFit" data-rel="tooltip" title="선택 작업을 삭제합니다. (Ctrl + Del)"> 
			   		<ax:lang id="ks.Msg.15"/> <!-- 전체보기 -->  
			   	</button>
			   	<button type="button" class="btn btn-default" id="btnMove" data-rel="tooltip" title="선택 작업을 삭제합니다. (Ctrl + Del)"> 
			   		<ax:lang id="ks.Msg.16"/> <!-- 선택항목으로 이동 -->   
			   	</button>
			   	<button class="btn btn-default" onclick="saveAsExcel('day')"><ax:lang id="ks.Msg.17"/><!-- 일(day) 단위 엑셀로 저장하기 --></button>
			    <button class="btn btn-default" onclick="saveAsExcel('week')"><ax:lang id="ks.Msg.18"/><!-- 주(week) 단위 엑셀로 저장하기 --></button>		
                
			</div>
				
<!-- <ul class="select_dic_lang"> 
<li><a title="Korean" class="ko on" href="/prj/project.html?lan=kr">Korean</a></li>
<li><a title="English" class="en" href="/prj/project.html">English</a></li>
</ul> 

<p style="position:absolute;top:78px; right: 10px;font-size:12px;">Bug Report : <strong>khkim@kSolution.com</strong></p>
 --> 
<!-- <div class="tooltip left login-btn-tooltip">
  <div class="tooltip-arrow" style="top: 50%;">
  </div>
  
  <div class="tooltip-inner">Google, NAVER 계정으로 로그인 하십시오.</div> 
</div>  -->
<c:choose>
	<c:when test="${param.oid != '' && param.oid ne null}">
 		<button type="button" title="Save As" class="btn btn-success saveAs-btn" onclick="saveGantt(true)" >Save As</button>  
 		<button type="button" title="save" class="btn btn-success modify-btn" onclick="saveGantt()">Modify</button>
 		<button type="button" title="Save As" class="btn btn-success delete-btn" onclick="deleteProjectInfo()" >Delete</button>  
 	</c:when>
 <c:otherwise>
 <button type="button" title="save" class="btn btn-success save-btn" onclick="saveGantt(false)">Save</button>
 </c:otherwise>
</c:choose>			
</div><!--  <dic id = navTabContent -->
</div> <!-- <div id="task_menus"> end -->
</div> <!--  <div role="tabpanel" -->
			<!-- <div id="task_menus">
			</div> -->
			
			<!--  end of  #task_menus --> 
		<!-- <div style="height:3px"> 
        </div> -->
		
		<!-- 에이유아이간트가 이곳에 생성됩니다. -->
		<div id="gantt_wrap" style="width:100%; height:400px;"></div>
		
		<!-- <div id="desc_bottom">
		</div> --> 
	
</div> <!--  <div id="main"> -->

</ax:form>
</jsp:body>
</ax:layout>