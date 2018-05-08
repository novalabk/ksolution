var fnObj = {}, CODE = {};
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
    	
    	
    	// console.log("$.extend({}, this.searchView.getData(), this.gridView01.getPageData())", $.extend({}, this.searchView.getData(), this.gridView01.getPageData()));
    	 
    	  axboot.ajax({
            type: "GET",
            url: ["discompany", "search"],
            data: $.extend({}, this.searchView.getData(), this.gridView01.getPageData()),
            callback: function (res) {
            	
                caller.gridView01.setData(res);
            }
        });
        return false;
    },
    PAGE_SAVE: function (caller, act, data) {
        if (caller.formView01.validate()) {
            var parentData = caller.formView01.getData();
            
            

            axboot.promise()
                .then(function (ok, fail, data) {
                    axboot.ajax({
                        type: "PUT", url: ["discompany", "save"], data: JSON.stringify(parentData),
                        callback: function (res) {
                            ok(res);
                        }
                    });
                })
//                .then(function (ok, fail, data) {
//                    axboot.ajax({
//                        type: "PUT", url: ["samples", "child"], data: JSON.stringify(childList),
//                        callback: function (res) {
//                            ok(res);
//                        }
//                    });
//                })
                .then(function (ok) {
                    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                })
                .catch(function () {

                });
        }

    },
    FORM_CLEAR: function (caller, act, data) {
        axDialog.confirm({
            msg: LANG("ax.script.form.clearconfirm")
        }, function () {
            if (this.key == "ok") {
                caller.formView01.clear();
                //caller.gridView02.clear();
            }
        });
    },
    
    FORM_DELTE : function(caller, act, data){
    	
    	
    	var parentData = caller.formView01.getData();
    	if(typeof parentData.oid === "undefined"){
    		alert("유통사를 먼저 선택 하세요");
    		return;  
    	}
    	axDialog.confirm({
            msg: "정말 삭제 하시겠습니까?"
        }, function () {
            if (this.key == "ok") {
                //caller.formView01.clear();
                //caller.gridView02.clear();
            	
            	
            	axboot.ajax({
                    type: "GET",
                    url: ["discompany", "delete"],
                    data: $.extend({}, {oid : parentData.oid}),
                    callback: function (res) {
                    	caller.formView01.clear();
                    	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                        //caller.gridView01.setData(res);
                    }
                })
            
            }
        });
    	
    },
    
    ITEM_CLICK: function (caller, act, data) {
        //console.log(act);
    	/*alert(data.dep_userId);
    	console.log("data" , data);*/
        caller.formView01.setData(data);
        /*axboot.ajax({
	            type: "GET",
	            url: "/api/v1/samples/child",
	            data: "parentKey=" + data.key,
	            callback: function (res) {
	            //    caller.gridView02.setData(res);
	            }
          });
        */
    },
    
    INIT_TYPECODE: function (caller, act, data) {
        var searchData = {
            typeCd: "Material",
            returnType : "TreeLIST"
        }
        axboot.ajax({
            type: "GET",
            url: ["basicCode"],
            data: searchData,
            callback: function (res) {
            	//console.log("res", res);	
                caller.formView01.setOption(res.list);
            }
        });

        return false;
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

fnObj.pageStart = function () {
    var _this = this;
  //  console.log("_this" , _this);
    axboot.promise()
        .then(function (ok, fail, data) {
            axboot.ajax({
                type: "GET", url: ["commonCodes"], data: {groupCd: "USER_ROLE", useYn: "Y"},
                callback: function (res) {
                    var userRole = [];
                    res.list.forEach(function (n) {
                        userRole.push({
                            value: n.code, text: n.name + "(" + n.code + ")",
                            roleCd: n.code, roleNm: n.name,
                            data: n
                        });
                    });
                    CODE.userRole = userRole;

                    ok();
                }
            });
        })
        .then(function (ok) {
        	
            _this.pageButtonView.initView();
            _this.searchView.initView();
            _this.gridView01.initView();
          //  _this.gridView02.initView();
            _this.formView01.initView();
            
            ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
        })
        .catch(function () {

        });
};

fnObj.pageResize = function () {

};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "search": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            },
            "save": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SAVE);
            },
            "excel": function () {

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
     //   console.log("target", this.target);
        this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
        this.filter = $("#filter");
 
        
    	/*this.target = $(document["searchView0"]);
        console.log("target", target);
        this.model = new ax5.ui.binder();
 
        this.model.setModel(this.getDefaultData(), this.target);
        this.modelFormatter = new axboot.modelFormatter(this.model); // 모델 포메터 시작
*/      
    },
    getData: function () {
        return {
            filter: this.filter.val()
        }
        
      /*  var data = this.modelFormatter.getClearData(this.model.get()); // 모델의 값을 포멧팅 전 값으로 치환.
        return $.extend({}, data);*/
    }
});

/**
 * gridView01
 */
fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
    page: {
        pageNumber: 0,
        pageSize: 10
    },
    initView: function () {
        var _this = this;
        
       
       
			
        this.target = axboot.gridBuilder({
            //showRowSelector: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-01"]'),
            sortable: true,
            columns: [
           /*     {key: "oid", label: "id", width: 50, align: "left"},
          */    {key: "companyNm", label: "상호", width: 100, align: "center"},
                {key: "ceo_name", label: "대표자명", width: 100, align: "center"},
                {key: "type_des", label: "주요 취급품목", width: 200, align: "center"},
                {key: "disLocation", label: "주요 취급품목", width: 200, align: "center"},
                
               /*
                {key: "title_phnumber", label: "대표연략처", width: 150, align: "center"},
                
                {key: "dep_name", label: "담당자", width: 70, align: "center"},
                {key: "dep_phnumber", label: "핸드폰", width: 150, align: "center"}*/
            ],
            body: {
                onClick: function () {
                    this.self.select(this.dindex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                }
            },
            onPageChange: function (pageNumber) {
                _this.setPageData({pageNumber: pageNumber});
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            }
        });

        axboot.buttonClick(this, "data-grid-view-01-btn", {
            "add": function () {
                ACTIONS.dispatch(ACTIONS.ITEM_ADD);
            },
            "delete": function () {
                ACTIONS.dispatch(ACTIONS.ITEM_DEL);
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
    addRow: function () {
        this.target.addRow({__created__: true}, "last");
    }
});

/**
 * formView01
 */
fnObj.formView01 = axboot.viewExtend(axboot.formView, {
    getDefaultData: function () {
        return $.extend({}, axboot.formView.defaultData, {
        	dis_pirce_type : "배송비 포함"
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
            },
            
            "form-delete": function(){
            	ACTIONS.dispatch(ACTIONS.FORM_DELTE);
            }
            	
        });
    },
    initEvent: function () {
        var _this = this;
        
       
        
       
        
        ACTIONS.dispatch(ACTIONS.INIT_TYPECODE);
		
    },
    setOption : function(optionData){
    	
    	 
    	this.data = [];
    	
    	var _data = this.data;
    	
    	optionData.forEach(function (n) {
    		if(n.level == 0){
    			return;
    		}
    		
    		_data.push({
    			disabled: !n.leaf,	
	 		    id: n.codeId,
	 		    text: n.codeNm,
	 		    level: n.level
            });
        });
    	
    	
   
 			
    	this.optionFormat();
 			
 			
    },
    getData: function () {
        var data = this.modelFormatter.getClearData(this.model.get()); // 모델의 값을 포멧팅 전 값으로 치환.
       
        var selectedData = $(".js-example-basic-single").select2("val");

        var codes = {
        	typeCodes : selectedData
        }
        
        return $.extend({}, data, codes);
    },
    setData: function (data) {

        if (typeof data === "undefined") data = this.getDefaultData();
        data = $.extend({}, data);

        this.model.setModel(data);
        this.modelFormatter.formatting(); // 입력된 값을 포메팅 된 값으로 변경
        
        $(".js-example-basic-single").select2().val(data.typeCodes).change();
        this.optionFormat();
        
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
       
        $(".js-example-basic-single").select2().val([]).change();
        
       // $(".js-example-basic-single").select2().select2('val', 20);
        this.optionFormat();
 

    },
    optionFormat: function(){
    	
    	//$("js-example-basic-single").select2({});
    	$(".js-example-basic-single").select2({
    		placeholder: 'Select an option',
			  //  width: "600px",
			    data : this.data,
			    closeOnSelect:false,
			   
			    formatSelection: function(item) {
			    	
			        return item.text
			    },
		      	formatResult: function(item) {
		        	return item.text
		      	},
			    templateResult: function(node){
			    	
				    var $result = $('<span style="padding-left:' + (10 * node.level) + 'px;">' + node.text + '</span>');
				    return $result;
			    }  
    	});
    }
});

