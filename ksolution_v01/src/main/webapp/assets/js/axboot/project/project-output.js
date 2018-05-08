var fnObj = {
	DIALOG : new ax5.ui.dialog({
        		title: "Message"
			})
		
};
var ACTIONS = axboot.actionExtend(fnObj, {
    
	FOLDER_LOAD: function (caller, act, data) {
		
		var target = $("#searchView0");
		var pjt_oid = target.find('[data-ax-path="' + "oid" + '"]').val();
		
		var searchData = {projectInfoId : pjt_oid};
       //console.log('caller.searchView.getData()', caller.searchView.getData());
		
        axboot.ajax({
        	type: "GET",
            url: ["pjtFolder"], 
            data: {projectInfoId : pjt_oid},
            callback: function (res) {
                caller.treeView01.setData(searchData, res.list, data);   
            }
        });
        
        return false;
    },
    
    SAVE_FOLDER : function(caller, act, data){
    	var _folders = [];
    	_folders.push(data);
    	
    	var sendData = {
    		list : _folders
    	}
    	
    	//console.log("sendData", sendData);
    	var result = "";
    	axboot.ajax({
        	type: "PUT",
        	async: false,
            url: ["pjtFolder"], 
            data: JSON.stringify(sendData),
            callback: function (res) {
            	result = res.returnValue;
            } 
        });
        return result;
    },
    
    REMOVE_FOLDER : function(caller, act, data){
    	var _folders = [];
    	_folders.push(data);
    	
    	var sendData = {
    		deletedList : _folders
    	}
    	//console.log("sendData", sendData);
    	var result = "";
    	axboot.ajax({
        	type: "PUT",
        	async: false,
            url: ["pjtFolder", "delete"], 
            data: JSON.stringify(sendData),
            callback: function (res) {
            	var status = res.status;
            	if(status == '0'){
            		result = res;
            	}
            	
            } 
        });
        return result;
    }, 
    
    MOVE_FOLDER : function (caller, act, data){
    	
    	var sendData = {
    		targetId : data.targetId,
    		nodeIds : data.nodeIds,
    		moveType : data.moveType
    	}
    	
    	axboot.ajax({
    		type: "PUT",
        	async: false,
            url: ["pjtFolder", "move"], 
            data: JSON.stringify(sendData),
            callback: function (res) {
            	result = res.returnValue;
            } 
        });
        return result;
    },  
    
    
    TREE_ROOTNODE_ADD: function (caller, act, data) {
        caller.treeView01.addRootNode();
    },
    
    TREEITEM_CLICK: function (caller, act, data) {
        
    	
        axboot.call({
            type: "GET",
            url: ["pjtFolder", "pathInfo"],
            data: {oid : data.oid},
            callback: function (res) {
            	console.log("res", res);
            	
            	var data = {
            		targetId : res.map.oid,
            		path : res.map.path
            	};
            	
            	caller.uploadView.setFolderInfo(data); 	
                
            }
        }).done(function(){
        	
        	ACTIONS.dispatch(ACTIONS.GET_uploaded);
        });
        
        
    },
    
    GET_uploaded : function(caller, act, data){
    	var sendData = caller.uploadView.getFolderInfo();
    	//console.log("sendData == " , sendData);
    	if(sendData.targetId == null || sendData.targetId == ''){
    		return;
    	}
    	
    	var nodeIds = caller.treeView01.getSelectNodeWithChild();
    	
    	if(nodeIds.length > 1){
    		sendData.targetId = '';
    	}
    	
    	sendData = $.extend({}, sendData, {
    		targetIds : nodeIds.toString()
		});
    	//console.log("caller.uploadView.GRID", caller.uploadView.GRID);
    	caller.uploadView.GRID.init();
    	 
    	
    	axboot.ajax({
    		type: "GET", 
            url: ["files", "list"], 
            data: sendData,
            callback: function (res) {
            	//console.log("res", res.list);
            	caller.uploadView.setData(res.list);
            } 
        });
    },
	
    REMOVE_FILES : function(caller, act, data){
    	
    	var files = caller.uploadView.getSelectedFiles();
    	if(files == null || files.length < 0){
    		return;
    	}
    	
    	/*var sendData = {
    		files : files
    	}*/
    	//console.log("sendData", JSON.stringify(sendData));
    	var result = "";
    	axboot.ajax({
        	type: "PUT",
        	url: ["files", "delete"], 
            data: JSON.stringify(files),
            callback: function (res) {
            	ACTIONS.dispatch(ACTIONS.GET_uploaded);
            } 
        });
        return result;
    },
    
    VERSION_LIST : function(caller, act, data){
    	
    	var param = "masterId=" + data;
    	axboot.modal.open({
            modalType: "DOC_VERSION_LIST",                                  
            param: param,
            header:{title:LANG("ks.Msg.10")}, 
            /*sendData:function(){
                return { oid : oid};
            },*/
            callback: function (data) {
            	
            	this.close();
                //{zipcodeData: data, zipcode: data.zonecode || data.postcode, roadAddress: fullRoadAddr, jibunAddress: data.jibunAddress}
                /*
                caller.formView01.setEtc1Value({
                   zipcode: data.zipcode, 
                   roadAddress: data.roadAddress, 
                   jibunAddress: data.jibunAddress
                });                                  
                */
                //console.log("data " , data);
              // this.close();
              // sendGanttData(data);
            }
        });
    },
    FILE_SEARCH : function(caller, act, data){
    	
    	var nodeIds = caller.treeView01.getSelectNodeWithChild();
    	
    	
    	var sendData = caller.uploadView.getFolderInfo();
    	//console.log("sendData == " , sendData);
    	
    	caller.uploadView.GRID.init();
    	var target = $("#searchView0");
    	var pjt_oid = target.find('[data-ax-path="' + "oid" + '"]').val();
    	var searchKeyWord = caller.searchView.getSearchKeyWord();
    	alert("searchKeyWord " + searchKeyWord);
    	sendData = $.extend({}, sendData, {
    			projectInfoId : pjt_oid,
    			searchKeyWord : searchKeyWord,
    			targetIds : nodeIds
    		});
    	
    	axboot.ajax({
    		type: "PUT", 
            url: ["files", "searchForInProject"], 
            data: JSON.stringify(sendData),
            callback: function (res) {
            	//console.log("res", res.list);
            	caller.uploadView.setData(res.list);
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

fnObj.pageStart = function(){
	 
	 var _this = this;
	 _this.treeView01.initView();
	 _this.treeResize();
	 _this.pageButtonView.initView();
	 _this.searchView.initView();
     ACTIONS.dispatch(ACTIONS.FOLDER_LOAD);
     _this.uploadView.initView();
     ACTIONS.dispatch(ACTIONS.GET_uploaded);
     
     
}

fnObj.pageResize = function(){
	var _this = this;
	_this.treeResize();
}

fnObj.pageButtonView = axboot.viewExtend({
	initView : function() {
		
		axboot.buttonClick(this, "data-page-btn", {
			"delete" : function() {
				
				 var deleteFiles = fnObj.uploadView.getSelectedFiles();
                 if (deleteFiles.length == 0) {
                     fnObj.DIALOG.alert("No list selected.");
                     return;
                 }
                 fnObj.DIALOG.confirm({
                     title: "Confirms",
                     msg: "Are you sure you want to delete it?"
                 }, function () {
                     if (this.key == "ok") {
                         ACTIONS.dispatch(ACTIONS.REMOVE_FILES);
                     }
                 });
                 
				
			}
		});
	}
});

fnObj.treeResize = function(){
	var winHeight =  $(window).height();
	var height = (winHeight - 150); // 헤더와 푸터 높이 빼줌  
	
	$('[data-z-tree="tree-view-01"]').css({
		"height": height 
	});
	
	$('#fileList').css({
		"height": height
	});
}

/**
 * treeView
 */
fnObj.treeView01 = axboot.viewExtend(axboot.treeView, {
	param: {},
    deletedList: [],
    newCount: 0,
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
            projectInfoId: _this.param.projectInfoId
        });

        if (treeNode) {
            _this.target.zTree.editName(treeNode[0]);
        }
        fnObj.treeView01.deselectNode();
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
            
                addHoverDom: function (treeId, treeNode) {
                    var sObj = $("#" + treeNode.tId + "_span");
                    if (treeNode.editNameFlag || $("#addBtn_" + treeNode.tId).length > 0) return;
                    var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
                        + "' title='add node' onfocus='this.blur();'></span>";
                    sObj.after(addStr);
                    var btn = $("#addBtn_" + treeNode.tId);
                    if (btn) {
                        btn.bind("click", function () {
                            _this.target.zTree.addNodes(
                                treeNode,
                                {
                                    id: "_isnew_" + (++_this.newCount),
                                    pId: treeNode.id,
                                    name: "New Item",
                                    __created__: true,
                                    menuGrpCd: _this.param.menuGrpCd
                                }
                            );
                            _this.target.zTree.selectNode(treeNode.children[treeNode.children.length - 1]);
                            _this.target.editName();
                            fnObj.treeView01.deselectNode();
                            return false;
                        });
                    }
                },
                removeHoverDom: function (treeId, treeNode) {
                    $("#addBtn_" + treeNode.tId).unbind().remove(); 
                }
            },
            edit: {
                enable: true,
                editNameSelectAll: true
            },
            callback: {
                beforeDrag: function (treeId, treeNodes) {
                	//console.log("treeNodes", treeNodes);
                    return true;
                },
                
                beforeDrop: function(treeId, treeNodes, targetNode, moveType) {
                    console.log("targetNode", targetNode);
                    /*console.log("moveType", moveType); 
                    */
                    var targetId = "";
                    
                    if(targetNode != null){
                    	targetId = targetNode.oid;
                    }
                    
                    var nodeIds = [];
                    var level;
                    treeNodes.forEach(function (node){
                    	nodeIds.push(node.oid);
                    	level = node.level;  	
                    });
                    
                  
                    
                    var data = {
                    	targetId : targetId,
                    	nodeIds : nodeIds,
                    	moveType :  moveType,
                    }
                    
                    ACTIONS.dispatch(ACTIONS.MOVE_FOLDER, data);
                },
                onClick: function (e, treeId, treeNode, isCancel) {
                    ACTIONS.dispatch(ACTIONS.TREEITEM_CLICK, treeNode);
                },
                onRename: function (e, treeId, treeNode, isCancel) {
                	
                	var nodes = _this.target.zTree.getSelectedNodes();
                    
                	if(nodes.length > 0){
                		var treeNode = nodes[0];
                		ACTIONS.dispatch(ACTIONS.TREEITEM_CLICK, treeNode);
                	}
                	
                	//alert("ok111 " + isCancel);
                    //treeNode.__modified__ = true;
                },
                
                beforeRename : function(treeId, treeNode, newName){
                	//console.log(treeId + " treeNode = " + treeNode + " newName " + newName); 
                	 var n = treeNode;
                	 var parent = n.getParentNode();
                	 var parentId = '';
                	 if(parent != null){
                		 parentId = parent.oid;
                	 }
                	 
                	 var item = {};
                	 
                	 if(n.oid == null || n.oid == ''){
                		 n.__created__ = true;
                		 n.sort = 0;
                		 if(n.getPreNode() != null){
                			//console.log("treeNode = " , treeNode.getPreNode().sort);
                         	 
                			 n.sort = n.getPreNode().sort + 1;
                		 }
                		 
                	 }else{
                		 n.__modified__ = true;
                	 }
                	 
                     item = {
                         __created__: n.__created__,
                         __modified__: n.__modified__,
                         oid: n.oid,
                         projectInfoId: _this.param.projectInfoId,
                         folderName: newName,
                         parentId: parentId,
                         sort: n.sort,
                         level: n.level 
                     };
                   
                	 
                	
                	var result = ACTIONS.dispatch(ACTIONS.SAVE_FOLDER, item);
                	
                	if(result){
                		treeNode.oid = result;
                	}else{
                		return false;
                	}
                	
                	return true;
                }, 
                
                beforeRemove : function(treeId, treeNode){
                	var n = treeNode;
               	 var parent = n.getParentNode();
               	 var parentId = '';
               	 if(parent != null){
               		 parentId = parent.oid;
               	 }
               	 
               	 var item = {};
               	// if (n.__created__ || n.__modified__) {
                    item = {
                        __created__: n.__created__,
                        __modified__: n.__modified__,
                        oid: n.oid,
                        projectInfoId: _this.param.projectInfoId,
                        folderName: n.name,
                        parentId: parentId,
                        sort: n.getIndex(),
                        level: n.level 
                    };
                    
                	var result = ACTIONS.dispatch(ACTIONS.REMOVE_FOLDER, item);
                	
                	if(result){
                		 
                	}else{
                		return false;
                	}
                	
                	return true;
                },
                
                onRemove: function (e, treeId, treeNode, isCancel) {
                    if (!treeNode.__created__) {
                        treeNode.__deleted__ = true;
                        _this.deletedList.push(treeNode);
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
    },
    getSelectNodeWithChild : function(){
    	var _this = this;
    	var nodes = _this.target.zTree.getSelectedNodes();
    	var datas = [];
         
    	if(nodes && nodes.length > 0){
    		var treeNode = nodes[0];
    		this.settingNodes(treeNode, datas);
        }
    	return datas;
        
    },
    
    settingNodes : function(treeNode, datas){
    	datas.push(treeNode.oid);
    	if (treeNode.children && treeNode.children.length > 0) {
        	 for(var i = 0; i < treeNode.children.length; i++){
        		 this.settingNodes(treeNode.children[i], datas);
        	 }
        }
    }
    
});

fnObj.uploadView = axboot.viewExtend(axboot.commonView, {
	UPLOAD : {},
	GRID : {},
	target : $('[data-ax5uploader="upload1"]'),
	
	initView: function () {
		var _this = this;
		
		
		_this.UPLOAD = new ax5.ui.uploader({
            //debug: true,
            target: $('[data-ax5uploader="upload1"]'),
           
            form: {
                action: CONTEXT_PATH + "/api/v1/ax5uploader/uploadWithSave",
                fileName : "file"
            },
            multiple: true,
            dropZone: {
                target: $(document.body),
                onclick: function () {
                    // 사용을 원하는 경우 구현
                    return;
                    if (!this.self.selectFile()) {
                        console.log("파일 선택 지원 안됨");
                    }
                },
                ondragover: function () {
                	DRAGOVER = $("#dragover");
                    //this.self.$dropZone.addClass("dragover");
                    DRAGOVER.show();
                    DRAGOVER.on("dragleave", function () {
                         DRAGOVER.hide();
                    });
                },
                ondragout: function () {
                    //this.self.$dropZone.removeClass("dragover");
                },
                ondrop: function () {
                	DRAGOVER = $("#dragover");
                    DRAGOVER.hide();
                }
            },
            validateSelectedFiles: function () {
                // alert("kkk");
            	// console.log(this);
                // 10개 이상 업로드 되지 않도록 제한.
            	
            	var data = fnObj.uploadView.getFolderInfo();
            	
            	if(data.targetId == null || data.targetId == ''){
            		fnObj.DIALOG.alert(LANG("ax.script.prjoutput.uplod.notselectFolder")); 
            		return false;
            	}
            	
                /*if (this.uploadedFiles.length + this.selectedFiles.length > 10) {
                    alert("You can not upload more than 10 files.");
                    return false;
                }*/
                return true;
            },
            onuploaderror: function () {
               // console.log("error == " , this.error);
                fnObj.DIALOG.alert(this.error.message);
            },
            onuploadComplete: function () {
            	ACTIONS.dispatch(ACTIONS.GET_uploaded);
            }
        });
		
		_this.GRID = new ax5.ui.grid({
            target: $('[data-ax5grid="first-grid"]'),
            columns: [
                {key: "fileNm", label: "fileName", width: 200},
                {key: "versionIndex", label: "V",  align: "center",  width: 50},
                
                {key: "fileSize", label: "fileSize", align: "right", formatter: function () {
                    return ax5.util.number(this.value, {byte: true});
                }},
                {key: "extension", label: "ext", align: "center", width: 60},
                {key: "generatedcreatedAt", label: "createdAt", align: "center", width: 140, formatter: function () {
                    return ax5.util.date(this.value, {"return": "yyyy/MM/dd hh:mm:ss"});
                }}, 
                {key: "creatorNm", label: "creator", align: "center", width: 100},
                {key: "download", label: "down", width: 60, align: "center", formatter: function () {
                    return '<i class="fa fa-download" aria-hidden="true"></i>'
                }}
            ],
            body: {
                onClick: function () {
                    if(this.column.key == "download" && this.item.download){
                    	//alert(CONTEXT_PATH + this.item.download);
                        location.href = CONTEXT_PATH + this.item.download;
                    }else if(this.column.key == "versionIndex"){
                    	
                    	ACTIONS.dispatch(ACTIONS.VERSION_LIST, this.item.masterId);
                    } 
                }
            }
        });
		
		
	},
	setFolderInfo: function(data){
		$('[data-ax-path="targetId"]').val(data.targetId);
		//alert(data.path);
	},
	
	getFolderInfo : function(){
		var targetId = $('[data-ax-path="targetId"]').val();
		var targetType = $('[data-ax-path="targetType"]').val();
		
		var data = {
			targetId : targetId,
			targetType : targetType
		}
		
		return data;
	},
	
	setData : function(data){
		var _this = this;
		_this.UPLOAD.setUploadedFiles(data);
		//console.log("_this.UPLOAD.uploadedFiles", _this.UPLOAD.uploadedFiles);
		_this.GRID.setData(_this.UPLOAD.uploadedFiles);
	},
	
	getSelectedFiles : function(){
		var _this = this;
		var files = _this.GRID.getList("selected");
		return files;
	}
	
	

});

fnObj.searchView = axboot.viewExtend(axboot.searchView, {
	initView : function() {
		this.target = $(document["searchView0"]);
		 $('[data-searchview-btn]').click(function () {
	            var _act = this.getAttribute("data-searchview-btn");
	            //alert(_act);
	            ACTIONS.dispatch(ACTIONS.FILE_SEARCH);
		 });
		 
		 $("#searchKeyWrod").keypress(function (e) {
		        if (e.which == 13){
		        	ACTIONS.dispatch(ACTIONS.FILE_SEARCH); // 실행할 이벤트
		        }
		 });
	},
	
	getSearchKeyWord : function(){
		
		var keyWord = this.target.find('[data-ax-path="searchKeyWrod"]').val();
		return keyWord;
	}

});

