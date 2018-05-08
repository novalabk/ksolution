var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
	PAGE_SEARCH : function(caller, act, data) {
	   
		var folderOid = "";
		var selectFolders = this.gridViewFolder.getData("selected");
		if(selectFolders.length > 0){
			folderOid = selectFolders[0].oid;
		}
		
		var sendData = $.extend({}, {folderOid: folderOid});

		
		axboot.call({
			type : "GET",
			url : [ "spBasket",  "search" ],
			data : sendData,
			callback : function(res) {
				// caller.treeView01.clearDeletedList();
				console.log("kkkkkkkkkkkk ", res);
				caller.gridView01.setData(res);
			}
		})
		.call({
			type : "GET",
			url : [ "spBasket", "searchFolder" ],
			data : $.extend({}, this.gridView01.getPageData()),
			callback : function(res) {

				caller.gridViewFolder.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			}
		})
		.done(function() {
			if (data && data.callback) {
				data.callback();
			} else {
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
			}
		});

		return false;
	},
	PAGE_SAVE: function (caller, act, data) {
        //var saveList = [].concat(caller.gridView01.getData());
        var saveList = [];
        //console.log("deleted", caller.gridView01.getData("deleted"));
        saveList = saveList.concat(caller.gridView01.getData("deleted"));
        
        var deleteOids = [];
        saveList.forEach(function(n) {
        	deleteOids.push(n.oid);
		});
        
        axboot.ajax({
            type: "PUT",
            url: ["spBasket", "deleteLink"],
            data: JSON.stringify(deleteOids),
            callback: function (res) {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                axToast.push(LANG("onsave"));
            }
        });
    },
    
    ITEM_SELECT : function(caller, act, data) {
 	   
		var folderOid = "";
		var selectFolders = this.gridViewFolder.getData("selected");
		if(selectFolders.length > 0){
			folderOid = selectFolders[0].oid;
		}
		
		var sendData = $.extend({}, {folderOid: folderOid});

		
		axboot.call({
			type : "GET",
			url : [ "spBasket",  "search" ],
			data : sendData,
			callback : function(res) {
				// caller.treeView01.clearDeletedList();
				console.log("kkkkkkkkkkkk ", res);
				caller.gridView01.setData(res);
			}
		})
		/*.call({
			type : "GET",
			url : [ "spBasket", "searchFolder" ],
			data : $.extend({}, this.gridView01.getPageData()),
			callback : function(res) {

				caller.gridViewFolder.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			}
		})*/
		.done(function() {
			if (data && data.callback) {
				data.callback();
			} else {
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
			}
		});

		return false;
	},

/*	PAGE_SAVE : function(caller, act, data) {
		var saveList = [].concat(caller.gridView01.getData());
		saveList = saveList.concat(caller.gridView01.getData("deleted"));

		axboot.ajax({
			type : "PUT",
			url : [ "programs" ],
			data : JSON.stringify(saveList),
			callback : function(res) {
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
				axToast.push(LANG("onsave"));
			}
		});
	},*/
	PAGE_CHOICE: function (caller, act, data) {
        var list = caller.gridView01.getData("selected");
        if (list.length > 0) {
        	var infoId = parseInt($("#infoId").val());
        	var code = $("#code").val();
        	
        	var pmList = new Array();
        	
        	for(var i = 0; i < list.length; i++){
        		
        		var row = list[i];
        		
        		console.log(row);
        		
        		var obj = new Object();
        		obj.code = code;
        		obj.pjtInfoId = infoId;
        		obj.materialId = row.oid;
        		
        		pmList.push(obj);
        	}
        	console.log(pmList);
        	
        	axboot.ajax({
                type: "PUT",
                url: ["pjtInfoMaterial"],
                data: JSON.stringify({list : pmList}),
                callback: function (res) {
                	parent.axboot.modal.callback();
                }
            });
        	
        } else {
            alert(LANG("ax.script.requireselect"));
        }
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

	FOLDER_CREATE : function(caller, act, data) {
		axboot.modal.open({
			modalType : "BSFolder-MODAL",
			param : "",
			param : "",
			header : {
				title : "폴더 생성"
			},
			sendData : function() {
				return {
					"sendData" : "AX5UI"
				};
			},
			onStateChanged : function() {
				// mask
				if (this.state === "open") {
					// alert("open");
				} else if (this.state === "close") {
					window.location.reload();

				}
			},
			callback : function(data) {

				/*
				 * caller.formView01.setEtc3Value({ key: data.key, value:
				 * data.value });
				 */
				this.close();
			}
		});

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
		_this.gridViewFolder.initView();
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
			},
			"save": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
            },
			"choice" : function(){
				ACTIONS.dispatch(ACTIONS.PAGE_CHOICE);
			},
			"close" : function() {
				alert("close");
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
		this.folderOid = $("#folderOid");

		axboot.buttonClick(this, "data-form-view-01-btn", {

			"folder" : function() {

				ACTIONS.dispatch(ACTIONS.FOLDER_CREATE);
			}
		});

		$('#folderOid').on({

			change : function() {

				// ACTIONS.dispatch(ACTIONS.SELECT_PROG, "");
				// ACTIONS.dispatch(ACTIONS.MENU_AUTH_CLEAR);
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
				// alert("onchange...");
			}
		});
	},
	getData : function() {

		// alert(this.filter.val());

		return {

			folderOid : ""
		}
	}
});


fnObj.thumnailPopup = function(obj){
	var thumbnail = $(obj).attr("data-thumbnail-link");
	var thumbPop = window.open(thumbnail, "", "width=500,height=500");
}

fnObj.thumnailView = function(obj,isView){

	if(isView){
		
		var thumbnail = $(obj).attr("data-thumbnail-link");
		var thumbView = '<img src="' + thumbnail+ '">';
		$("[data-thumbview]").html(thumbView);
		$("[data-thumbview]").show();
		
		var offset = $(obj).offset();
		var height = $("[data-thumbview] img").height();
		
		var clientHeight = document.body.clientHeight;
		
		var top = offset.top;
		var left = offset.left + 20;
		
		var offsetHeight = height + top;
		
		if(clientHeight < offsetHeight){
			top -= height;
		}
		
		$("[data-thumbview]").css("top", top + "px");
		$("[data-thumbview]").css("left",left + "px");
		
	}else{
		$("[data-thumbview]").hide();
	}
}

/**
 * gridView
 */
fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
	page : {
		pageNumber : 0,
		pageSize : 10
	},
	initView : function() {

		var _this = this;
		this.target = axboot.gridBuilder({
			target : $('[data-ax5grid="grid-view-01"]'),
			showRowSelector : true,
			multipleSelect: true,
			frozenColumnIndex : 0,
			sortable: true,
			columns: [
            	{
            		key: "material.thumbnail",
                    label: '',//COL("user.id"),
                    width: 40,
                    sortable : false,
					align: "center", formatter: function () {
						if(this.value){
							var tumb = this.value.thumbnail;
							return '<img src="' + tumb + '" style="width:20px;height:20px;position:relative;top:-2px;cursor:pointer;" onclick="fnObj.thumnailPopup(this)" onmouseover="fnObj.thumnailView(this,true)" onmouseout="fnObj.thumnailView(this,false)" data-thumbnail-link="' + tumb + '">';
						}else{
							return '';
						}
					}
            	},
            	{
                    key: "material.serialNumber",
                    label: '일련번호',//COL("user.id"),
                    width: 120
                },
                {
                    key: "material.typePath",
                    label: '분류 ',//COL("user.name"),
                    width: 200,
                    sortable : false
                },
                {
                    key: "material.mfCompanyName",
                    label: '브랜드',//COL("user.name"),
                    width: 120
                },
                {
                    key: "material.seriese",
                    label: '시리즈',//COL("user.name"),
                    width: 120
                }, 
                
                {
                    key: "material.number",
                    label: '품번',//COL("user.id"),
                    width: 120
                },
                {
                    key: "material.cmprice",
                    label: '소비자가',//COL("user.name"),
                    width: 120
                },
                
                {
                    key: "material.origin",
                    label: '원산지',//COL("user.name"),
                    width: 120
                },
                {
                    key: "material.m_exist_str",
                    label: '자재 유무',//COL("user.name"),
                    width: 120
                }
                /*,
                {key: "material.generatedcreatedAt", 
                	label:'작성일' ,
                	width : 180,
                	formatter : function() {
					if (this.value)
						return ax5.util.date(new Date(this.value || ""), {
							"return" : 'yyyy/MM/dd hh:mm:ss'
						});

					return this.value;
                	}
                },//COL("user.language")},
                {key: "material.createdBy", label:'작성자'}*/
             
		    ],
		    
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


/**
 * gridView
 */
fnObj.gridViewFolder = axboot.viewExtend(axboot.gridView, {

	initView : function() {
		var _this = this;
		this.target = axboot.gridBuilder({
			target : $('[data-ax5grid="grid-view-folder"]'),
			showLineNumber: false,
			sortable: true,
			showRowSelector : false,
			editable : false,
			//showRowSelector : true,
			//frozenColumnIndex : 2,
			//multipleSelect : false, 
			columns : [ {
				key : "folderNm",
				label : '폴더명',// COL("user.id"),
			 	width : "100%"
			}],
			body : {
				onClick : function() {
					
					this.self.select(this.dindex, {
						selectedClear : true
					});
					
					ACTIONS.dispatch(ACTIONS.ITEM_SELECT);
				}
			},

			onPageChange : function(pageNumber) {
				_this.setPageData({
					pageNumber : pageNumber
				});
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
			}
		});

//		axboot.buttonClick(this, "data-grid-view-01-btn", {
//			"add" : function() {
//				ACTIONS.dispatch(ACTIONS.ITEM_ADD);
//			},
//			"delete" : function() {
//				ACTIONS.dispatch(ACTIONS.ITEM_DEL);
//			},
//			"save" : function() {
//				ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
//			}
//		});
	},
	setData : function(_data) {
		console.log(_data);
		this.target.setData(_data);
	},
	
	getData: function (_type) {
        var list = [];
        var _list = this.target.getList(_type);

        if (_type == "modified" || _type == "deleted") {
            list = ax5.util.filter(_list, function () {
                return this.key;
            });
        } else {
            list = _list;
        }
        return list;
    }
	/*getData : function(_type) {
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
	}*/
});