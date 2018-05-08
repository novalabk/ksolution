var fnObj = {
		
		 list: [
			    ],
			    
		 lan: {
				    inputTooShort: function(args) {
					    
					      return "검색어을 입력 하시길 바랍니다";
					    },
					    inputTooLong: function(args) {
					    
					      return "You typed too much";
					    },
					    errorLoading: function() {
					      return "Error loading results";
					    },
					    loadingMore: function() {
					      return "Loading more results";
					    },
					    noResults: function() {
					      return "찾지 못 했습니다.";
					    },
					    searching: function() {
					      return "Searching...";
					    },
					    maximumSelected: function(args) {
					      // args.maximum is the maximum number of items the user may select
					      return "Error loading results";
					    }
					  }
};
var ACTIONS = axboot.actionExtend(fnObj, {

	PAGE_SAVE : function(caller, act, data) {
		
		var formData = caller.formView01.getData();
		
		//console.log("fromData ", formData);
		
		if(formData.typeOid == ""){
			alert("분류을 선택해 주세요");
			return;
		}
		
		
			
		
		if (!caller.formView01.validate()) {
			return;
		}
		

		var files = ax5.util.deepCopy(UPLOAD.uploadedFiles);
	    
		var docfiles = ax5.util.deepCopy(UPLOAD2.uploadedFiles);
	    
	// console.log("docFiles, " , docfiles);
		
		var obj = {
            	"material" : [formData],
            	"menuId" : formData.menuId, 
                "imgFileList" : files,
                "fileList" : docfiles
            };
		
		axboot.call({
			type : "PUT",
			url : [ "material" ],
			data : JSON.stringify(obj),
			callback : function(res) {
				// caller.treeView01.clearDeletedList();
				axToast.push("저장 하였습니다.");
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
	},
	
	ITEM_CLICK: function (caller, act, data) {
        
		axboot.ajax({
            type: "GET",
            url: ["material"],
            data: {oid: data},
            callback: function (res) {
                // ACTIONS.dispatch(ACTIONS.PAGE_SEARCH);
                caller.formView01.setData(res);
            }
        });
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
            	// console.log("res", res);
                caller.formView01.setOption(res.list , data);
            }
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

	axboot
    .call({
    	type: "GET",
        url: ["basicCode"],
        data: {
            typeCd: "Material",
            returnType : "TreeLIST"},
        callback: function (res) {
        	// console.log("res", res);
        	// console.log("res.list = " + res.list);
        	
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

    	_this.pageButtonView.initView();
   	 
   	 	var oid = $('input[name=oid]').val();
   	
   	
   	 	_this.formView01.initView(oid);
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

/**
 * formView01
 */
fnObj.updateCategory = function (v1, v2) {
    var options1 = [], options2 = [], options3 = [];

   
    fnObj.list.forEach(function(n){
        if(n.pno == v1) options2.push(n)
    });
    
    
    
    $('option', $('#level3')).remove();
    $('#level3').append($('<option>', { 
        value: -1,
        text : "전체" ,
        selected : "selected"
    }));
    
    
    $('#level3').find("option:eq(0)").prop("selected", true);
    
    if (typeof v2 === "undefined"){
    	$('option',  $('#level2')).remove();
    	
    	
	    $('#level2').append($('<option>', { 
	        value: -1,
	        text : "전체",
	        selected : "selected"
	    }));
	    $.each(options2, function (i, item) {
	    	$('#level2').append($('<option>', { 
	            value: item.no,
	            text : item.label 
	        }));
	    });
	    $('#level2').find("option:eq(0)").prop("selected", true);
	    
	  // alert($('#level2').find("option:eq(0)").val());
	  // alert( $("#level2").val());
	  
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
    
};


fnObj.formView01 = axboot.viewExtend(axboot.formView, {
	getDefaultData : function() {
		return $.extend({}, axboot.formView.defaultData, {
			multiLanguageJson : {
				ko : "",
				en : ""
			},
			m_exist: "재고",
			gloss : "해당없음",
			hardness : "해당없음",
			feel : "해당없음",
			pattern : "해당없음",
			brightness : "해당없음",
			shade : "해당없음",
			recommend : "해당없음"
				
		});
	},
	initView : function(oid) {
		
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
		this.initEvent();
		this.initOption();
		
		if(oid != null && oid.length > 0){
			ACTIONS.dispatch(ACTIONS.ITEM_CLICK, oid);
		}else{
			// ACTIONS.dispatch(ACTIONS.INIT_TYPECODE);
		}

	},
	initOption : function(){
		// alert("initOption...");
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
	},
	
	
	
	initEvent : function() {
		var _this = this;
		
		
		$('.js-data-example-ajax').select2({
			ajax: {
			    url: "/api/v1/discompany/searchforSelect",
			    dataType: 'json',
			    delay: 250,
			    data: function (params) {
			      return {
			        filter: params.term, // search term
			        pageNumber: params.page,
			        pageSize : 30
			      };
			    },
			    processResults: function (data, params) {
			    
			    params.page = params.page || 1;

			      
			      
			      return {
			        results: data.list,
			        pagination: {
			          more: (params.page * 30) < data.page.totalElements
			        }
			      };
			    },
			    cache: true
			  },
			  minimumInputLength: 1,
			  language: fnObj.lan
	   });
		
		

		$('.js-data-manufacturerId').select2({
			ajax: {
			    url: "/api/v1/mfcompanys/searchforSelect",
			    dataType: 'json',
			    delay: 250,
			    data: function (params) {
			      return {
			        filter: params.term, // search term
			        pageNumber: params.page,
			        pageSize : 30
			      };
			    },
			    processResults: function (data, params) {
			    
			    params.page = params.page || 1;

			      
			      
			      return {
			        results: data.list,
			        pagination: {
			          more: (params.page * 30) < data.page.totalElements
			        }
			      };
			    },
			    cache: true
			  },
			  minimumInputLength: 1,
			  language:  fnObj.lan
	   });
		
		
	},
	
	
	setOption : function(optionData, selectedData){
    	
   	 
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
    	
    	
    	// alert(selectedData);
    	
    	// this.optionFormat();
    	// $('.js-example-basic-single').val(selectedData).change();
 			
    },
	getData : function() {
		var data = this.modelFormatter.getClearData(this.model.get()); // 모델의
																		// 값을
																		// 포멧팅 전
																		// 값으로
 		var typeOid = "";														        // 치환.
		
		var length2 = $('#level2').children('option').length;
		if(length2  > 1){
			typeOid = $('#level2').val();
		}
		
		var length3 = $('#level3').children('option').length;
		
		if(length3 > 1){
			typeOid = $('#level3').val();
		}
		if(typeOid == -1){
			typeOid = "";
		}
		
		return $.extend({}, data, {
			typeOid : typeOid
		});
		
		
	},
	setData : function(data) {
	
		var _data = this.getDefaultData();
    
		if (!data.multiLanguageJson) {
			_data.multiLanguageJson = {
				ko : "",
				en : data.name
			}
		} else {
			_data.multiLanguageJson = data.multiLanguageJson;
		}
        
		if(data.companyName){
	    	
	    	var arr = [{ id:data.distributionId,
	 		    text: data.companyName
	    		         }];
	    	
	  

	    	$(".js-data-example-ajax").select2({
	            data: arr
	        });
	    	
	    }
		
		if(data.mfCompanyName){
			var arr = [{ id:data.manufacturerId,
	 		    text: data.mfCompanyName
	    		         }];
	  
	    	$(".js-data-manufacturerId").select2({
	            data: arr
	        });
		}
		
		
	
		
		this.model.setModel(data);
		this.modelFormatter.formatting(); // 입력된 값을 포메팅 된 값으로 변경
		
		if(data.typeCode){
			if(data.typeCode.l2){
				$('#level1').val(data.typeCode.l2);
				fnObj.updateCategory($('#level1').val());
			}
			
			if(data.typeCode.l3){
				
				$('#level2').val(data.typeCode.l3);
				fnObj.updateCategory($('#level1').val(), $('#level2').val());
				
			}else if(data.typeCode.level == 2){
				
				$('#level2').val(data.typeCode.codeId);
				fnObj.updateCategory($('#level1').val(), $('#level2').val());
			}
		
			if(data.typeCode.level == 3){
				
				$('#level3').val(data.typeCode.codeId);
			}
			$('#level1').attr("disabled", "disabled");
			$('#level2').attr("disabled", "disabled");
			$('#level3').attr("disabled", "disabled");
		}
		
		
	},
	clear : function() {
		// this.mask.open();
		this.model.setModel(this.getDefaultData());
		
		// $(".js-example-basic-single").select2().val(null).change();
		// this.optionFormat();
	},
	optionFormat: function(){
    	
    	// $("js-example-basic-single").select2({});
    	$(".js-example-basic-single").select2({
    		placeholder: 'Select an option',
			  // width: "600px",
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
