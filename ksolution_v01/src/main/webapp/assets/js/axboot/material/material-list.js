var fnObj = {

	list : []
};

var select = new ax5.ui.select({
	columnKeys : {
		optionValue : "no",
		optionText : "label"
	}
});

var ACTIONS = axboot.actionExtend(fnObj, {
	PAGE_SEARCH : function(caller, act, data) {

		// console.log("ffff", $.extend({}, this.searchView.getData(),
		// this.gridView01.getPageData()));

		// console.log("data...", data);

		console.log("searchData == ", this.searchView.getData());
		var sendData = $.extend({}, this.searchView.getData(), this.gridView01
				.getPageData(), fnObj.gridView01sortInfo);

		// console.log("sendData", sendData);
		/*
		 * var sendData = { "pageData" : this.gridView01.getPageData(),
		 * "requestParam" : this.searchView.getData() };
		 */

		axboot.ajax({
			type : "PUT",
			url : [ "material", "search" ],
			data : JSON.stringify(sendData),// $.extend({},
			// this.gridView01.getPageData()),
			callback : function(res) {
				// console.log("res", res);
				caller.gridView01.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			}
		});

		return false;
	},
	IMG_FILE : function(caller, act, data) {
		axboot.ajax({
			type : "GET",
			url : [ "/api/v1/ax5uploader/list" ],
			data : {
				id : data,
				contentType : "IMG_FILE",
				targetType : "Material_M"
			},
			callback : function(res) {
				caller.imageView.clear();
				caller.imageView.setData(res);
			},
			options : {
				nomask : true
			}
		});
	},
	SFolder : function(caller, act, data) {

		axboot.ajax({
			type : "GET",
			url : [ "spBasket", "searchFolder" ],
			data : {},
			callback : function(res) {
				// console.log("spBasket", res);
				caller.formView01.setFolderList(res);
			},
			options : {
				nomask : true
			}

		})
	},

	ISADMIN : function(caller, act, data) {

		axboot.ajax({
			type : "GET",
			url : [ "material", "isModify" ],
			data : {
				oid : data
			},
			callback : function(res) {
				// alert(res);
				caller.formView01.setAuth(res)
				/*
				 * setAuth() console.log("res", res);
				 */
				// caller.formView01.setFolderList(res);
			},
			options : {
				nomask : true
			}

		})
	},

	ITEM_CLICK : function(caller, act, data) {

		axboot.ajax({
			type : "GET",
			url : [ "material" ],
			data : {
				oid : data
			},

			callback : function(res) {

				// ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
				caller.formView01.setData(res);
				ACTIONS.dispatch(ACTIONS.IMG_FILE, data);
				ACTIONS.dispatch(ACTIONS.SFolder, data);
				ACTIONS.dispatch(ACTIONS.ISADMIN, data);
				UPACTIONS["INIT"]();
				UPACTIONS["GET_uploaded"]();
				ACTIONS.dispatch(ACTIONS.COMMENTLIST);
			},
			options : {
				nomask : true
			}

		});
		// .call({
		// type: "GET",
		// url: ["/api/v1/ax5uploader/list"],
		// data: {id : data,
		// contentType : "IMG_FILE",
		// targetType: "Material_M"},
		// callback: function (res) {
		// caller.imageView.clear();
		// caller.imageView.setData(res);
		// },
		// options: { nomask: true }
		// })
		// .call({
		// type:"GET",
		// url: ["spBasket", "searchFolder"],
		// data: {},
		// callback: function (res) {
		// //console.log("spBasket", res);
		// caller.formView01.setFolderList(res);
		// },
		// options: { nomask: true }
		//	    	
		// })
		// .call({
		// type:"GET",
		// url: ["users", "isAdmin"],
		// data: {},
		// callback: function (res) {
		// //alert(res);
		// caller.formView01.setAuth(res)
		// /*setAuth()
		// console.log("res", res); */
		// //caller.formView01.setFolderList(res);
		// },
		// options: { nomask: true }
		//	    	
		// })
		//	
		// .done(function() {
		// if (data && data.callback) {
		// data.callback();
		// } else {
		//				
		// UPACTIONS["INIT"]();
		// UPACTIONS["GET_uploaded"]();
		// ACTIONS.dispatch(ACTIONS.COMMENTLIST);
		//				
		// }
		// });
	},
	OPEN : function(caller, act, data) {
		caller.gridView01.open(data);
	},

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
					console.log("this.gridView01", this.gridView01);
					var oid = caller.gridView01.getSelectedOid();
					alert(oid);
					ACTIONS.dispatch(ACTIONS.ITEM_CLICK, oid);
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

	ADD_IN_FOLDER : function(caller, act, data) {
		this.folderOid = $("#folderOid");
		this.oid = $("[name='oid']");

		var sendData = $.extend({}, {

			folderOid : this.folderOid.val(),
			oid : this.oid.val()
		});

		// console.log("sendData", sendData);

		axboot.ajax({
			type : "PUT",
			url : [ "spBasket", "saveLink" ],
			data : JSON.stringify(sendData),
			callback : function(res) {
				// console.log("data", res);
				axToast.push(res.message);
				// caller.gridView01.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			}
		});

		return false;
	},

	ADDCOMMENT : function(caller, act, data) {
		axMask.open();
		var oid = $("[name='oid']").val();
		if (oid === "") {
			alert("저장 할 수 없습니다. 자재를 선택해 주세요");
			return;
		}
		$("#fileForm").children("[name='oid']").val(oid);
		$('#fileForm').ajaxForm({
			url : "/api/v1/material/comment",
			type : "POST",
			enctype : "multipart/form-data", // 여기에 url과 enctype은 꼭 지정해주어야 하는
			// 부분이며 multipart로 지정해주지 않으면
			// controller로 파일을 보낼 수 없음
			success : function(result) {
				// if(result.status == 0){

				// alert(result.message);
				// axToast.push(result.message);
				// }
				axMask.close();

				// console.log("kkkdkfjdklfj " , $(".fileinput-remove-button"));
				$(".fileinput-remove.fileinput-remove-button").click();
				// var target = $("#fileForm");
				$('#fileForm').find('[data-ax-path="comment"]').val("");
				// target.find('[data-ax-path="file"]').val("");

				// $(".fileinput-remove .fileinput-remove-button").click();

				// $("#fileopen").val("");
				// this.model.setModel(this.getDefaultData(), this.target);
				// this.modelFormatter = new axboot.modelFormatter(this.model);

				ACTIONS.dispatch(ACTIONS.COMMENTLIST);

			}
		});
		// 여기까지는 ajax와 같다. 하지만 아래의 submit명령을 추가하지 않으면 백날 실행해봤자 액션이 실행되지 않는다.
		$("#fileForm").submit();

	},

	DELTECOMMENT : function(caller, act, data) {

		var sendData = $.extend({}, data);

		// console.log("sendData", sendData);

		axboot.ajax({
			type : "GET",
			url : [ "material", "deleteComment" ],
			data : sendData,
			options : {
				nomask : true
			},
			callback : function(res) {
				// console.log("data", res);
				axToast.push(res.message);
				ACTIONS.dispatch(ACTIONS.COMMENTLIST);
				// caller.gridView01.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			}
		});

	},

	COMMENTLIST : function(caller, act, data) {

		this.folderOid = $("#folderOid");
		this.oid = $("[name='oid']");

		var sendData = $.extend({}, {
			folderOid : this.folderOid.val(),
			oid : this.oid.val()
		});
		// console.log("sendData", sendData);
		// var sendData = $.extend({}, this.pageButtonView.getData());
		axboot.ajax({
			type : "GET",
			url : [ "material", "commentlist" ],
			data : sendData,
			options : {
				nomask : true
			},
			callback : function(res) {
				res.list.forEach(function(n) {
					n.comments = [];
					if (n.comment != null) {

						list = n.comment.split("\n")

						list.forEach(function(c) {
							var a = new Object();
							a.comment = c;
							n.comments.push(a);
						});
						// console.log("n.comments", n.comments);
						// n.comment = n.comment.replace(/\n\r?/g, '&#13;&#10');
						// alert(n.comment);
					}
				});

				// console.log("data", res.list);
				// console.log("this.commentView", caller.commentView);
				caller.commentView.setData(res.list);

				// axToast.push(res.message);
				// caller.gridView01.setData(res);
				// ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
				// roleList: []});
			},

		});

		return false;
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

	// this.updateCategory();

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
	}).call({
		type : "GET",
		url : [ "basicCode" ],
		data : {
			typeCd : "Material",
			returnType : "TreeLIST"
		},
		callback : function(res) {
			// console.log("res", res);
			// console.log("res.list = " + res.list);

			res.list.forEach(function(n) {
				if (n.level == 0) {
					return;
				}
				var pno = n.parentId;
				if (n.level == 1) {
					pno = 0;
				}

				fnObj.list.push({
					pno : pno,
					no : n.codeId,
					label : n.codeNm
				});
			});
			// console.log("list", fnObj.list);
			// caller.formView01.setOption(res.list);
		}
	}).done(function() {

		CODE = this; // this는 call을 통해 수집된 데이터들.

		_this.pageButtonView.initView();
		_this.searchView.initView();
		_this.gridView01.initView();
		_this.formView01.initView();
		_this.imageView.initView();
		_this.commentView.initView();
		ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	});
};

fnObj.updateCategory = function(v1, v2) {
	var options1 = [], options2 = [], options3 = [];

	fnObj.list.forEach(function(n) {
		if (n.pno == v1)
			options2.push(n)
	});

	$('option', $('#level3')).remove();
	$('#level3').append($('<option>', {
		value : -1,
		text : "전체",
		selected : "selected"
	}));

	if (typeof v2 === "undefined") {
		$('option', $('#level2')).remove();

		$('#level2').append($('<option>', {
			value : -1,
			text : "전체"
		}));
		$.each(options2, function(i, item) {
			$('#level2').append($('<option>', {
				value : item.no,
				text : item.label
			}));
		});
		// alert( $("#level2").val());

	} else {
		fnObj.list.forEach(function(n) {
			if (n.pno == v2)
				options3.push(n)
		});

		$.each(options3, function(i, item) {
			$('#level3').append($('<option>', {
				value : item.no,
				text : item.label
			}));
		});

	}

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

		this.folderOid = $("#folderOid");
		this.oid = $("[name='oid']");

		axboot.buttonClick(this, "data-form-view-01-btn", {

			"folder" : function() {

				ACTIONS.dispatch(ACTIONS.FOLDER_CREATE);
			},
			"addFolder" : function() {
				if ($("#folderOid").val() == null) {
					axDialog.alert({
						theme : "primary",
						msg : "먼저 폴더를 생성해 주십시오."
					});
					return;
				}

				axDialog.confirm({
					theme : "primary",
					msg : "즐겨찾기에 추가하시겠습니까?"// LANG("ax.script.alert.test")
				}, function() {
					if (this.key == "ok") {
						ACTIONS.dispatch(ACTIONS.ADD_IN_FOLDER);
						// caller.gridView02.clear();
					}
				});
			},
			"commendSave" : function() {
				ACTIONS.dispatch(ACTIONS.ADDCOMMENT);
			},
			"update" : function() {
				ACTIONS.dispatch(ACTIONS.OPEN, $("[name='oid']").val());
			}

		});
	}
});

// == view 시작
/**
 * searchView
 */
fnObj.searchView = axboot.viewExtend(axboot.formView, {
	getDefaultData : function() {
		return $.extend({}, axboot.formView.defaultData, {
			multiLanguageJson : {
				ko : "",
				en : ""
			}
		});
	},
	initView : function() {
		this.target = $("#searchView0");
		this.target.attr("onsubmit",
				"return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");

		this.model = new ax5.ui.binder();
		this.model.setModel(this.getDefaultData(), this.target);
		// this.modelFormatter = new axboot.modelFormatter(this.model);
		// this.filter = $("#filter");

		this.cate1 = $('#level1');
		this.cate2 = $('#level2');
		this.cate3 = $('#level3');

		$('#level1').on({
			change : function() {
				fnObj.updateCategory($('#level1').val());
			}
		});
		$('#level2').on({
			change : function() {
				fnObj.updateCategory($('#level1').val(), $('#level2').val());
			}
		});

		// console.log("this.list", this.list);

		var options1 = [];
		fnObj.list.forEach(function(n) {
			if (n.pno == 0)
				options1.push(n)
		});

		$('#level1').append($('<option>', {
			value : -1,
			text : "전체"
		}));
		$.each(options1, function(i, item) {
			$('#level1').append($('<option>', {
				value : item.no,
				text : item.label
			}));
		});

		$('#level2').append($('<option>', {
			value : -1,
			text : "전체"
		}));
		$('#level3').append($('<option>', {
			value : -1,
			text : "전체"
		}));
	},
	getData : function() {

		// alert(this.filter.val());
		var data = this.model.get(); // 모델의

		var returndata = $.extend({}, data, {
			level1 : $("#level1").val(),
			level2 : $("#level2").val(),
			level3 : $("#level3").val()
		});
		return returndata;
		// 값을

		/*
		 * return { // pageNumber: this.pageNumber, // pageSize: this.pageSize,
		 * filter: this.filter.val() }
		 */
	}
});
fnObj.thumnailPopup = function(obj) {
	var thumbnail = $(obj).attr("data-thumbnail-link");
	var thumbPop = window.open(thumbnail, "", "width=500,height=500");
}

fnObj.thumnailView = function(obj, isView) {

	if (isView) {

		var thumbnail = $(obj).attr("data-thumbnail-link");
		var thumbView = '<img src="' + thumbnail + '">';
		$("[data-thumbview]").html(thumbView);
		$("[data-thumbview]").show();

		var offset = $(obj).offset();
		var height = $("[data-thumbview] img").height();

		var clientHeight = document.body.clientHeight;

		var top = offset.top;
		var left = offset.left + 20;

		var offsetHeight = height + top;

		if (clientHeight < offsetHeight) {
			top -= height;
		}

		$("[data-thumbview]").css("top", top + "px");
		$("[data-thumbview]").css("left", left + "px");

	} else {
		$("[data-thumbview]").hide();
	}
}

fnObj.formView01 = axboot.viewExtend(axboot.formView, {
	getDefaultData : function() {
		return $.extend({}, axboot.formView.defaultData, {
			multiLanguageJson : {
				ko : "",
				en : ""
			},
			m_exist : "재고"
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
		/*
		 * this.mask = new ax5.ui.mask({ theme : "form-mask", target :
		 * $('#split-panel-form'), content : COL("ax.admin.menu.form.d1") });
		 * this.mask.open();
		 */
		// this.initEvent();
		this.actionButton = $("#actionButton");

		//console.log("actionButton", actionButton);

	},

	setData : function(data) {

		$(actionButton).css("display", "block");

		$(updateButton).attr("disabled", true);

		var _data = this.getDefaultData();

		if (!data.multiLanguageJson) {
			_data.multiLanguageJson = {
				ko : "",
				en : data.name
			}
		} else {
			_data.multiLanguageJson = data.multiLanguageJson;
		}

		this.model.setModel(data);
		this.modelFormatter.formatting(); // 입력된 값을 포메팅 된 값으로 변경
		
		$( "a[data-ax-path='mfCompany.home_addr']" ).attr("href", data.mfCompany.home_addr);
		$( "a[data-ax-path='disCompany.home_addr']" ).attr("href", data.disCompany.home_addr);
		$( "a[data-ax-path='product_des_url']" ).attr("href", data.product_des_url);
		
	},

	setFolderList : function(datas) {

		options = [];
		console.log("datas", datas);

		datas.list.forEach(function(o) {
			var option = new Object();
			option.id = o.oid;
			option.text = o.folderNm;
			options.push(option);
		});

		$(".folderSelect").not('.select2-container').empty();
		/*
		 * $(".folderSelect").select2({data: []}); // clear out values selected
		 * $(".folderSelect").select2({ allowClear: true }); // re-init to show
		 * default status
		 */
		// $(".folderSelect").remove();
		$('.folderSelect').select2({
			data : options,
			allowClear : true
		}).trigger("change");

		// alert("lll");

	},
	clear : function() {
		// this.mask.open();
		this.model.setModel(this.getDefaultData());
		// $(".js-example-basic-single").select2().val(null).change();
		// this.optionFormat();
	},

	setAuth : function(data) {
		// alert(data);

		if (data) {
			//
			$(updateButton).attr("disabled", false);
			// $(updateButton).css("display", "none");
		}
	}
});
/**
 * gridView
 */
fnObj.gridView01 = axboot
		.viewExtend(
				axboot.gridView,
				{
					page : {
						pageNumber : 0,
						pageSize : 50
					},
					initView : function() {

						var _this = this;
						this.target = $("#ax-frame-header-tab-container");
						this.frameTarget = $("#content-frame-container");

						this.targetGrid = axboot
								.gridBuilder({
									target : $('[data-ax5grid="grid-view-01"]'),
									showRowSelector : false,
									sortable : true,
									editable : false,
									showLineNumber : false,
									frozenColumnIndex : 0,
									remoteSort : function() {
										console.log(this.sortInfo[0]);
										fnObj.gridView01sortInfo = this.sortInfo[0];
										ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);

									},
									columns : [
											{
												key : "thumbnail",
												label : '',// COL("user.id"),
												width : 40,
												sortable : false,
												align : "center",
												formatter : function() {
													if (this.value) {
														var tumb = this.value.thumbnail;
														return '<img src="'
																+ tumb
																+ '" style="width:20px;height:20px;position:relative;top:-2px;cursor:pointer;" onclick="fnObj.thumnailPopup(this)" onmouseover="fnObj.thumnailView(this,true)" onmouseout="fnObj.thumnailView(this,false)" data-thumbnail-link="'
																+ tumb + '">';
													} else {
														return '';
													}
												}
											},
											// {
											// key: "serialNumber",
											// label: '일련번호',//COL("user.id"),
											// width: 120
											// },
											// {
											// key: "typePath",
											// label: '분류 ',//COL("user.name"),
											// width: 200,
											// sortable : false
											// },
											{
												key : "number",
												label : '품번',// COL("user.id"),
												width : 120
											}, {
												key : "seriese",
												label : '시리즈',// COL("user.name"),
												width : 80
											},

											{
												key : "mfCompanyName",
												label : '브랜드',// COL("user.name"),
												width : 90
											}, {
												key : "cmprice",
												label : '소비자가',// COL("user.name"),
												width : 90
											}
									// ,
									// {
									// key: "origin",
									// label: '원산지',//COL("user.name"),
									// width: 120
									// },
									// {
									// key: "m_exist_str",
									// label: '자재 유무',//COL("user.name"),
									// width: 120
									// },
									// {key: "generatedcreatedAt",
									// label:'작성일' ,
									// width : 180,
									// /*formatter : function() {
									// if (this.value)
									// return ax5.util.date(new Date(this.value
									// || ""), {
									// "return" : 'yyyy/MM/dd hh:mm:ss'
									// });
									//
									// return this.value;
									// }*/
									// },//COL("user.language")},
									// {key: "createdBy",
									// label:'작성자'},//COL("ax.admin.use.or.not")}

									/*
									 * {key: "thumbnail", label: "thumbnail",
									 * width: 60, align: "center", formatter:
									 * function () { return '<img
									 * src="/assets/favicon.ico">' } }
									 */
									],
									body : {
										onClick : function() {

											// this.frameTarget =
											// $("#content-frame-container");
											// alert($("#content-frame-container"));
											// console.log("mmm..... ",
											// $("#content-frame-container"));

											this.self.select(this.dindex);
											// console.log('onClick
											// call!!!!!!!!!!!!!!!!!!!!!1' +
											// this.dindex);
											// ACTIONS.dispatch(ACTIONS.ITEM_CLICK,
											// this.list[this.dindex]);
											var oid = this.list[this.dindex].oid;
											ACTIONS.dispatch(
													ACTIONS.ITEM_CLICK, oid);

											// ACTIONS.dispatch(ACTIONS.OPEN,
											// oid);

										},
										onDBLClick : function() {
											// this.self.select(this.dindex,
											// {selectedClear: true});
											var oid = this.list[this.dindex].oid;

											// alert("DBLClick grid : row " +
											// this.dindex);
											// location.href="/api/v1/material/view?menuId=23&oid="
											// + oid;
											// alert(oid);
											// location.href="/api/v1/material/view?oid="
											// + oid;
										},

									},

									onPageChange : function(pageNumber) {
										_this.setPageData({
											pageNumber : pageNumber
										});
										ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
									}
								});
					},
					setData : function(_data) {
						// console.log(_data);
						this.targetGrid.setData(_data);
					},
					getData : function(_type) {
						var list = [];
						var _list = this.targetGrid.getList(_type);

						if (_type == "modified" || _type == "deleted") {
							list = ax5.util.filter(_list, function() {
								return this.key;
							});
						} else {
							list = _list;
						}
						return list;
					},
					align : function() {
						this.targetGrid.align();
					},
					getSelectedOid : function() {
						var list = this.getData("selected");
						var oid = "";
						if (list.length > 0) {
							oid = list[0].oid;
						}
						return oid;

					},
					open : function(oid) {

						// alert(oid);
						// parent.fnObj.tabView.open(item);
						var url = '/jsp/material/material-create.jsp?menuId=25&oid='
								+ oid;

						item = {
							menuId : 25,
							id : "material",
							progNm : '자재수정',
							menuNm : '자재등록',
							progPh : '/jsp/material/material-create.jsp',
							url : url,
							status : "on",
							fixed : true
						};

						parent.fnObj.tabView.open(item);
						/*
						 * var _item;
						 * 
						 * var findedIndex = ax5.util.search(this.list, function () {
						 * this.status = ''; return this.menuId == item.menuId;
						 * }); this.target.find('.tab-item').removeClass("on");
						 * this.frameTarget.find('.frame-item').removeClass("on");
						 * alert(findedIndex); if (findedIndex < 0) {
						 * this.list.push({ menuId: item.menuId, id: item.id,
						 * progNm: item.progNm, menuNm: item.menuNm, progPh:
						 * item.progPh, url: CONTEXT_PATH + item.progPh +
						 * "?menuId=" + item.menuId, status: "on" }); _item =
						 * this.list[this.list.length - 1];
						 * this.targetHolder.find(".tab-item-addon").before(this._getItem(_item));
						 * this.frameTarget.append(this._getFrame(_item)); }
						 * else { _item = this.list[findedIndex];
						 * this.target.find('[data-tab-id="' + _item.menuId +
						 * '"]').addClass("on");
						 * this.frameTarget.find('[data-tab-id="' + _item.menuId +
						 * '"]').addClass("on");
						 * 
						 * //custom window["frame-item-" +
						 * _item.menuId].location.href = _item.url; }
						 * 
						 * if (_item) {
						 * //topMenu.setHighLightOriginID(_item.menuId || ""); }
						 * 
						 * if (this.list.length > this.limitCount) {
						 * this.close(this.list[1].menuId); }
						 * 
						 * this.bindEvent(); this.resize();
						 */
					}
				}

		);

fnObj.imageView = axboot.viewExtend(axboot.formView, {

	initView : function() {
		var _this = this;
		this.tmpl = $('[data-manual-content="tmpl"]').html();
		this.$view = $("#target");

	},

	setData : function(data) {
		if (data != null && data.length > 0) {
			// style.display = "block";
			console.log("data", data);
			$("#target").css("display", "block");
		}
		this.$view.html(ax5.mustache.render(this.tmpl, data));
	},

	clear : function() {
		$("#target").css("display", "none");
		// this.model.setModel(this.getDefaultData());
	}
});

fnObj.commentView = axboot.viewExtend({
	initView : function() {
		$("#input-1a").fileinput({
			'showUpload' : false,
			'showCancel' : false,

			'showClose' : false,
			'showPreview' : false,
			'showUploadedThumbs' : false
		});
		$(".kv-upload-progress").css("display", "none");

		this.template = $('#commenttemplate').html();
		// Mustache.parse(this.template);

	},
	setData : function(datas) {
		$('#comment-target').html(ax5.mustache.render(this.template, datas));
	}
});