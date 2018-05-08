/**
 * AUIGrid 에서 사용되는 메세지들을 정의합니다.
 */
AUIGridMessages = {
		/*
		 * 그리드에 출력시킬 데이터가 없는 메세지 
		 */
		noDataMessage: "출력할 데이터가 없습니다.",
		
		/*
		 * 그룹핑 패널 메세지
		 */
		groupingMessage: "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
		
		/*
		 * 필터 메뉴 메세지들 
		 */
		filterNoValueText: "(필드 값 없음)",
		filterCheckAllText: "(전체선택)",
		filterClearText: "필터 초기화",
		filterSearchCheckAllText: "(검색 전체선택)",
		filterSearchPlaceholder : "검색", // 필터 검색 플레이홀더 텍스트
		filterOkText: "확 인",
		filterCancelText: "취 소",
		filterItemMoreMessage: "Too many items...Search words",
		filterNumberOperatorList: ["같다(=)", "크다(>)", "크거나 같다(>=)", "작다(<)", "작거나 같다(<=)", "같지 않다(!=)"],
		
		/*
		 * 천 단위 구분자
		 */
		thousandSeparator : ",",
		
		/*
		 * 그룹핑 썸머리 합계 메세지
		 */
		summaryText: "합계",
		
		/*
		 * 행번호 칼럼의 헤더 텍스트
		 */
		rowNumHeaderText: "No.",
		
		/*
		 * 원격(리모트) 리스트 렌더러 검색 텍스트
		 */
		remoterPlaceholder: "검색어를 입력하세요.",
		
		/* 
		 * 기본 컨텍스트 메뉴 
		 */
		contextTexts: ["$value 만 보기", "$value 제거하고 다 보기", "$value 제거하고 보기", "모든 필터링 초기화", "칼럼 틀 고정", "칼럼 틀 고정 초기화"],
		
		/*
		 * 달력
		 */
		calendar : {
			titles : ["일", "월", "화", "수", "목", "금", "토"],
			formatYearString : "yyyy년",
			monthTitleString : "m월",
			formatMonthString : "yyyy년 mm월",
			todayText : "오늘 선택",
			uncheckDateText : "날짜 선택 해제"
		},
		
		/*
		 * 내보내기 진행 표시
		 */
		exportProgress : {
			init : "내보내기 초기화 중...",
			progress : "내보내기 진행 중...",
			complete : "내보내기가 곧 완료됩니다."
		}
};