package com.ksolution.common.controller;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.calendar.CalendarTemplate;
import com.ksolution.common.domain.calendar.CalendarTemplateService;
import com.ksolution.common.domain.user.User;

@Controller
@RequestMapping(value = "/api/v1/calendarTemp")
public class CalendarTempController extends BaseController{
	
	@Inject
	CalendarTemplateService calendarTempService;
	
	@RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse list(RequestParams requestParams){
		List<CalendarTemplate> tempList = calendarTempService.get(requestParams); 
		return Responses.ListResponse.of(tempList);
	}
	
	
	@RequestMapping(method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse save(@RequestBody CalendarTemplate calendarTemp) throws Exception{
		calendarTempService.saveCalendarTemplate(calendarTemp);
		//calendarTempService.save(calendarTemp);
		return ok();
	}
	
	
	@RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = APPLICATION_JSON)
	public ApiResponse delete(@PathVariable(value = "id") Long id) throws Exception{
		calendarTempService.delete(id);
		//calendarTempService.save(calendarTemp);
		return ok();
	}
	
	
}
