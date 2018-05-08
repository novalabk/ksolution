var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
	PAGE_SEARCH : function(caller, act, data) {
		var searchData = caller.searchView.getData();
		axboot.ajax({
			type : "GET",
			url : [ "basicCode" ],
			data : caller.searchView.getData(),
			callback : function(res) {
				// console.log("res", res);
				caller.treeView01.setData(searchData, res.list, data);
			}
		});

		return false;
	},
	PAGE_SAVE : function(caller, act, data) {
		var formData = caller.formView01.getData();

		var obj = {
			list : caller.treeView01.getData(),
			deletedList : caller.treeView01.getDeletedList()
		};

		// console.log("list", obj.list);

		axboot.call({
			type : "PUT",
			url : [ "basicCode" ],
			data : JSON.stringify(obj),
			callback : function(res) {
				caller.treeView01.clearDeletedList();
				axToast.push(LANG("ax.script.menu.category.saved"));
			}
		}).call({
			type : "PUT",
			url : [ "basicCode", formData.codeId ],
			data : JSON.stringify(formData),
			callback : function(res) {

			}
		}).done(function() {
			if (data && data.callback) {
				data.callback();
			} else {
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, {
					codeId : caller.formView01.getData().codeId
				});
			}
		});
	},
	TREEITEM_CLICK : function(caller, act, data) {

		if (typeof data.codeId === "undefined") {
			caller.formView01.clear();
			if (confirm(LANG("ax.script.menu.save.confirm"))) {
				ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
			}
			return;
		}

		axboot.ajax({
			type : "GET",
			url : [ "basicCode", data.codeId ],
			data : {},
			callback : function(res) {
				caller.formView01.setData(res);
			}
		});
	},
	TREEITEM_DESELECTE : function(caller, act, data) {
		caller.formView01.clear();
	},
	TREE_ROOTNODE_ADD : function(caller, act, data) {
		caller.treeView01.addRootNode();
	},
	SELECT_PROG : function(caller, act, data) {
		caller.treeView01.updateNode(data);

		var _data = caller.formView01.getData();
		var obj = {
			list : caller.treeView01.getData(),
			deletedList : caller.treeView01.getDeletedList()
		};
		var searchData = caller.searchView.getData();

		axboot.call({
			type : "PUT",
			url : [ "basicCode" ],
			data : JSON.stringify(obj),
			callback : function(res) {
				caller.treeView01.clearDeletedList();
				axToast.push(LANG("ax.script.menu.category.saved"));
			}
		}).call({
			type : "GET",
			url : [ "basicCode" ],
			data : searchData,
			callback : function(res) {
				caller.treeView01.setData(searchData, res.list);
			}
		}).done(function() {
			// console.log(_data);
			// ACTIONS.dispatch(ACTIONS.SEARCH_AUTH, {menuId: _data.menuId});
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

	// axboot
	// .call({
	// type: "GET", url: "/api/v1/programs", data: "",
	// callback: function (res) {
	// var programList = [];
	// res.list.forEach(function (n) {
	// programList.push({
	// value: n.progCd, text: n.progNm + "(" + n.progCd + ")",
	// progCd: n.progCd, progNm: n.progNm,
	// data: n
	// });
	// });
	// this.programList = programList;
	// }
	// })
	// .call({
	// type: "GET", url: "/api/v1/commonCodes", data: {groupCd: "AUTH_GROUP",
	// useYn: "Y"},
	// callback: function (res) {
	// var authGroup = [];
	// res.list.forEach(function (n) {
	// authGroup.push({
	// value: n.code, text: n.name + "(" + n.code + ")",
	// grpAuthCd: n.code, grpAuthNm: n.name,
	// data: n
	// });
	// });
	// this.authGroup = authGroup;
	// }
	// })
	// .done(function () {
	// CODE = this; // this는 call을 통해 수집된 데이터들.
	//
	// _this.pageButtonView.initView();
	// _this.searchView.initView();
	// _this.treeView01.initView();
	// _this.formView01.initView();
	// _this.gridView01.initView();
	//
	// ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	// });

	_this.pageButtonView.initView();
	_this.searchView.initView();
	_this.treeView01.initView();
	_this.formView01.initView();
	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
};

fnObj.pageResize = function() {

};

fnObj.pageButtonView = axboot.viewExtend({
	initView : function() {
		axboot.buttonClick(this, "data-page-btn", {
			"search" : function() {
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
			},
			"save" : function() {
				ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
			},
			"excel" : function() {

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
		this.typeCd = $("#typeCd");
		// console.log("this.typeCd", this.typeCd);
		// console.log(" $('[data-ax5select]')", $('[data-ax5select]'));

		$('#typeCd').on({

			change : function() {

				// ACTIONS.dispatch(ACTIONS.SELECT_PROG, "");
				// ACTIONS.dispatch(ACTIONS.MENU_AUTH_CLEAR);
				ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
				// alert("onchange...");
			}
		});
	},
	getData : function() {
		return {
			pageNumber : this.pageNumber,
			pageSize : this.pageSize,
			typeCd : this.typeCd.val()
		}
	}

});

/**
 * treeView
 */
fnObj.treeView01 = axboot
		.viewExtend(
				axboot.treeView,
				{
					param : {},
					deletedList : [],
					newCount : 0,
					addRootNode : function() {
						var _this = this;
						var nodes = _this.target.zTree.getSelectedNodes();
						var treeNode = nodes[0];

						// root
						treeNode = _this.target.zTree.addNodes(null, {
							id : "_isnew_" + (++_this.newCount),
							pId : 0,
							name : "New Item",
							__created__ : true,
							typeCd : _this.param.typeCd
						});

						if (treeNode) {

							// alert("save...");
							ACTIONS.dispatch(ACTIONS.PAGE_SAVE);

							// _this.target.zTree.editName(treeNode[0]);
						}
						// fnObj.treeView01.deselectNode();
					},
					initView : function() {
						var _this = this;

						$('[data-tree-view-01-btn]')
								.click(
										function() {
											var _act = this
													.getAttribute("data-tree-view-01-btn");
											switch (_act) {
											case "add":
												// ACTIONS.dispatch(ACTIONS.TREE_ROOTNODE_ADD);
												break;
											case "delete":
												// ACTIONS.dispatch(ACTIONS.ITEM_DEL);
												break;
											}
										});

						this.target = axboot
								.treeBuilder(
										$('[data-z-tree="tree-view-01"]'),
										{
											view : {
												dblClickExpand : false,
												addHoverDom : function(treeId,
														treeNode) {
													var sObj = $("#"
															+ treeNode.tId
															+ "_span");
													// console.log("treeNode",
													// treeNode);

													if (treeNode.editNameFlag
															|| $("#addBtn_"
																	+ treeNode.tId).length > 0)
														return;
													var addStr = "<span class='button add' id='addBtn_"
															+ treeNode.tId
															+ "' title='add node' onfocus='this.blur();'></span>";
													sObj.after(addStr);
													var btn = $("#addBtn_"
															+ treeNode.tId);
													if (btn) {
														btn
																.bind(
																		"click",
																		function() {
																			_this.target.zTree
																					.addNodes(
																							treeNode,
																							{
																								id : "_isnew_"
																										+ (++_this.newCount),
																								pId : treeNode.id,
																								name : "New Item",
																								__created__ : true,
																								typeCd : _this.param.typeCd
																							});

																			ACTIONS
																					.dispatch(ACTIONS.PAGE_SAVE);

																			// _this.target.zTree.selectNode(treeNode.children[treeNode.children.length
																			// -
																			// 1]);
																			// _this.target.editName();
																			// fnObj.treeView01.deselectNode();
																			return false;
																		});
													}
												},
												removeHoverDom : function(
														treeId, treeNode) {

													$("#addBtn_" + treeNode.tId)
															.unbind().remove();

													// ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
												}
											},
											edit : {
												enable : true,
												editNameSelectAll : true
											},
											callback : {
												beforeDrag : function() {
													// return false;
												},
												onClick : function(e, treeId,
														treeNode, isCancel) {
													ACTIONS
															.dispatch(
																	ACTIONS.TREEITEM_CLICK,
																	treeNode);
												},
												onRename : function(e, treeId,
														treeNode, isCancel) {
													treeNode.__modified__ = true;
												},
												beforeRemove : function(treeId,
														treeNode) {

													if (treeNode.level == 0) {
														alert("삭제 할 수 없습니다.");
														return false;
													}
													return confirm("정말로 삭제 하시겠습니까?");
												},

												onRemove : function(e, treeId,
														treeNode, isCancel) {
													if (treeNode.level == 0) {
														return false;
													}

													if (!treeNode.__created__) {
														treeNode.__deleted__ = true;
														_this.deletedList
																.push(treeNode);
														$(
																"#addBtn_"
																		+ treeNode.tId)
																.unbind()
																.remove();
														ACTIONS
																.dispatch(ACTIONS.PAGE_SAVE);

													}
													fnObj.treeView01
															.deselectNode();
												}
											}
										}, []);
					},
					setData : function(_searchData, _tree, _data) {
						this.param = $.extend({}, _searchData);
						console.log("_tree", _tree);
						this.target.setData(_tree);

						if (_data && typeof _data.codeId !== "undefined") {
							// selectNode
							(function(_tree, _keyName, _key) {
								var nodes = _tree.getNodes();
								var findNode = function(_arr) {
									var i = _arr.length;
									while (i--) {
										if (_arr[i][_keyName] == _key) {
											_tree.selectNode(_arr[i]);
										}
										if (_arr[i].children
												&& _arr[i].children.length > 0) {
											findNode(_arr[i].children);
										}
									}
								};
								findNode(nodes);
							})(this.target.zTree, "codeId", _data.codeId);
						}
					},
					getData : function() {
						var _this = this;
						var tree = this.target.getData();
						var sortIdx = 0;
						var convertList = function(_tree) {
							var _newTree = [];

							_tree.forEach(function(n, nidx) {
								// console.log("name", n.name);
								sortIdx++;
								var item = {};
								if (n.__created__ || n.__modified__) {
									// alert("kkkk111 " + n.name);
									id = n.id;
									if (n.__created__) {
										id = 0;
									}
									item = {
										__created__ : n.__created__,
										__modified__ : n.__modified__,
										codeId : id,
										typeCd : _this.param.typeCd,
										codeNm : n.name,
										parentId : n.pId,
										sort : sortIdx,
										level : n.level,
										multiLanguageJson : n.multiLanguageJson
									};
								} else {

									// alert("kkkk " + n.name);
									item = {
										codeId : n.id,
										typeCd : n.typeCd,
										codeNm : n.name,
										parentId : n.parentId,
										sort : sortIdx,
										code : n.code,
										level : n.level,
										multiLanguageJson : n.multiLanguageJson
									};
								}
								if (n.children && n.children.length) {
									item.children = convertList(n.children);
								}
								_newTree.push(item);
							});

							/*
							 * for(var i = 0; i < _newTree.length; i++){
							 * _newTree[i].sort = i; console.log(_newTree[i]); }
							 */
							return _newTree;
						};

						var newTree = convertList(tree);
						// console.log("newTree", newTree);
						return newTree;
					},
					getDeletedList : function() {
						return this.deletedList;
					},
					clearDeletedList : function() {
						this.deletedList = [];
						return true;
					},
					updateNode : function(data) {
						var treeNodes = this.target.getSelectedNodes();
						if (treeNodes[0]) {
							treeNodes[0].progCd = data.progCd;
						}
					},
					deselectNode : function() {
						ACTIONS.dispatch(ACTIONS.TREEITEM_DESELECTE);
					}
				});

/**
 * formView01
 */
fnObj.formView01 = axboot.viewExtend(axboot.formView, {
	getDefaultData : function() {
		return $.extend({}, axboot.formView.defaultData, {
			multiLanguageJson : {
				ko : "",
				en : ""
			}
		});
	},
	initView : function() {
		var _this = this;
		this.programList = CODE.programList;
		this.authGroup = CODE.authGroup;

		this.target = $("#formView01");
		this.model = new ax5.ui.binder();
		this.model.setModel(this.getDefaultData(), this.target);
		this.modelFormatter = new axboot.modelFormatter(this.model); // 모델
																		// 포메터
																		// 시작
		this.mask = new ax5.ui.mask({
			theme : "form-mask",
			target : $('#split-panel-form'),
			content : COL("ax.admin.menu.form.d1")
		});
		this.mask.open();
		this.initEvent();

		axboot.buttonClick(this, "data-form-view-01-btn", {
			"form-clear" : function() {
				ACTIONS.dispatch(ACTIONS.FORM_CLEAR);
			}
		});

	},
	initEvent : function() {
		var _this = this;
	},
	getData : function() {
		var data = this.modelFormatter.getClearData(this.model.get()); // 모델의
																		// 값을
																		// 포멧팅 전
																		// 값으로
																		// 치환.
		return data;
	},
	setData : function(data) {
		this.mask.close();
		var _data = this.getDefaultData();

		// this.combobox.ax5combobox("setValue", []);

		// ACTIONS.dispatch(ACTIONS.MENU_AUTH_CLEAR);
		_data.codeId = data.codeId;
		_data.code = data.code;
		_data.codeNm = data.codeNm;

		// alert(_data.codeId);

		if (!data.multiLanguageJson) {
			_data.multiLanguageJson = {
				ko : "",
				en : data.name
			}
		} else {
			_data.multiLanguageJson = data.multiLanguageJson;
		}

		this.model.setModel(_data);
		this.modelFormatter.formatting(); // 입력된 값을 포메팅 된 값으로 변경
	},
	clear : function() {
		this.mask.open();
		this.model.setModel(this.getDefaultData());
	}
});
