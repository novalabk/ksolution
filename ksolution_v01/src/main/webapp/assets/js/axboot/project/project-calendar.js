var fnObj = {};
   
var ACTIONS = axboot.actionExtend(fnObj, {
    EVENT_SEARCH: function (caller, act, data) {
        console.log("data", data);
    	axboot.ajax({
            type: "GET",
            url: ["event"], 
            data: data,
            callback: function (res) {
            	
            	caller.calendarView.setData(res);
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
        	   //ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
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
        	   //ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, { codeId :
				 * caller.formView01.getData().codeId });
				 */
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
        	   //ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, { codeId :
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
        	   //ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, data);
				/*
				 * ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, { codeId :
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
	
	_this.calendarView.initView();
	_this.calendarResize();
	
}
   
   
fnObj.pageButtonView = axboot.viewExtend({
	initView: function () {
	
		axboot.buttonClick(this, "data-page-btn", {
    "save": function () {
    	var vv = $('#calendar').fullCalendar('clientEvents');
    	console.log("vv", vv);
    	
    	$('#calendar').fullCalendar('refetchEvents'); 
    }
	        
	        });
	}
});


fnObj.calendarView = axboot.viewExtend(axboot.commonView, {
	
	target : $('#calendar'),
	callback : function(){},
	oid : "",
	initView: function () {
		var _this = this;
		var isClicked;
		var form = $("#searchView0");
    	var pjt_oid = form.find('[data-ax-path="' + "oid" + '"]').val();
        _this.oid = pjt_oid;
    	
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
		        center: 'title', 
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
	    	  			projectInfoId : _this.oid
                    };
	    	  		
	    	  		_this.callback = callback;
                    var returnData = ACTIONS.dispatch(ACTIONS.EVENT_SEARCH, data); 
		    	   
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
		    		 // real_end = calEvent.end;
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
		    	        	   var sendData ={
		    	        			   projectInfoId: _this.oid,
		    	        			   oid :calEvent.oid};
			    	           
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
		    	  if (event.isHoliday == 'YES') {
		    		  if(event.gcalId){
		    			  element.css('background-color', '#FF0000'); 
		    		  }else{
		    			  element.css('background-color', '#0cbd33');
		    		  }
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
		    	           var sendData ={projectInfoId:_this.oid}
			    	       sendData = $.extend(sendData, data);
			    	       ACTIONS.dispatch(ACTIONS.SAVE_EVENT, sendData)
		    	           this.close();
		    	           
		    	        }
		    	    });
	    	    
	    	    // Other stuff
	    	}, 
	    	
		      
		      loading: function(bool) {
		          //$('#loading').toggle(bool);
		      },
		      
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



