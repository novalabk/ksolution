var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
    	//console.log(caller.gridView01.getPageData());
    	//console.log(caller.searchView.getData());
    	
    	console.log(caller.gridView01);
    	
        axboot.ajax({
            type: "GET",
            url: ["project"],
            data: $.extend({}, caller.searchView.getData(), caller.gridView01.getPageData(), fnObj.gridView01sortInfo),
            callback: function (res) {
                caller.gridView01.setData(res);
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT);
            }
        });
        
        return false;
    },
    ITEM_CLICK: function (caller, act, data) {
        axboot.ajax({
            type: "GET",
            url: ["project"],
            data: {projectId: data.projectId},
            callback: function (res) {
                //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            }
        });
    },
    dispatch: function (caller, act, data) {
        var result = ACTIONS.exec(caller, act, data);
        if (result != "error") {
            return result;
        } else {
            // 직접코딩
            return false;
        }
    }
});

var CODE = {};

// fnObj 기본 함수 스타트와 리사이즈
fnObj.pageStart = function () {
    var _this = this;

    axboot
        .call({
            type: "GET",
            url: ["commonCodes"],
            data: {groupCd: "USER_ROLE", useYn: "Y"},
            callback: function (res) {
                var userRole = [];
                res.list.forEach(function (n) {
                    userRole.push({
                        value: n.code, text: n.name + "(" + n.code + ")",
                        roleCd: n.code, roleNm: n.name,
                        data: n
                    });
                });
                this.userRole = userRole;
            }
        })
        .done(function () {

            CODE = this; // this는 call을 통해 수집된 데이터들.

            _this.pageButtonView.initView();
            _this.searchView.initView();
            _this.gridView01.initView();

            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
        });
};

fnObj.pageResize = function () {

};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "search": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            }
        });
    }
});

//== view 시작
/**
 * searchView
 */
fnObj.searchView = axboot.viewExtend(axboot.searchView, {
    initView: function () {
        this.target = $(document["searchView0"]);
        this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
        this.target.find('[data-ax5picker="date"]').ax5picker({
            direction: "auto",
            content: {
                type: 'date'
            }
        });
    },
    getData: function () {
    	
    	var data = new Object();
    	data["pageNumber"] = this.pageNumber;
    	data["pageSize"] = this.pageSize;
    	
    	$(this.target).find("[data-ax-path]").each(function(){
    		var path = $(this).attr("data-ax-path");
    		data[path] = $(this).val();
    	});
    	
        return data;
    }
});

/**
 * gridView
 */
fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
	page: {
        pageNumber: 0,
        pageSize: 50
    },
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            target: $('[data-ax5grid="grid-view-01"]'),
            showRowSelector: false,
            sortable: true,
            frozenColumnIndex: 0,
            remoteSort: function () {
            	fnObj.gridView01sortInfo = this.sortInfo[0];
                //console.log(this.sortInfo[0]);
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            },
            columns: [
                {
                    key: "projectNm",
                    label: '프로젝트 명',//COL("user.name"),
                    width: 120
                },
                {key: "classification", label:'공간분류'},
                {key: "category", label:'공사구분'},
                {key: "area", label:'시공면적'},
                {key: "clientNm", label:'의뢰인'},
                {key: "designerNm", label:'설계자'},
                {key: "fieldAgentNm", label:'현장대리인'},
                {key: "address", label:'현장주소'},
                {key: "generatedcreatedAt", label:'등록일'},
                {key: "createdBy", label:'등록자'},
//                {key: "startDate", label:'프로젝트 시작일'},//COL("user.language")},
//                {key: "endDate", label:'프로젝트 종료일'},//COL("ax.admin.use.or.not")}
//                {key: "projectActive", label:'프로젝트 활성화',  editor: "checkYn"},
//                {key: "thumbnail", label: "thumbnail", width: 60, align: "center", formatter: function () {
//                    return '<img src="/assets/favicon.ico">'
//                }}
            ],
            body: {
                onClick: function () {
//                    this.self.select(this.dindex);
//                    console.log('onClick call!!!!!!!!!!!!!!!!!!!!!1' + this.dindex);
                },
                onDBLClick: function () {
                	//console.log(this);
                    location.href="/jsp/project/project-view.jsp?projectId=" + this.item.id;
                }
            },
            onPageChange: function (pageNumber) {
                _this.setPageData({pageNumber: pageNumber});
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            }
        });
    },
    setData: function (_data) {
    	//console.log(_data);
        this.target.setData(_data);
    },
    
    getData: function () {
        return this.target.getData();
    },
    align: function () {
        this.target.align();
    }
});