var fnObj = {};
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
    	
    	var param = "";
    	
    	param += "&pjtInfoId=" + $("#infoId").val();
    	param += "&code=" + $("#code").val();
    	
    	console.log(param);
    	
        axboot.ajax({
	        type: "GET",
	        url: ["pjtInfoMaterial"],
	        data: param,
	        callback: function (res) {
	        	caller.gridView01.setData(res);
	        }
	    });
        return false;
    },
    ITEM_CLICK: function (caller, act, data) {
    	
    },
    ITEM_ADD: function (caller, act, data) {
    	
    	var modalType = "MATERIAL_LIST";
    	var param = "menuId=24";
    	
    	if("basket" == data){
    		modalType="BASKET_LIST";
    		param = "menuId=27";
    	}
    	
    	param += "&infoId=" + $("#infoId").val();
    	param += "&code=" + $("#code").val();
    	
    	axboot.modal.open({
            modalType: modalType,
            param: param,
            zIndex: 5020,
            header:{title: "&nbsp;"},
            sendData: function(){
                return {};
            },
            callback: function (data) {
            	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
            	parent.ksModal.callback();
            }
        });
    },
    ITEM_SERIAL_ADD : function (caller, act, data) {
    	
    	axboot.ajax({
	        type: "PUT",
	        url: ["pjtInfoMaterial", $("#infoId").val(), $("#code").val(), $("#serialNo").val()],
	        callback: function (res) {
	        	axToast.push(res.message);
	        	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	        }
	    });
    	
    },
    ITEM_DEL: function (caller, act, data) {

    	var list = caller.gridView01.getData("selected");
    	
    	axboot.ajax({
	        type: "DELETE",
	        url: ["pjtInfoMaterial"],
	        data: JSON.stringify(list),
	        callback: function (res) {
	        	ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
	        	parent.ksModal.callback();
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

var CODE = {};

// fnObj 기본 함수 스타트와 리사이즈
fnObj.pageStart = function () {
    var _this = this;
    
    //console.log(parent.axboot.modal.getData());

    _this.pageButtonView.initView();
    _this.gridView01.initView();

    ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
};

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

};

fnObj.pageButtonView = axboot.viewExtend({
    initView: function () {
        axboot.buttonClick(this, "data-page-btn", {
//            "search": function () {
//                ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
//            },
        });
    }
});
/**
 * gridView
 */
fnObj.gridView01 = axboot.viewExtend(axboot.gridView, {
    initView: function () {
        var _this = this;

        this.target = axboot.gridBuilder({
            showLineNumber: false,
            showRowSelector: true,
            multipleSelect: true,
            frozenColumnIndex: 0,
            target: $('[data-ax5grid="grid-view-01"]'),
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
                    this.self.select(this.dindex);
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.item);
                }
            }
        });
        
        
        axboot.buttonClick(this, "data-grid-view-01-btn", {
        	"basket-add": function () {
                ACTIONS.dispatch(ACTIONS.ITEM_ADD, "basket");
            },
        	"material-add": function () {
                ACTIONS.dispatch(ACTIONS.ITEM_ADD, "material");
            },
            "delete": function () {
            	ACTIONS.dispatch(ACTIONS.ITEM_DEL);
            	
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