/**
 * AUIGrid 에서 사용되는 메세지들을 정의합니다.
 */
AUIGridMessages = {
		/*
		 * 그리드에 출력시킬 데이터가 없는 메세지 
		 */
		noDataMessage: "No Data to display",
		
		/*
		 * 그룹핑 패널 메세지
		 */
		groupingMessage: "Drag a column header and drop here to group by that",
		
		/*
		 * 필터 메뉴 메세지들 
		 */
		filterNoValueText: "( Empty Value )",
		filterCheckAllText: "( Check All )",
		filterClearText: "Clear Filter",
		filterSearchCheckAllText: "( Check All Found )",
		filterSearchPlaceholder : "Search", // 필터 검색 플레이홀더 텍스트
		filterOkText: "Okay",
		filterCancelText: "Cancel",
		filterItemMoreMessage: "Too many items...Search words",
		filterNumberOperatorList: ["Equal(=)", "Greater than(>)", "Greater than or Equal(>=)", "Less than(<)", "Less than or Equal(<=)", "Not Equal(!=)"],
	   
		/*
		 * 천 단위 구분자
		 */
		thousandSeparator : ",",
		
		/*
		 * 그룹핑 썸머리 합계 메세지
		 */
		summaryText: "Summary",
		
		/*
		 * 행번호 칼럼의 헤더 텍스트
		 */
		rowNumHeaderText: "No.",
		
		/*
		 * 원격(리모트) 리스트 렌더러 검색 텍스트
		 */
		remoterPlaceholder: "Input your text",
		
		/* 
		 * 기본 컨텍스트 메뉴 
		 */
		contextTexts: ["Show only $value", "Show all except $value", "Hide $value", "Clear Filtering All", "Fixed Columns", "Clear Fixed Columns all"],
		
		/*
		 * 달력
		 */
		calendar : {
			titles : ["S", "M", "T", "W", "T", "F", "S"],
			formatYearString : "yyyy",
			monthTitleString : "mmm",
			formatMonthString : "mmm, yyyy",
			todayText : "Today",
			uncheckDateText : "Delete the date"
		},
		
		/*
		 * 내보내기 진행 표시
		 */
		exportProgress : {
			init : "Initializing Exporting...",
			progress : "Exporting in progress...",
			complete : "Almost Complete..."
		}
};