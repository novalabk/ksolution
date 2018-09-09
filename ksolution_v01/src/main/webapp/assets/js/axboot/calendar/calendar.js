var fnObj = {};
   
var ACTIONS = axboot.actionExtend(fnObj, {
    PAGE_SEARCH: function (caller, act, data) {
        
    	axboot.ajax({
            type: "GET",
            url: ["event"], 
            data: data,
            callback: function (res) {
            	console.log("res", res);
            	caller.calendarView.setData(res);
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        });
        return "";
    },
    
    ITEM_CLICK: function (caller, act, data) {
    	caller.calendarView.setTempId(data.oid);
    	$('#calendar').fullCalendar('removeEvents');
        $('#calendar').fullCalendar('refetchEvents');
    },
    
    TEMP_SEARCH: function (caller, act, data) {
    	
    	axboot.ajax({
            type: "GET",
            url: ["calendarTemp"], 
            data: data,
            callback: function (res) {
            	console.log("res", res);
            	caller.calendarListView.setData(res);
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        });
        return "";
    },
    
   
    
    SAVE_EVENT: function (caller, act, data) {
    	axboot.call({
            type: "PUT",
            url: ["event"], 
            data: JSON.stringify(data),
            callback: function (res) {
            	axToast.push("저장 하였습니다.");
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        })
        .done(function() {
        	
        	$('#calendar').fullCalendar('removeEvents');
            $('#calendar').fullCalendar('refetchEvents');
        	   //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
			});
        return "";
    },
    
    DELTE_CALENDARTEMP: function(caller, act, data){
    	//alert(data.id);
    	axboot.call({
            type: "DELETE",
            url: ["calendarTemp", data.id], 
            //data: JSON.stringify(data),
            callback: function (res) {
            	axToast.push("삭제하였습니다.");
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        })
        .done(function() {
        	
        	$('#calendar').fullCalendar('removeEvents');
            $('#calendar').fullCalendar('refetchEvents');
        	   //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
            ACTIONS.dispatch(ACTIONS.TEMP_SEARCH);
			});
        return "";
    },
    
    SAVE_CALENDARTEMP: function (caller, act, data) {
    	
    	axboot.call({
            type: "PUT",
            url: ["calendarTemp"], 
            data: JSON.stringify(data),
            callback: function (res) {
            	axToast.push("저장 하였습니다.");
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        })
        .done(function() {
        	
        	$('#calendar').fullCalendar('removeEvents');
            $('#calendar').fullCalendar('refetchEvents');
        	   //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
            
            ACTIONS.dispatch(ACTIONS.TEMP_SEARCH);
			});
        return "";
    },
    
    
    UPDATE_EVENT: function (caller, act, data) {
    	
    	axboot.call({
            type: "PUT",
            url: ["event", "updatePeriod"], 
            data: JSON.stringify(data),
            callback: function (res) {
            	axToast.push("저장 하였습니다.");
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        })
        .done(function() {
        	
        	$('#calendar').fullCalendar('removeEvents');
            $('#calendar').fullCalendar('refetchEvents');
        	   //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
			});
        return "";
    },
    
    DELETE_EVENT : function (caller, act, data) {
    	
    	axboot.call({
            type: "PUT",
            url: ["event", "delete"], 
            data: JSON.stringify(data),
            callback: function (res) {
            	axToast.push("저장 하였습니다.");
                /*caller.gridView01.setData(res);
                caller.formView01.clear();
                ACTIONS.dispatch(ACTIONS.ROLE_GRID_DATA_INIT, {userCd: "", roleList: []});*/
            }
        })
        .done(function() {
        	
        	$('#calendar').fullCalendar('removeEvents');
            $('#calendar').fullCalendar('refetchEvents');
        	   //ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
			});
        return "";
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
	_this.calendarListView.initView();
	_this.pageButtonView.initView();
	_this.calendarView.initView();
	_this.calendarResize();
	
	ACTIONS.dispatch(ACTIONS.TEMP_SEARCH);
}
   
   
fnObj.pageButtonView = axboot.viewExtend({
	initView: function () {
	        axboot.buttonClick(this, "data-page-btn", {
    "save": function () {
    	//var vv = $('#calendar').fullCalendar('clientEvents');
    	//console.log("vv", vv);
    	
    	$('#calendar').fullCalendar('refetchEvents'); 
    }
	        
	        });
	}
});


fnObj.calendarView = axboot.viewExtend(axboot.commonView, {
	
	target : $('#calendar'),
	callback : function(){},
	tempId : "",
	initView: function () {
		var _this = this;
		var isClicked;
		$('#calendar').fullCalendar({ 
			
			customButtons: { 
			    myCustomButton: {
			      text: 'custom!',
			      click: function() {
			        alert('clicked the custom button!');
			      }
			    }
			},  
			
			header: {
		        left: 'prev,next today',
		        center: 'title myCustomButton', 
		        right: 'month'
		        //right: 'month,agendaWeek,agendaDay,listMonth'
		      },
		     // defaultDate: '2018-03-12', 
		      navLinks: true, // can click day/week names to navigate views
		      businessHours: true, // display business hours 
		      editable: true,
		      selectable: true,
		
		      
		      events:  function(start, end, timezone, callback) {
		    	    
	    	  		var data = {
	    	  			start : start.format("YYYY/MM/DD"),
	    	  			end : end.format("YYYY/MM/DD"),
	    	  			tempId : _this.tempId
                    };
	    	  		
	    	  		_this.callback = callback;
                    var returnData = ACTIONS.dispatch(ACTIONS.PAGE_SEARCH, data); 
		    	   
		      },
		      
		      eventClick: function(calEvent, jsEvent, view) {

		    	   /* alert('Event: ' + calEvent.title);
		    	    alert('Coordinates: ' + jsEvent.pageX + ',' + jsEvent.pageY);
		    	    alert('View: ' + view.name);*/
		    	  
		    	   // console.log("calEventstart", calEvent.start);
		    	 
		    	  if(calEvent.gcalId){
						axDialog.alert({
							theme : "primary",
							msg : "수정할수없습니다."
						});
						return;
		    	  }
		    	  
		    	  var real_end;
		    	  
		    	  if(calEvent.end == undefined){
		    		  real_end = calEvent.start;
		    	  }else{
		    		  //real_end = calEvent.end;
		    		  real_end = moment(calEvent.end).add(-1, 'days');
		    	  }
		    	  
		    	   axboot.modal.open({
		    	        modalType: "SAVE_HOLIDAY",                                  
		    	        param: "oid=" + calEvent.oid ,
		    	        header:{title:LANG("ax.script.ks.20")},
		    	        sendData: function(){
		    	            return {
		    	              title : calEvent.title,
		    	              start : moment(calEvent.start).format("YYYY-MM-DD"),
			    	  		  end : moment(real_end).format("YYYY-MM-DD"),
			    	  		  description : calEvent.description,
			    	  		  isHoliday : calEvent.isHoliday
		    	            };
		    	        },
		    	        callback: function (data) {
		    	           //console.log("data " , data);
		    	           //saveGanttData(data, isSaveAs);
		    	           if(data.action == 'save'){
		    	        	   var sendData ={oid :calEvent.oid, tempId : _this.tempId}; 
			    	           
			    	           sendData = $.extend(sendData, data);
			    	         
			    	           ACTIONS.dispatch(ACTIONS.SAVE_EVENT, sendData);

		    	           }else if(data.action == 'delete'){
		    	        	   ACTIONS.dispatch(ACTIONS.DELETE_EVENT, data);
		    	           }	
		    	           		    	           
		    	           this.close();
		    	           
		    	        }
		    	    });

		    	   
		    	    //parent.axboot.modal.getData()
		    	    // change the border color just for fun
		    	   // $(this).css('border-color', 'red');

		    },
		      
		    eventDrop: function(event, delta, revertFunc) {

		    	var data = {
			            oid : event.oid,		 
			        	start: moment(event.start).format("YYYY-MM-DD"),
			        	end: moment(event.end).format("YYYY-MM-DD"),
			            
			    	  };
			    	  ACTIONS.dispatch(ACTIONS.UPDATE_EVENT, data);

		      },
		      eventResize: function(event, delta, revertFunc) {
		    	  var data = {
		            oid : event.oid,		 
		        	start: moment(event.start).format("YYYY-MM-DD"),
		        	end: moment(event.end).format("YYYY-MM-DD"),
		            
		    	  };
		    	  ACTIONS.dispatch(ACTIONS.UPDATE_EVENT, data);
		    	 
		      },
		      eventRender: function (event, element, view) {
		    	  /*if (view.name == 'listDay') {
		                element.find(".fc-list-item-time").append("<span class='closeon'>X</span>");
		            } else {
		                element.find(".fc-content").prepend("<span class='closeon'>X</span>");
		            }
		            element.find(".closeon").on('click', function () {
		            	axDialog.confirm({
		    	    	    msg: LANG("ax.script.deleteconfirm")
		    	    	}, function () {
		    	    	    if (this.key == "ok") {
		    	    	    	ACTIONS.dispatch(ACTIONS.DELETE_EVENT, event);
		    	    	    }
		    	    	});
		            });*/
		    	  //console.log("event.isHoliday ", event.isHoliday);
		    	  if (event.isHoliday == 'YES') {
	                   // event.eventColor =  "#B22222";
	                    //event.eventBackColor = "#FF0000";    
		    		  //element.css('color', '#B22222');
		    		  
		    		  if(event.gcalId){
		    			  element.css('background-color', '#FF0000'); 
		    		  }else{
		    			  element.css('background-color', '#0cbd33');
		    		  }
		    		  
		    		  
	                   // element.text(element.text);
	               }else{
	            	   //event.eventColor =  "#B22222";
	                   //event.eventBackColor = "#B22222";     
	            	  
	                   //element.css('color', '#B22222');
	                  // element.css('background-color', '#B22222');
	                  // element.text(element.text);
	               }
		      },
		      
		     
		      
		      dayClick: function(date, jsEvent, view) {
		    	    if(isClicked){
		    	        isDblClicked = true;
		    	        isClicked = false;
		    	    }
		    	    else{
		    	        isClicked = true;
		    	    }
		    	    setTimeout(function(){
		    	        isClicked = false;
		    	    }, 250);
		     },
		     
	    	 select: function(start, end, jsEvent){
	    	    if(isClicked){
	    	        //$('#calendar').fullCalendar('unselect');
	    	        return;
	    	    }
	    	    
	    	    
	    	    
	    	    var real_end = moment(end).add(-1, 'days');
		    	  
		    	  axboot.modal.open({
		    	        modalType: "SAVE_HOLIDAY",                                  
		    	        param: "",
		    	        header:{title:LANG("ax.script.ks.20")},
		    	        sendData: function(){
		    	            return { 
		    	            	start : moment(start).format("YYYY-MM-DD"),
		    	            	end : moment(real_end).format("YYYY-MM-DD")
		    	            };
		    	        },
		    	        callback: function (data) {
		    	           var sendData ={tempId:_this.tempId}
			    	       sendData = $.extend(sendData, data);
			    	       ACTIONS.dispatch(ACTIONS.SAVE_EVENT, sendData);
		    	           this.close();
		    	           
		    	        }
		    	    });
	    	    
	    	    // Other stuff
	    	}, 
	    	
		      
		      loading: function(bool) {
		          //$('#loading').toggle(bool);
		      },
		      
		      
		      /*eventAllow: function(dropLocation, draggedEvent) {
		    	  if (draggedEvent.gcalId) { 
		    	    return false
		    	  }
		    	  else {
		    	    return true; // or return false to disallow
		    	  }
		    	}*/
		      
		     // eventColor: '#FF0000'
		      
		});
		
		$('#calendar').fullCalendar('option', 'locale', 'ja');
		
	},
	
	setData : function(res){
		var _this = this;
		_this.callback(res.list);
	},
	
	dblClickFunction : function(start){
		alert(start);
	},
	
	setTempId : function(tempId){
		var _this = this;
		_this.tempId = tempId;
	}
	

});


fnObj.calendarListView = axboot.viewExtend(axboot.gridView, {
    initView: function () {
        var _this = this;
        
        
        
        
        this.target = axboot.gridBuilder({
        	sortable: true,
            //showRowSelector: true,
            frozenColumnIndex: 0,
            sortable: true,
            //multipleSelect: true,
            target: $('[data-ax5grid="grid-view-01"]'),
            
            columns: [
               
                {
                    key: "calendarNm",
                    label: "이름",
                    width: 120,
                    editor: "text"
                },
                
                {key: "generatedcreatedAt", 
                	label:'등록일',
                	width : 160,
                	formatter : function() {
					if (this.value)
						return ax5.util.date(new Date(this.value || ""), {
							"return" : 'yyyy-MM-dd hh:mm' 
						});
						return this.value;
                	}
                }, 
                {
                	key: "description",
                	label: "설명", 
                	width : 200
                },
//                {key: "useYn", label:COL("ax.admin.use.or.not")}
            ], 
            body: {
                onClick: function () {
                   // this.self.select(this.dindex);
                  /*  var data = this.list[this.dindex];
                    fnObj.calendarView.setTempId(data.oid);
                	$('#calendar').fullCalendar('removeEvents');
                    $('#calendar').fullCalendar('refetchEvents');*/ 
                    ACTIONS.dispatch(ACTIONS.ITEM_CLICK, this.list[this.dindex]);
                },
                onDBLClick : function() {
                	alert("kkk"); 
                }
            },
            contextMenu: {
                iconWidth: 20,
                acceleratorWidth: 100,
                itemClickAndClose: false,
                icons: {
                    'arrow': '<i class="fa fa-caret-right"></i>'
                },
                items: [
                    {type: 1, label: "edit"},
                    {divide: true},
                    {type: 2, label: "delete"},
                    /*{divide: true},
                    {
                        label: "Tools",
                        items: [
                            {type: 1, label: "Ping"},
                            {type: 1, label: "SSH"},
                            {type: 1, label: "Telnet"},
                            {type: 1, label: "Winbox"},
                            {type: 1, label: "FileZilla Check SWF Hang"},
                            {label: "FileZilla IS_FILES"},
                            {label: "FileZilla CPU"}
                        ]
                    },
                    {
                        label: "Config",
                        items: [
                            {label: "ssh"},
                            {type: 1, label: "ftp"},
                            {type: 1, label: "winbox"}
                        ]
                    }*/
                ],
                popupFilter: function (item, param) {
                    //console.log(item, param);
                    if(param.element) {
                        return true;
                    }else{
                        return item.type == 1;
                    }
                },
                onClick: function (item, param) {
                    //console.log("param", param); 
                    if(item.label == 'delete'){
                    	
                    	axDialog.confirm({
		    	    	    msg: LANG("ax.script.deleteconfirm")
		    	    	}, function () {
		    	    	    if (this.key == "ok") {
		    	    	    	ACTIONS.dispatch(ACTIONS.DELTE_CALENDARTEMP, param.item);
		    	    	    }
		    	    	});
                    	
                    }else if(item.label == 'edit'){
                    	
                    	_this.openModal(param.item);
                    	
                    }
                    return true;
                    //또는 return true;
                }
            }
        });
        
        
        axboot.buttonClick(this, "data-form-view-01-btn", {
            "create": function () {
            	_this.openModal();
            },
            
            "delete" : function(){
            	alert("delete");
            }
        });
    },
    
    openModal: function(calTempData){
    	axboot.modal.open({
	        modalType: "SaveCalendarTemplate",                                  
	        param: "" ,
	        header:{title:LANG("ax.script.ks.20")},
	        sendData: function(){
	            return calTempData;
	        },
	        callback: function (data) {
	            
	           //saveGanttData(data, isSaveAs);
	           /*if(data.action == 'save'){
	        	   var sendData ={oid :calEvent.oid};
    	           
    	           sendData = $.extend(sendData, data);
    	         
    	           ACTIONS.dispatch(ACTIONS.SAVE_EVENT, sendData);

	           }else if(data.action == 'delete'){
	        	   ACTIONS.dispatch(ACTIONS.DELETE_EVENT, data);
	           }*/
	           var sendData = {multiLanguageJson: {
	        	   	ko: "", en: "", jp: ""
	           	}};			
	           sendData = $.extend(sendData, data);
	           console.log("sendData " , sendData);
	           ACTIONS.dispatch(ACTIONS.SAVE_CALENDARTEMP, sendData); 
	           this.close();
	           
	        }
	        
	        
	       
	    });
    },
    
    setData: function (_data) {
        this.target.setData(_data);
    },
    getData: function () {
        return this.target.getData();
    },
    
    getSelectId: function(){
    	//this.target.
    },
    
    align: function () {
        this.target.align();
    }
});

fnObj.pageResize = function(){
	var _this = this;
	_this.calendarResize();
}

fnObj.calendarResize = function(){
	var calHeight = $(window).height() - 100;
    $('#calendar').fullCalendar('option', 'height', calHeight);
}



