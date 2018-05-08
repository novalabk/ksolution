var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
    	
    	if(fnObj.projectId != ""){
        	
        	axboot.ajax({
                type: "GET",
                url: ["project"],
                data: {projectId : fnObj.projectId},
                callback: function (res) {
                    caller.formView01.setData(res);
                    
//                    var classificationLv1 = $('[data-ax-path="classificationLv1"]').val();
//                    $('[data-parent="' + classificationLv1 + '"]').show();
                }
            });
        	
        	axboot.ajax({
                type: "GET",
                url: ["projectInfo"],
                data: {projectId : fnObj.projectId, typeCd : "SPACE"},
                callback: function (res) {
            		caller.gridView01.setData(res);
                	caller.gridView01.target.setColumnSort({sort : {seq : 0, orderBy : "asc"}});
                }
            });
        }
    	
    	if(!data){
    		data = {typeCd : "SPACE"};
    	}
    	
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: data,
            callback: function (res) {
            	//console.log("res", res);	
                caller.treeView01.setData(data, res.list, data);
            }
        });
        
        return false;
    },
    PAGE_SAVE: function (caller, act, data) {
    	
    	var param = new Object();
    	var basicCodeList = caller.gridView01.getData();
//    	basicCodeList = basicCodeList.concat(caller.gridView02.getData());
//    	basicCodeList = basicCodeList.concat(caller.gridView03.getData());
//    	basicCodeList = basicCodeList.concat(caller.gridView04.getData());
    	
    	for(var i = 0; i < basicCodeList.length; i++){
    		var row = basicCodeList[i];
    		//row.project = undefined;
    		row.__created__ = true;
    		row.__modified__ = true;
    		row.__deleted__ = true;
    		basicCodeList[i] = row;
    	}
    	var files = ax5.util.deepCopy(UPLOAD.uploadedFiles);
    	
    	param.FORM_DATA = caller.formView01.getData();
    	param.FORM_DATA.__modified__ = true;
    	param.BASIC_CODE = basicCodeList;
    	param.FILES = files;
    	if (caller.formView01.validate()) {
            axboot.ajax({
                type: "PUT",
                url: ["project"],
                data: JSON.stringify(param),
                callback: function (res) {
                	axToast.push("저장되었습니다.");
                	location.href="/jsp/project/project-view.jsp?projectId=" + res.message;
                }
            });
        }
    },
    PAGE_INIT : function(){
    	
    	axboot.ajax({
            type: "GET",
            url: ["project"],
            data: {projectId : fnObj.projectId},
            callback: function (res) {
                caller.formView01.setData(res);
            }
        });
    	
//    	axboot.ajax({
//            type: "GET",
//            url: ["projectInfo"],
//            data: {projectId : fnObj.projectId, typeCd : "SPACE"},
//            callback: function (res) {
//            	caller.gridView01.setData(res);
//            }
//        });
//    	
//    	axboot.ajax({
//            type: "GET",
//            url: ["projectInfo"],
//            data: {projectId : fnObj.projectId, typeCd : "BASIC_FINISH"},
//            callback: function (res) {
//            	caller.gridView02.setData(res);
//            }
//        });
//    	axboot.ajax({
//            type: "GET",
//            url: ["projectInfo"],
//            data: {projectId : fnObj.projectId, typeCd : "BATHROOM"},
//            callback: function (res) {
//            	caller.gridView03.setData(res);
//            }
//        });
//    	
//    	axboot.ajax({
//            type: "GET",
//            url: ["projectInfo"],
//            data: {projectId : fnObj.projectId, typeCd : "FURNITURE"},
//            callback: function (res) {
//            	caller.gridView04.setData(res);
//            }
//        });
    },
    TREEITEM_CLICK: function (caller, act, data) {
    	var treeNode = data;
    	
    	if(treeNode.children.length == 0){
    		var gridView = null;
        	
        	switch(fnObj.basicType){
      		   case "SPACE" : 
      			   gridView = fnObj.gridView01.target;
      			   break;
      		   case "BASIC_FINISH" : 
      			   gridView = fnObj.gridView02.target;
      			   break;
      		   case "BATHROOM" : 
      			   gridView = fnObj.gridView03.target;
      			   break;
      		   case "FURNITURE" : 
      			   gridView = fnObj.gridView04.target;
      			   break;
      		   default : 
      			 var gridView = fnObj.gridView01.target;
      			   break;
    	    }
        	
        	gridView.addRow($.extend({}, {name : treeNode.codeNm, type : treeNode.codeNm, basicCdId : treeNode.codeId, sort : treeNode.sort}));
        	gridView.setColumnSort({sort : {seq : 0, orderBy : "asc"}});
    	}
    	
    },
    TREEITEM_DESELECTE: function (caller, act, data) {
        caller.formView01.clear();
    },
    TREE_ROOTNODE_ADD: function (caller, act, data) {
        caller.treeView01.addRootNode();
    },
    SELECT_PROG: function (caller, act, data) {
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

//    axboot
//        .call({
//            type: "GET", url: "/api/v1/programs", data: "",
//            callback: function (res) {
//                var programList = [];
//                res.list.forEach(function (n) {
//                    programList.push({
//                        value: n.progCd, text: n.progNm + "(" + n.progCd + ")",
//                        progCd: n.progCd, progNm: n.progNm,
//                        data: n
//                    });
//                });
//                this.programList = programList;
//            }
//        })
//        .call({
//            type: "GET", url: "/api/v1/commonCodes", data: {groupCd: "AUTH_GROUP", useYn: "Y"},
//            callback: function (res) {
//                var authGroup = [];
//                res.list.forEach(function (n) {
//                    authGroup.push({
//                        value: n.code, text: n.name + "(" + n.code + ")",
//                        grpAuthCd: n.code, grpAuthNm: n.name,
//                        data: n
//                    });
//                });
//                this.authGroup = authGroup;
//            }
//        })
//        .done(function () {
//            CODE = this; // this는 call을 통해 수집된 데이터들.
//
//            _this.pageButtonView.initView();
//            _this.searchView.initView();
//            _this.treeView01.initView();
//            _this.formView01.initView();
//            _this.gridView01.initView();
//
//            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
//        });
    	 _this.gridView01.initView();
//    	 _this.gridView02.initView();
//    	 _this.gridView03.initView();
//    	 _this.gridView04.initView();
         _this.treeView01.initView();
         _this.pageButtonView.initView();
         _this.formView01.initView();
         
    	 ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "save": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
            }
        });
    }
});

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
        this.model.onChange("password_change", function () {
            if (this.value == "Y") {
                _this.target.find('[data-ax-path="userPs"]').removeAttr("readonly");
                _this.target.find('[data-ax-path="userPs_chk"]').removeAttr("readonly");
            } else {
                _this.target.find('[data-ax-path="userPs"]').attr("readonly", "readonly");
                _this.target.find('[data-ax-path="userPs_chk"]').attr("readonly", "readonly");
            }
        });
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
 * treeView
 */
fnObj.treeView01 = axboot.viewExtend(axboot.treeView, {
    param: {},
    deletedList: [],
    newCount: 0,
    height : 500,
    addRootNode: function () {
        var _this = this;
        var nodes = _this.target.zTree.getSelectedNodes();
        var treeNode = nodes[0];

        // root
        treeNode = _this.target.zTree.addNodes(null, {
            id: "_isnew_" + (++_this.newCount),
            pId: 0,
            name: "New Item",
            __created__: true,
            typeCd: _this.param.typeCd
        });

        if (treeNode) {
        	
        	//alert("save...");
        	ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
        	
            //_this.target.zTree.editName(treeNode[0]);
        }
        //fnObj.treeView01.deselectNode();
    },
    initView: function () {
        var _this = this;

        $('[data-tree-view-01-btn]').click(function () {
            var _act = this.getAttribute("data-tree-view-01-btn");
            switch (_act) {
                case "add":
                    ACTIONS.dispatch(ACTIONS.TREE_ROOTNODE_ADD);
                    break;
                case "delete":
                    //ACTIONS.dispatch(ACTIONS.ITEM_DEL);
                    break;
            }
        });

        this.target = axboot.treeBuilder($('[data-z-tree="tree-view-01"]'), {
            view: {
                dblClickExpand: false,
                fontCss: function(treeId, treeNode){
                	
                	var code = treeNode.code;
                	
                	if(code == "Bathroom" || code == "FUNITURE"){
                		return { color : "#2F9D27"};
                	}
                	
//                	treeNode.level == 0 ? {color:"red"} : 
                	
                	
                	return {};
                },
//                addHoverDom: function (treeId, treeNode) {
//                    var sObj = $("#" + treeNode.tId + "_span");
//                    if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) return;
//                    var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
//                        + "' title='add node' onfocus='this.blur();'></span>";
//                    console.log('treeNode ===== ', treeNode);
//                    if(treeNode.children.length == 0){
//                    	sObj.after(addStr);
//                    }
//                    
//                    var btn = $("#addBtn_" + treeNode.tId);
//                    if (btn) {
//                        btn.bind("click", function () {
//                        	
////                        	console.log(treeNode);
//                        	var gridView = null;
//                        	switch(fnObj.basicType){
//	         	     		   case "SPACE" : 
//	         	     			   gridView = fnObj.gridView01.target;
//	         	     			   break;
//	         	     		   case "BASIC_FINISH" : 
//	         	     			   gridView = fnObj.gridView02.target;
//	         	     			   break;
//	         	     		   case "BATHROOM" : 
//	         	     			   gridView = fnObj.gridView03.target;
//	         	     			   break;
//	         	     		   case "FURNITURE" : 
//	         	     			   gridView = fnObj.gridView04.target;
//	         	     			   break;
//	         	     		   default : 
//	         	     			 var gridView = fnObj.gridView01.target;
//	         	     			   break;
//	         	 		    }
////                        	console.log(_this.target);
////                        	var pNode = treeNode.getParentNode();
////                        	var bsSort = pNode.sort + "." + treeNode.sort;
//                        	
//                        	console.log(treeNode);
//                        	
//                        	gridView.addRow($.extend({}, {name : treeNode.codeNm, type : treeNode.codeNm, basicCdId : treeNode.codeId, sort : treeNode.sort}));
//                        	
//                        	//ax5grid.setColumnSort({a:{seq:0, orderBy:"desc"}, b:{seq:1, orderBy:"asc"}});
//                        	gridView.setColumnSort({sort : {seq : 0, orderBy : "asc"}});
//                        	
//
////                            _this.target.zTree.selectNode(treeNode.children[treeNode.children.length - 1]);
////                            _this.target.editName();
////                            fnObj.treeView01.deselectNode();
//                            return false;
//                        });
//                    }
//                },
//                removeHoverDom: function (treeId, treeNode) {
//                	
//                	$("#addBtn_" + treeNode.tId).unbind().remove();
//                	
//                    //ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
//                }
            },
            edit: {
                enable: false,
                editNameSelectAll: true
            },
            callback: {
                beforeDrag: function () {
                    //return false;
                },
                onClick: function (e, treeId, treeNode, isCancel) {
                    ACTIONS.dispatch(ACTIONS.TREEITEM_CLICK, treeNode);
                },
                onRename: function (e, treeId, treeNode, isCancel) {
                    treeNode.__modified__ = true;
                },
                onRemove: function (e, treeId, treeNode, isCancel) {
                    if (!treeNode.__created__) {
                        treeNode.__deleted__ = true;
                        _this.deletedList.push(treeNode);
                        
                        if (confirm("정말로 삭제 하시겠습니까?")) {
                    		$("#addBtn_" + treeNode.tId).unbind().remove();
                            
                    		ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
                        }
                    }
                    fnObj.treeView01.deselectNode();
                }
            }
        }, []);
    },
    setData: function (_searchData, _tree, _data) {
        this.param = $.extend({}, _searchData);
        this.target.setData(_tree);

        if (_data && typeof _data.codeId !== "undefined") {
            // selectNode
            (function (_tree, _keyName, _key) {
                var nodes = _tree.getNodes();
                
                var findNode = function (_arr) {
                    var i = _arr.length;
                    while (i--) {
                        if (_arr[i][_keyName] == _key) {
                            _tree.selectNode(_arr[i]);
                        }
                        if (_arr[i].children && _arr[i].children.length > 0) {
                            findNode(_arr[i].children);
                        }
                    }
                };
                findNode(nodes);
            })(this.target.zTree, "codeId", _data.codeId);
        }
    },
    getData: function () {
        var _this = this;
        var tree = this.target.getData();

        var convertList = function (_tree) {
            var _newTree = [];
            _tree.forEach(function (n, nidx) {
            	
                var item = {};
                if (n.__created__ || n.__modified__) {
                	//alert("kkkk111 " + n.name);
                	id = n.id;
                	if(n.__created__ ){
                		id = 0;
                	}
                    item = {
                        __created__: n.__created__,
                        __modified__: n.__modified__,
                        codeId: id,
                        typeCd: _this.param.typeCd,
                        codeNm: n.name,
                        parentId: n.pId,
                        sort: nidx,
                        level: n.level,
                        multiLanguageJson: n.multiLanguageJson
                    };
                } else {
                	
                	//alert("kkkk " + n.name);
                    item = {
                    	codeId: n.id,
                        typeCd: n.typeCd,
                        codeNm: n.name,
                        parentId: n.parentId,
                        sort: nidx,
                        code: n.code,
                        level: n.level,
                        multiLanguageJson: n.multiLanguageJson
                    };
                }
                if (n.children && n.children.length) {
                    item.children = convertList(n.children);
                }
                _newTree.push(item);
            });
            return _newTree;
        };
        var newTree = convertList(tree);
        return newTree;
    },
    getDeletedList: function () {
        return this.deletedList;
    },
    clearDeletedList: function () {
        this.deletedList = [];
        return true;
    },
    updateNode: function (data) {
        var treeNodes = this.target.getSelectedNodes();
        if (treeNodes[0]) {
            treeNodes[0].progCd = data.progCd;
        }
    },
    deselectNode: function () {
        ACTIONS.dispatch(ACTIONS.TREEITEM_DESELECTE);
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
            showRowSelector: true,
            multipleSelect: true,
            sortable: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-01"]'),
            columns: [
                {
                    key: "name",
                    label: '이름',//COL("user.id"),
                    editor: "text",
                    align: "center",
                },
                {
                    key: "type",
                    label: '타입',//COL("user.name"),
                    align: "center",
//                    editor: "text",
                },
//                {
//                    key: "sort",
//                    label: '소트',//COL("user.id"),
//                    align: "center",
//                },
            ],
            body: {
                onClick: function () {
//                    this.self.select(this.dindex);
                    //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.list[this.dindex]);
                },
                onDBLClick: function () {
                    //alert("DBLClick grid : row " + this.dindex);
                }
            }
        });
        axboot.buttonClick(this, "data-grid-view-01-btn", {
            "delete": function () {
	            switch(fnObj.basicType){
	     		   case "SPACE" : 
	     			  fnObj.gridView01.delRow("selected");
	     			   break;
	     		   case "BASIC_FINISH" : 
	     			  fnObj.gridView02.delRow("selected");
	     			   break; 
	     		   case "BATHROOM" : 
	     			  fnObj.gridView03.delRow("selected");
	     			   break;
	     		   case "FURNITURE" : 
	     			  fnObj.gridView04.delRow("selected");
	     			   break;
	     		   default : 
	     			   break;
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

fnObj.gridView02 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: true,
            multipleSelect: true,
            frozenColumnIndex: 0,
            sortable: true,
            target: $('[data-ax5grid="grid-view-02"]'),
            columns: [
            	{
                    key: "name",
                    label: '이름',//COL("user.id"),
                    editor: "text",
                    align: "center",
                },
                {
                    key: "type",
                    label: '타입',//COL("user.name"),
                    align: "center",
//                    editor: "text",
                },
                {
                    key: "sort",
                    label: '소트',//COL("user.id"),
                    align: "center",
                },
            ],
            body: {
                onClick: function () {
//                    this.self.select(this.dindex);
                    //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.list[this.dindex]);
                },
                onDBLClick: function () {
                    //alert("DBLClick grid : row " + this.dindex);
                }
            }
        });
        axboot.buttonClick(this, "data-grid-view-02-btn", {
            "delete": function () {
            	fnObj.gridView02.delRow("selected");
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

fnObj.gridView03 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: true,
            multipleSelect: true,
            frozenColumnIndex: 0,
            sortable: true,
            target: $('[data-ax5grid="grid-view-03"]'),
            columns: [
            	{
                    key: "name",
                    label: '이름',//COL("user.id"),
                    editor: "text",
                    align: "center",
                },
                {
                    key: "type",
                    label: '타입',//COL("user.name"),
                    align: "center",
//                    editor: "text",
                },
                {
                    key: "sort",
                    label: '소트',//COL("user.id"),
                    align: "center",
                },
            ],
            body: {
                onClick: function () {
//                    this.self.select(this.dindex);
                    //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.list[this.dindex]);
                },
                onDBLClick: function () {
                    //alert("DBLClick grid : row " + this.dindex);
                }
            }
        });
        axboot.buttonClick(this, "data-grid-view-03-btn", {
            "delete": function () {
            	fnObj.gridView03.delRow("selected");
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

fnObj.gridView04 = axboot.viewExtend(axboot.gridView, {
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            showLineNumber : true,
            showRowSelector: true,
            multipleSelect: true,
            frozenColumnIndex: 0,
            sortable: true,
            target: $('[data-ax5grid="grid-view-04"]'),
            columns: [
            	{
                    key: "name",
                    label: '이름',//COL("user.id"),
                    editor: "text",
                    align: "center",
                },
                {
                    key: "type",
                    label: '타입',//COL("user.name"),
                    align: "center",
//                    editor: "text",
                },
                {
                    key: "sort",
                    label: '소트',//COL("user.id"),
                    align: "center",
                },
                {
                    key: "basicCdId",
                    label: 'basicCdId',//COL("user.id"),
                    align: "center",
                },
            ],
            body: {
                onClick: function () {
//                    this.self.select(this.dindex);
                    //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.list[this.dindex]);
                },
                onDBLClick: function () {
                    //alert("DBLClick grid : row " + this.dindex);
                }
            }
        });
        axboot.buttonClick(this, "data-grid-view-04-btn", {
            "delete": function () {
            	fnObj.gridView04.delRow("selected");
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
