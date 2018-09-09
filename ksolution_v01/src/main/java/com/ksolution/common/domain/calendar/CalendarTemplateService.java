package com.ksolution.common.domain.calendar;

import java.util.List;

import javax.inject.Inject;
import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.BaseService;
import com.ksolution.common.utils.GoogleCalendarService;

@Service
public class CalendarTemplateService extends BaseService<CalendarTemplate, Long>{
	
	private CalendarTemplateRepository  calendarTemplateRepository;
	
	@Inject
	private CalendarEventService calendarEventService;
	
	@Inject
	public CalendarTemplateService(CalendarTemplateRepository calendarTemplateRepository) {
		super(calendarTemplateRepository);
		this.calendarTemplateRepository = calendarTemplateRepository;
		
	}
	
	@Transactional
	public CalendarTemplate saveCalendarTemplate(CalendarTemplate calendarTemp)throws Exception{
		if(calendarTemp.isNew()) {
			
			calendarTemp = save(calendarTemp);
			
			List<CalendarEvent> events = GoogleCalendarService.getEventList(calendarTemp.getGoogleCalendarId(), calendarTemp.getId());
			
			calendarEventService.save(events);
			 
		}else {
			calendarTemp = save(calendarTemp);
		}
		
		return calendarTemp;
	}

	public List<CalendarTemplate> get(RequestParams requestParams) {
		String filter = requestParams.getString("filter");
		
		List<CalendarTemplate> list = select().from(qCalendarTemplate).orderBy(qCalendarTemplate.createdAt.asc()).fetch();
		if (isNotEmpty(filter)) {
            list = filter(list, filter);
        }
        return list;
		
	}
	
	
	
	@Transactional
	public void delete(Long id) {
		RequestParams params = new RequestParams<>();
		params.put("tempId", String.valueOf(id));
		List<CalendarEvent> clist = calendarEventService.get(params);
		calendarEventService.delete(clist);
		super.delete(id);
	}
}
