var fnObj = {
		
    list: [
    ]};

var select = new ax5.ui.select({
    columnKeys: {
        optionValue: "no", optionText: "label"
    }
});

var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
    	
    	var sendData = $.extend({}, this.searchView.getData(), this.gridView01.getPageData(), fnObj.gridView01sortInfo);
    	
    	axboot.ajax({
            type: "PUT",
            url: [ "material", "search" ] ,
            data: JSON.stringify(sendData),
            callback: function (res) {
                caller.gridView01.setData(res);
            }
        });

        return false;
    },
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
                	
                	//caller.gridView01.clearSelect();
                }
            });
        	
        } else {
            alert(LANG("ax.script.requireselect"));
        }
    },
    ITEM_CLICK: function (caller, act, data) {
    	
    	
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
    
    
	

	
   // this.updateCategory();
    
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
        .call({
        	type: "GET",
            url: ["basicCode"],
            data: {
                typeCd: "Material",
                returnType : "TreeLIST"},
            callback: function (res) {
            	//console.log("res", res);
            	//console.log("res.list = " + res.list);
            	
                res.list.forEach(function (n) {
            		if(n.level == 0){
            			return;
            		}
            		var pno = n.parentId;
            		if(n.level == 1){
            			pno = 0;
            		}
            		
	        		fnObj.list.push({
	        			pno: pno,	
	    	 		    no: n.codeId,
	    	 		    label: n.codeNm
	                });
                });
               // console.log("list", fnObj.list);
               // caller.formView01.setOption(res.list);
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


fnObj.updateCategory = function (v1, v2) {
    var options1 = [], options2 = [], options3 = [];

   
    fnObj.list.forEach(function(n){
        if(n.pno == v1) options2.push(n)
    });
    
    
    
    $('option', $('#level3')).remove();
    $('#level3').append($('<option>', { 
        value: -1,
        text : "전체" 
    }));
    
    if (typeof v2 === "undefined"){
    	$('option',  $('#level2')).remove();
    	
    	
	    $('#level2').append($('<option>', { 
	        value: -1,
	        text : "전체" 
	    }));
	    $.each(options2, function (i, item) {
	    	$('#level2').append($('<option>', { 
	            value: item.no,
	            text : item.label 
	        }));
	    });
    }else{
    	fnObj.list.forEach(function(n){
            if(n.pno == v2) options3.push(n)
        });
    		
    	$.each(options3, function (i, item) {
	    	$('#level3').append($('<option>', { 
	            value: item.no,
	            text : item.label 
	        }));
	    });
    	
    	
    }
    
    
    
    
    
    /*select.bind({
        target: this.cate1,
        options: options1,
        onChange: function(){
            //console.log(this.value[0].no);
            fnObj.updateCategory(this.value[0].no);
        }
    });
    select.val(this.cate1, v1);

    select.bind({
        target: this.cate2,
        options: options2,
        onChange: function(){
            //console.log(this.value[0].no);
            // fnObj.updateCategory(v1, this.value[0].no);
        }
    });
    select.val(this.cate2, v2);*/   
};



fnObj.pageResize = function () {

};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
            "search": function () {
                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            },
        	"choice" : function(){
        		ACTIONS.dispatch(ACTIONS.PAGE_CHOICE);
        	}
        });
    }
});
//== view 시작
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
    initView: function () {
        this.target = $("#searchView0");
        this.target.attr("onsubmit", "return ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);");
        
        this.model = new ax5.ui.binder();
		this.model.setModel(this.getDefaultData(), this.target);
		//this.modelFormatter = new axboot.modelFormatter(this.model);
        //this.filter = $("#filter");
        
        
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
    	
    	//console.log("this.list",  this.list);
    	
    	var options1 = [];
    	fnObj.list.forEach(function(n){
            if(n.pno == 0) options1.push(n)
        });
        
        $('#level1').append($('<option>', { 
            value: -1,
            text : "전체" 
        })); 
        $.each(options1, function (i, item) {
        	$('#level1').append($('<option>', { 
                value: item.no,
                text : item.label 
            }));
        });
        
        $('#level2').append($('<option>', { 
            value: -1,
            text : "전체" 
        })); 
        $('#level3').append($('<option>', { 
            value: -1,
            text : "전체" 
        })); 
    },
    getData: function () {
    	
    	//alert(this.filter.val());
    	var data = this.model.get(); // 모델의
    	return data;
		// 값을

    	/*
        return {
           // pageNumber: this.pageNumber,
           // pageSize: this.pageSize,
            filter: this.filter.val()
        }*/
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
	page: {
        pageNumber: 0,
        pageSize: 50
    },
    initView: function () {

        var _this = this;
        this.target = axboot.gridBuilder({
            target: $('[data-ax5grid="grid-view-01"]'),
            showRowSelector: true,
            multipleSelect: true,
            sortable: true,
            frozenColumnIndex: 0,
            remoteSort: function () {
                 console.log(this.sortInfo[0]);
                 fnObj.gridView01sortInfo = this.sortInfo[0];
                 ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
              
            },
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
            	{
                    key: "serialNumber",
                    label: '일련번호',//COL("user.id"),
                    width: 120
                },
                {
                    key: "typePath",
                    label: '분류 ',//COL("user.name"),
                    width: 200,
                    sortable : false
                },
                {
                    key: "number",
                    label: '품번',//COL("user.id"),
                    width: 120
                },
                {
                    key: "cmprice",
                    label: '소비자가',//COL("user.name"),
                    width: 120
                },
                {
                    key: "mfCompanyName",
                    label: '제조사',//COL("user.name"),
                    width: 120
                },
                {
                    key: "origin",
                    label: '원산지',//COL("user.name"),
                    width: 120
                },
                {
                    key: "m_exist_str",
                    label: '자재 유무',//COL("user.name"),
                    width: 120
                },
                {key: "generatedcreatedAt", 
                	label:'작성일' ,
                	width : 180,
                	/*formatter : function() {
					if (this.value)
						return ax5.util.date(new Date(this.value || ""), {
							"return" : 'yyyy/MM/dd hh:mm:ss'
						});

					return this.value;
                	}*/
                },//COL("user.language")},
                {key: "createdBy", label:'작성자'},//COL("ax.admin.use.or.not")}
                
                /*{key: "thumbnail", label: "thumbnail", width: 60, align: "center", formatter: function () {
                    return '<img src="/assets/favicon.ico">'
                }
                }*/
            ],
            body: {
                onClick: function () {
                    this.self.select(this.dindex);
                  //  console.log('onClick call!!!!!!!!!!!!!!!!!!!!!1' + this.dindex);
                    //ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.list[this.dindex]);
                },
                onDBLClick: function () {
                	 // this.self.select(this.dindex, {selectedClear: true});
                     var oid = this.list[this.dindex].oid;
                      
                    //alert("DBLClick grid : row " + this.dindex);
                     
//                     var url = '/api/v1/material/view?menuId=25&oid=' + oid;
//                 	
//                 	item =  {menuId: 25, id: "material", progNm: '자재 상세보기', menuNm: '자재등록', progPh: '/jsp/material/material-view.jsp', url: url, status: "on", fixed: true};
//                     
//                     parent.fnObj.tabView.open(item);
//                    location.href="/api/v1/material/view?menuId=25&oid=" + oid;
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
    clearSelect: function () {
        this.target.clearSelect();
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