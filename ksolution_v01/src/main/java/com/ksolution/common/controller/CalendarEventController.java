package com.ksolution.common.controller;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.calendar.CalendarEvent;
import com.ksolution.common.domain.calendar.CalendarEventService;
import com.ksolution.common.domain.calendar.GanttHolidayVo;
import com.ksolution.common.domain.calendar.SimpleEventVo;
import com.ksolution.common.domain.gantt.ProjectInfo;

@Controller
@RequestMapping(value = "/api/v1/event")
public class CalendarEventController extends BaseController {
	
	@Inject
	CalendarEventService eventService;
	
	@RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse list(RequestParams requestParams){
	
		List<CalendarEvent> events = new ArrayList<>();
		
		//String tempId = requestParams.getString("tempId");
		//String projectInfoId = requestParams.getString("projectInfoId");
		
		/*if(StringUtils.isEmpty(tempId)) {
			return Responses.ListResponse.of(events);
		}*/
		
		String start = requestParams.getString("start");
		String end = requestParams.getString("end");
		
		
		
		//DateFormat format = new SimpleDateFormat("yyyy/MM/dd");
		
		System.out.println("start = " + start);
		System.out.println("end = " + end);
		
		Calendar c = Calendar.getInstance();
		c.set(c.HOUR_OF_DAY, 23);
		//c.add(c., amount);
		c.add(c.DATE, 1);
	
		
		
		CalendarEvent event = new CalendarEvent();
		Instant startDate = Instant.ofEpochMilli(new Date().getTime());
		Instant endDate = Instant.ofEpochMilli(c.getTimeInMillis());
		event.setTitle("KHKIM");
		event.setStartDate(startDate);
		event.setEndDate(endDate);
		events.add(event); 
		
		events = eventService.get(requestParams);
		
		System.out.println("events.size() = " + events.size()); 
		
		return Responses.ListResponse.of(events);
	}
	
	@RequestMapping(method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse save(@RequestBody CalendarEvent event) throws Exception{
		eventService.save(event);
		return ok();
	}
	
	
	@RequestMapping(value ="/updatePeriod", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse update(@RequestBody SimpleEventVo simpleEvent) {
		CalendarEvent event = eventService.getOne(simpleEvent.getOid());
		event.setStartDate(simpleEvent.getStartDate());
		event.setEndDate(simpleEvent.getEndDate());
		eventService.save(event);
		return ok();
	}
	 
	
	@RequestMapping(value = "/delete", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse delete(@RequestBody CalendarEvent event) {
		eventService.delete(event);
		return ok();
	}
	
	@RequestMapping(value="/holiday", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public List<GanttHolidayVo> getHoliday(RequestParams requestParams){
		List<GanttHolidayVo> list = new ArrayList<>();
		
		List<CalendarEvent> events = eventService.get(requestParams);
	    Map<String, String> exMap = getNotHoliday(events);
		
	    List<GanttHolidayVo> weekList = findWeekendsList(exMap);
	    list.addAll(weekList);
	    
	    for(CalendarEvent event: events) {
			List<GanttHolidayVo> volist = getCalendarList(event, exMap);
			list.addAll(volist);
		}
		
		
		
		return list; 
	}
	
	SimpleDateFormat simpleFormat = new SimpleDateFormat("yyyyMMdd");
	
	private Map<String, String> getNotHoliday(List<CalendarEvent> events){
		
		List<GanttHolidayVo> list = new ArrayList<>();
		
		for(CalendarEvent event: events) {
			if(event.getIsHoliday() == KSolutionTypes.IsHoliday.YES) {
				continue;
			}
			
			List<GanttHolidayVo> volist = getCalendarList(event);
			list.addAll(volist);
		}
		Map<String, String> map = new HashMap();
		
		System.out.println("list == " + list.size());
		
		for(GanttHolidayVo vo: list) {
			String key = simpleFormat.format(vo.getStart());
			
			System.out.println("key == " + key);
			map.put(key, key);
		}
		
		return map;
		
	}
	
	private List<GanttHolidayVo> getCalendarList(CalendarEvent event){
		return getCalendarList(event, new HashMap<String, String>());
	}
	
	private List<GanttHolidayVo> getCalendarList(CalendarEvent event, Map<String, String> exMap){
		
		List<GanttHolidayVo> list = new ArrayList<>();
		
		Date start = Date.from(event.getStartDate());
		Date end = null;
		if(event.getEndDate() != null) {
			Instant minusInstant =  event.getEndDate().minus(Duration.ofDays(1));
			end = Date.from(minusInstant);
		}else {
			end = start;
		}
		
		Calendar c = Calendar.getInstance();
		c.setTime(start);
		
		//System.out.println("c.before(end) " + (c.getTime().getTime() <= end.getTime()));
		//System.out.println("c.after(end) " + c.getTime().after(end));
		
		while(c.getTime().getTime() <= end.getTime()) {
			GanttHolidayVo vo = new GanttHolidayVo();
			
			String date = simpleFormat.format(c.getTime());
			if(exMap.containsKey(date)) {
				c.add(Calendar.DAY_OF_YEAR, 1);
				continue;
			}
			
			vo.setStart(c.getTime());
			vo.setEnd(c.getTime());
			vo.setText(event.getTitle());
			list.add(vo);
			c.add(Calendar.DAY_OF_YEAR, 1);
		}
		
		return list;
		
	}
	
	
	private static DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy/MM/dd");

	private List<GanttHolidayVo> findWeekendsList(Map<String, String> exMap)
	{
		List<GanttHolidayVo> weekendList = new ArrayList();
	    Calendar calendar = null;
	    calendar = Calendar.getInstance();
	    calendar.add(Calendar.YEAR, -2);
	    
	    Calendar end = Calendar.getInstance();
	    
	    end.add(Calendar.YEAR, 2);
	    
	    // The while loop ensures that you are only checking dates in the current year
	    while(calendar.before(end)){
	        // The switch checks the day of the week for Saturdays and Sundays
	        switch(calendar.get(Calendar.DAY_OF_WEEK)){
	        case Calendar.SATURDAY:
	        case Calendar.SUNDAY:
	            //weekendList.add(calendar.getTime());
	            
	        	GanttHolidayVo vo = new GanttHolidayVo();
				
				String date = simpleFormat.format(calendar.getTime());
				if(exMap.containsKey(date)) {
					//calendar.add(Calendar.DAY_OF_YEAR, 1);
					//continue;
					System.out.println("continue..................");
					break;
				}
				
				vo.setStart(calendar.getTime());
				vo.setEnd(calendar.getTime());
				vo.setText("");
				weekendList.add(vo);
				
	        	break;
	        }
	        // Increment the day of the year for the next iteration of the while loop
	        calendar.add(Calendar.DAY_OF_YEAR, 1);
	    }
	    
	    return weekendList;
	}
	
	
	/*var exceptDays = [{
		"start" : "2017/07/05",
		"end" : "2017/07/06",
		"text" : "임시 연휴"
	}, {
		"start" : "2017/07/20",
		"end" : "2017/07/20",
		"text" : "임시 휴일"
	}];
		
	
	// 간트의 달력 설정
	AUIGantt.setCalendarProps(myGanttID, {
		"startHour" : 9,
		"endHour" : 18,
		"sunday" : true,
		"saturday" : false,
		"exceptDays" : exceptDays
	});*/
}
