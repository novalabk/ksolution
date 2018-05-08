var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
    	axboot.ajax({
            type: "GET",
            url: ["project"],
            data: {projectId : fnObj.projectId},
            callback: function (res) {
                caller.formView01.setData(res);
            }
        });
    	ACTIONS.dispatch(ACTIONS.PAGE_SPACEMATERIAL);
    	ACTIONS.dispatch(ACTIONS.FILE_INIT);
    	
    },
    PAGE_EXCEL_DOWN : function(caller, act, data){
    	
    	var mask = window.axAJAXMask;
    	
		$.fileDownload("/api/v1/project/excel?projectId=" + fnObj.projectId, {
			prepareCallback: function (){
				mask.open();
			},
			abortCallback: function (url) {
				mask.close(300);
			},
			successCallback: function (url) {
				mask.close(300);
            },
            failCallback: function (responseHtml, url) {
            	mask.close(300);
            }
		});
    },
    PAGE_SPACEMATERIAL : function(caller, act, data){
    	
    	axboot.ajax({
            type: "GET",
            url: ["projectInfo", "material"],
            data: {projectId : fnObj.projectId},
            callback: function (res) {
            	
            	var list01 = new Array();
            	var list02 = new Array();
            	var list03 = new Array();
            	var defaultList = res.list;
            	
            	for(var i = 0; i < defaultList.length; i++){
            		var row = defaultList[i];
            		
            		
            		if(row.code == "material") {
            			
            			if(row.name == "BASIC_HWSCETC"){
            				caller.gridView04.setPjtInfo(row);
            			}else if(row.name == "BASIC_FRMATERIAL"){
            				caller.gridView03.setPjtInfo(row);
            			}
            			continue;
            		}
            		
            		if(row.pCode == "SPACE_BATH"){
            			list01.push(row);
            			list02.push(row);
            		}else if(row.pCode == "SPACE_FURNITURE"){
            			list03.push(row);
            		}else{
            			list01.push(row);
            		}
            	}
            	
            	res.list = list01;
            	
        		caller.gridView01.setData(res);
            	caller.gridView01.target.setColumnSort({sort : {seq : 0, orderBy : "asc"}});
            	
            	res.list = list02;
            	caller.gridView05.setData(res);
            	caller.gridView05.target.setColumnSort({sort : {seq : 0, orderBy : "asc"}});
            	
            	res.list = list03;
            	caller.gridView06.setData(res);
            	caller.gridView06.target.setColumnSort({sort : {seq : 0, orderBy : "asc"}});
            	
            }
        });
    	
        axboot.ajax({
	        type: "GET",
	        url: ["pjtInfoMaterial", "all"],
	        data: {projectId : fnObj.projectId},
	        callback: function (res) {
	        	caller.gridView07.setData(res);
	        }
	    });

        return false;
    },
    FILE_INIT: function(caller, cat, data){
    	 axboot.ajax({
 	        type: "GET",
 	        url: ["/api/v1/ax5uploader/list"],
 	        data: {id : fnObj.projectId,
 	        	contentType : "DOC_FILE",
 	        	targetType: "PROJECT_M"},
 	        callback: function (res) {

	        	var files = res;
	        	var html = "";
	        	
	        	for(var i = 0; i < files.length; i++){
	        		var file = files[i];
	        		
	        		if(i != 0){
	        			html += ",&nbsp;";
	        		}
	        		
	        		html += "<a href='" + file.download + "'>" + file.fileNm + "</a>";
	        	}
	        	$("[data-ax-path='files']").html(html);
 	        }
 	    });
    },
    PAGE_INIT : function (caller, act, data) {
    },
    PAGE_UPDATE : function(caller, act, data){
    	location.href="/jsp/project/project-save.jsp?menuId=22&projectId=" + fnObj.projectId;
    },
    OPEN_MVIEW_MODAL : function(caller, act, data){
    	
    	window.ksModal = new KSModal();
    	
    	var param = "oid=" + data.item.materialId;
    	
    	ksModal.open({
            modalType: "MATERIAL_VIEW",
            param: param,
            zIndex: 5010,
            header: {
                title: "자재 상세보기",
            },
            sendData: function(){
                return {};
            },
            callback: function (data) {
            	ACTIONS.dispatch(ACTIONS.PAGE_SPACEMATERIAL);
            },
        });
    	
    },
    OPEN_MODAL : function(caller, act, data){
    	
    	var item = data.item;
    	var column = data.column;
    	var code = column.key;
    	var title = item.name;
    	var infoId = "";
    	
    	if(item.id != null){
    		infoId = item.id;
    	}
    	if(code == "name" || code == "code" || code == "type"){
    		code = "";
    	}else if(code == "material"){
    		code = item.key;
    	}else{
    		title += "_" + column.label;
    	}
    	
    	var param = "infoId=" + infoId + "&code=" + code;
    	
    	window.ksModal = new KSModal();
    	
    	ksModal.open({
            modalType: "PROJECT_MATERIAL",
            param: param,
            zIndex: 5010,
            header:{title: title},
            sendData: function(){
                return {};
            },
            callback: function (data) {
            	ACTIONS.dispatch(ACTIONS.PAGE_SPACEMATERIAL);
            },
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
	 _this.gridView01.initView();
//	 _this.gridView02.initView();
	 _this.gridView03.initView();
	 _this.gridView04.initView();
	 _this.gridView05.initView();
	 _this.gridView06.initView();
	 _this.gridView07.initView();
     _this.pageButtonView.initView();
     _this.formView01.initView();
     
     ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);

};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "update": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_UPDATE);
            },
            "excel" : function(){
            	ACTIONS.dispatch(ACTIONS.PAGE_EXCEL_DOWN);
            }
        });
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

fnObj.pageResize = function () {
}

/**
 * formView01
 */
fnObj.formView01 = axboot.viewExtend(axboot.formView, {
    getDefaultData: function () {
        return $.extend({}, axboot.formView.defaultData, {
            "compCd": "S0001",
            roleList: [],
            authList: []
        });
    },
    initView: function () {
        this.target = $("#formView01");
        this.model = new ax5.ui.binder();
        this.model.setModel(this.getDefaultData(), this.target);
        this.modelFormatter = new axboot.modelFormatter(this.model); // 모델 포메터 시작
        this.initEvent();

        axboot.buttonClick(this, "data-form-view-01-btn", {
            "form-clear": function () {
                ACTIONS.dispatch(ACTIONS.FORM_CLEAR);
            }
        });

        ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {});
    },
    initEvent: function () {
        var _this = this;
    },
    getData: function () {
        var data = this.modelFormatter.getClearData(this.model.get()); // 모델의 값을 포멧팅 전 값으로 치환.

        data.authList = [];
        if (data.grpAuthCd) {
            data.grpAuthCd.forEach(function (n) {
                data.authList.push({
                    userCd: data.userCd,
                    grpAuthCd: n
                });
            });
        }

        data.roleList = ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_GET);

        return $.extend({}, data);
    },
    setData: function (data) {
    	
        if (typeof data === "undefined") data = this.getDefaultData();
        data = $.extend({}, data);

        this.model.setModel(data);
        this.modelFormatter.formatting(); // 입력된 값을 포메팅 된 값으로 변경
    },
    validate: function () {
        var rs = this.model.validate();
        if (rs.error) {
            alert(LANG("ax.script.form.validate", rs.error[0].jquery.attr("title")));
            rs.error[0].jquery.focus();
            return false;
        }
        return true;
    },
    clear: function () {
        this.model.setModel(this.getDefaultData());
        
     	
        data = this.getDefaultData();
        data = $.extend({}, data);
        
     //   if(data.grpAuthCd){
        data.grpAuthCd = [];
        data.grpAuthCd.push("S0002");
       // }
        this.model.setModel(data);
        this.modelFormatter.formatting();
           
        // data.grpAuthCd.push("S0002");
    }
});


/**
 * gridView
 */
fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: false,
            multipleSelect: false,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-01"]'),
            columns: [
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    align: "center",
                },
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MODAL, this);
                }
                
            }
        });
        
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: {typeCd : "BASIC_FINISH"},
            callback: function (res) {
            	if(res.list.length > 0){
            		var list = res.list[0].children;
                	
                	for(var i = 0; i < list.length; i++){
                		var row = list[i];
                		_this.target.addColumn({key: row.code, label: row.name, align : "right"});
                	}
            	}
            }
        });
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
    },
    align: function () {
        this.target.align();
    }
});

/**
 * gridView
 */
fnObj.gridView02 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: false,
            multipleSelect: false,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-02"]'),
            columns: [
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    align: "center",
                },
                {
                    key: "material",
                    label: '자재',
                    align: "right",
                },
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MODAL, this);
                }
            }
        });
        
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: {typeCd : "COMMON_FINISH"},
            callback: function (res) {
            	if(res.list.length > 0){
            		var list = res.list[0].children;
                	
                	for(var i = 0; i < list.length; i++){
                		var row = list[i];
                		_this.target.addRow({key: row.code, name: row.name});
                	}
            	}
            }
        });
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
    },
    setPjtInfo : function(_info){
    	
    	var list = this.target.getList();
    	
    	for(var i = 0; i < list.length; i++){
    		
    		var row = list[i];
    		var key = row.key;
    		
    		row.id = _info.id;
    		row.material = _info[key];
    		    		
    		try{
				this.target.updateRow(row, row.__index);
			}catch(e){}
    	}
    	
    },
    align: function () {
        this.target.align();
    }
});

/**
 * gridView
 */
fnObj.gridView03 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: false,
            multipleSelect: false,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-03"]'),
            columns: [
            	{
                    key: "type",
                    label: '타입',//COL("user.id"),
                    align: "center",
                },
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    align: "center",
                },
                {
                    key: "material",
                    label: '자재',//COL("user.id"),
                    align: "right",
                },
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MODAL, this);
                },
                mergeCells: ["type"]
            }
        });
        
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: {typeCd : "BASIC_HWSCETC"},
            callback: function (res) {
            	if(res.list.length > 0){
            		var list = res.list[0].children;
                	
            		for(var i = 0; i < list.length; i++){
                		var row = list[i];
                		
                		var children = row.children;
                		if(children != null && children.length > 0){
                			
                			for(var j = 0; j < children.length; j++){
                				var child = children[j];
                				
                				_this.target.addRow({type : row.name, key: child.code, name: child.name});
                			}
                		}else{
                			_this.target.addRow({key: row.code, name: row.name});
                		}
                	}
            	}
            }
        });
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
    },
    setPjtInfo : function(_info){
    	
    	var list = this.target.getList();
    	
    	for(var i = 0; i < list.length; i++){
    		
    		var row = list[i];
    		var key = row.key;
    		
    		row.id = _info.id;
    		row.material = _info[key];
    		    		
    		try{
				this.target.updateRow(row, row.__index);
			}catch(e){}
    	}
    	
    },	
    align: function () {
        this.target.align();
    }
});
/**
 * gridView
 */
fnObj.gridView04 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: false,
            multipleSelect: false,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-04"]'),
            columns: [
            	{
                    key: "type",
                    label: '타입',//COL("user.id"),
                    align: "center",
                },
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    align: "center",
                },
                {
                    key: "material",
                    label: '자재',//COL("user.id"),
                    align: "right",
                },
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MODAL, this);
                },
                mergeCells: ["type"]
            }
        });
        
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: {typeCd : "BASIC_FRMATERIAL"},
            callback: function (res) {
            	if(res.list.length > 0){
            		var list = res.list[0].children;
                	
                	for(var i = 0; i < list.length; i++){
                		var row = list[i];
                		
                		var children = row.children;
                		if(children != null && children.length > 0){
                			
                			for(var j = 0; j < children.length; j++){
                				var child = children[j];
                				
                				_this.target.addRow({type : row.name, key: child.code, name: child.name});
                			}
                		}else{
                			_this.target.addRow({key: row.code, name: row.name});
                		}
                	}
            	}
            }
        });
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
    },
    setPjtInfo : function(_info){
    	
    	var list = this.target.getList();
    	
    	for(var i = 0; i < list.length; i++){
    		
    		var row = list[i];
    		var key = row.key;
    		
    		row.id = _info.id;
    		row.material = _info[key];
    		    		
    		try{
				this.target.updateRow(row, row.__index);
			}catch(e){}
    	}
    	
    },
    align: function () {
        this.target.align();
    }
});

/**
 * gridView
 */
fnObj.gridView05 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: false,
            multipleSelect: false,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-05"]'),
            columns: [
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    align: "center",
                },
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MODAL, this);
                }
                
            }
        });
        
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: {typeCd : "BASIC_BATH"},
            callback: function (res) {
            	if(res.list.length > 0){
            		var list = res.list[0].children;
                	
                	for(var i = 0; i < list.length; i++){
                		var row = list[i];
                		_this.target.addColumn({key: row.code, label: row.name, align : "right"});
                	}
            	}
            }
        });
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
    },
    align: function () {
        this.target.align();
    }
});
/**
 * gridView
 */
fnObj.gridView06 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: false,
            multipleSelect: false,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-06"]'),
            columns: [
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    align: "center",
                },
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MODAL, this);
                }
                
            }
        });
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: {typeCd : "BASIC_FURNITURE"},
            callback: function (res) {
            	if(res.list.length > 0){
            		var list = res.list[0].children;
                	
                	for(var i = 0; i < list.length; i++){
                		var row = list[i];
                		_this.target.addColumn({key: row.code, label: row.name, align : "right"});
                	}
            	}
            }
        });
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
    },
    align: function () {
        this.target.align();
    }
});


/**
 * gridView
 */
fnObj.gridView07 = axboot.viewExtend(axboot.gridView, {
    initView: function () {
        var _this = this;

        this.target = axboot.gridBuilder({
            showLineNumber: true,
            showRowSelector: false,
            multipleSelect: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-07"]'),
            columns: [
            	{
            		key: "thumbnail",
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
                {key: "spaceNm", label: "적용공간",  align: "center"},
                {key: "materialType", label: "분류",  align: "left", width : 200, align : "center"},
                {key: "brand", label: "브랜드", align: "center"},
                {key: "series", label: "시리즈", align: "center"},
                {key: "productNo", label: "품번", align: "center"},
                {key: "origin", label: "원산지", align: "center"},
                {key: "spec", label: "규격", align: "center"},
                {key: "price", label: "소비자가", align: "right", formatter:"money"},
                {key: "dpprice", label: "(구매제안가)", align: "right", formatter:"money"},
                {key: "disCompNm", label: "유통사", align: "center"},
                {key: "disDeptNm", label: "담당자", align: "center"},
                {key: "disDeptTel", label: "담당자연락처", align: "center"},
                {key: "isExist", label: "자재유무", align: "center"},
            ],
            body: {
                onClick: function () {

                },
                onDBLClick: function () {
                	ACTIONS.dispatch(ACTIONS.OPEN_MVIEW_MODAL, this);
                }
                
            }
        });
    },
    setData: function (_data) {
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
    },
});