var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
	PAGE_SEARCH : function(caller, act, data) {

		var sendData = $.extend({}, this.gridView01.getPageData());

		axboot.ajax({
			type : "GET",
			url : [ "spBasket", "searchFolder" ],
			data : $.extend({}, this.gridView01.getPageData()),
			callback : function(res) {

				caller.gridView01.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			}
		});

		return false;
	},
	PAGE_SAVE : function(caller, act, data) {
		var saveList = [].concat(caller.gridView01.getData());
		saveList = saveList.concat(caller.gridView01.getData("deleted"));
		console.log("saveList", saveList);
		axboot.ajax({
			type : "PUT",
			url : [ "spBasket" ],
			data : JSON.stringify(saveList),
			callback : function(res) {
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
				axToast.push(LANG("onsave"));
			}
		});
	},

	ITEM_ADD : function(caller, act, data) {
		caller.gridView01.addRow();
	},
	ITEM_DEL : function(caller, act, data) {
		caller.gridView01.delRow("selected");
	},

	/*
	 * ITEM_CLICK: function (caller, act, data) { axboot.ajax({ type: "GET",
	 * url: ["projects"], data: {projectCd: data.projectCd}, callback: function
	 * (res) { //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH); } }); },
	 */

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

var CODE = {};

// fnObj 기본 함수 스타트와 리사이즈
fnObj.pageStart = function() {
	var _this = this;

	axboot.call({
		type : "GET",
		url : [ "commonCodes" ],
		data : {
			groupCd : "USER_ROLE",
			useYn : "Y"
		},
		callback : function(res) {
			var userRole = [];
			res.list.forEach(function(n) {
				userRole.push({
					value : n.code,
					text : n.name + "(" + n.code + ")",
					roleCd : n.code,
					roleNm : n.name,
					data : n
				});
			});
			this.userRole = userRole;
		}
	}).done(function() {

		CODE = this; // this는 call을 통해 수집된 데이터들.

		_this.pageButtonView.initView();
		_this.searchView.initView();
		_this.gridView01.initView();

		ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	});
};

fnObj.pageResize = function() {

};

fnObj.pageButtonView = axboot.viewExtend({
	initView : function() {
		
	  
		axboot.buttonClick(this, "data-page-btn", {
			"search" : function() {

				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
			}
		});
	}
});

// == view 시작
/**
 * searchView
 */
fnObj.searchView = axboot.viewExtend(axboot.searchView, {
	initView : function() {
		this.target = $(document["searchView0"]);
		this.target.attr("onsubmit",
				"return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
		this.filter = $("#filter");

		axboot.buttonClick(this, "data-form-view-01-btn", {

			"folder" : function() {

				ACTIONS.dispatch(ACTIONS.FOLDER_CREATE);
			}
		});
	},
	getData : function() {

		// alert(this.filter.val());

		return {
			// pageNumber: this.pageNumber,
			// pageSize: this.pageSize,
			filter : this.filter.val()
		}
	}
});

/**
 * gridView
 */
fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {

	initView : function() {
		var _this = this;
		this.target = axboot.gridBuilder({
			target : $('[data-ax5grid="grid-view-01"]'),
			showRowSelector : true,
			frozenColumnIndex : 2,
			multipleSelect : true,
			columns : [ {
				key : "folderNm",
				label : '폴더명',// COL("user.id"),
				width : 200,
				editor : "text"
			}, {
				key : "generatedcreatedAt",
				width : 180,
				label : '작성일',
				/*formatter : function() {

					if (this.value)
						return ax5.util.date(new Date(this.value || ""), {
							"return" : 'yyyy/MM/dd hh:mm:ss'
						});

					return this.value; 
				}*/

			} ],
			body : {
				onClick : function() {
					this.self.select(this.dindex, {
						selectedClear : true
					});
				}
			},

			onPageChange : function(pageNumber) {
				_this.setPageData({
					pageNumber : pageNumber
				});
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
			}
		});

		axboot.buttonClick(this, "data-grid-view-01-btn", {
			"add" : function() {
				ACTIONS.dispatch(ACTIONS.ITEM_ADD);
			},
			"delete" : function() {
				ACTIONS.dispatch(ACTIONS.ITEM_DEL);
			},
			"save" : function() {
				ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
			}
		});
	},
	setData : function(_data) {
		console.log(_data);
		this.target.setData(_data);
	},
	getData : function(_type) {
		var list = [];
		var _list = this.target.getList(_type);

		if (_type == "modified" || _type == "deleted") {
			list = ax5.util.filter(_list, function() {
				return this.oid != null;
			});
		} else {
			list = _list;
		}
		return list;
	},
	addRow : function() {
		this.target.addRow({}, "last");
	},
	align : function() {
		this.target.align();
	}
});