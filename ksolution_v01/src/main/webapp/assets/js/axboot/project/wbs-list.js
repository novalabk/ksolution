var fnObj = {};
   
   var ACTIONS = axboot.actionExtend(fnObj, {
   	   PAGE_SEARCH : function (caller, act, data){
		   
		   
   		var sendData = $.extend({}, this.searchView.getData(), this.gridView01.getPageData());
      	  
      	 axboot.ajax({
   			type : "GET", 
   			url : [ "gantt", "list"],
   			data : sendData,// $.extend({}, 
   			// this.gridView01.getPageData()),
   			callback : function(res) {
   				console.log("res", res);
   				caller.gridView01.setData(res);
   				
   				//console.log("res", res);
   				//caller.gridView01.setData(res);
   				//ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "",
   				//roleList:[]});
   			}
   		  });
      	  
	   },
	   
	   
	   TAB_OPEN : function(caller, act, data) {
			
			var oid = data.oid;
			var code = data.code;
		    var url = CONTEXT_PATH + '/jsp/project/gantt-save.jsp?&oid=' + oid;
            
		    
			var item = {
				menuId : code,
				id : code,
				progNm : 'GANNTVIEW',
				menuNm : code,
				progPh : '/jsp/project/gantt-save.jsp',
				url : url,
				status : "on",
				fixed : true
			};
			
			
			parent.fnObj.tabView.open(item);
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
   
   fnObj.pageStart = function () {
	   var _this = this;
	   _this.searchView.initView();
	   _this.pageButtonView.initView();
	   _this.gridView01.initView();
	   ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
   }
   
   fnObj.searchView = axboot.viewExtend(axboot.searchView, {
	    initView: function () {
	        
	        this.target = $("#searchView0");  
	        this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
	        
	      	this.name = this.target.find('[data-ax-path="' + "name" + '"]');
	      	this.code = this.target.find('[data-ax-path="' + "code" + '"]');
	      	this.state = this.target.find('[data-ax-path="' + "state" + '"]');
	    },
	    getData: function () {
	    	return {
     			name : this.name.val(),
     			code : this.code.val(),
     			state : this.state.val()
	      	};
	    }
	});
   
   fnObj.pageButtonView = axboot.viewExtend({
	    initView: function () {
	        axboot.buttonClick(this, "data-page-btn", {
	            "search": function () {
	                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	            }
	        });
	    }
   });
   
   fnObj.gridView01 = axboot.viewExtend(axboot.gridView,
			{
			page : {
				pageNumber : 0,
				pageSize : 50
			},
			initView : function() {

				var _this = this;
				this.target = $("#ax-frame-header-tab-container");
				this.frameTarget = $("#content-frame-container");
				this.targetGrid = axboot.gridBuilder(
						{
							target : $('[data-ax5grid="grid-view-01"]'),
							showRowSelector : false,
							sortable : true,
							editable : false,
							showLineNumber : false,
							frozenColumnIndex : 0,
							remoteSort : function() {
								fnObj.gridView01sortInfo = this.sortInfo[0];
								ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
							},
							columns : [
									
									{
										key : "code",
										label : MSG("ks.Msg.34"),//프로젝트 코드
										width : 140
									},
									{
										key : "name",
										label : MSG("ks.Msg.35"),//프로젝트명
										width : 340
									},

									{
										key : "stateDisplay",
										label : MSG("ks.Msg.36"),//상태
										width : 140,
										align: "center"
									},
									{
										key : "startDate",
										label : LANG("ax.script.ks.04"),//시작일
										width : 140,
										align: "center"
									},
									{
										key : "endDate",
										label : LANG("ax.script.ks.05"),//종료일
										width : 140,
										align: "center"
									}

							],
							body : {
								onClick : function() {

									

									
								},
								onDBLClick : function() {
									this.self.select(this.dindex);
									
									var oid = this.list[this.dindex].oid;
									var code = this.list[this.dindex].code;
									var data = { 
										oid : oid,
										code : code
									};
									
									ACTIONS.dispatch(ACTIONS.TAB_OPEN, data);

								},

							},

							onPageChange : function(
									pageNumber) {
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
						var _list = this.targetGrid
								.getList(_type);

						if (_type == "modified"
								|| _type == "deleted") {
							list = ax5.util.filter(_list,
									function() {
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
						var oid = data.oid;
						var code = data.code;
					    var url = CONTEXT_PATH + '/jsp/project/gantt-save.jsp?&oid=' + oid;
			                
						var item = {
							menuId : code,
							id : code,
							progNm : 'GANNTVIEW',
							menuNm : code,
							progPh : '/jsp/project/gantt-save.jsp',
							url : url,
							status : "on",
							fixed : true
						};
						
						
			  
						parent.fnObj.tabView.open(item);

					}
				}

			);