package com.ksolution.common.domain.calendar;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.BaseService;
import com.ksolution.common.domain.user.User;
import com.querydsl.core.BooleanBuilder;

@Service
public class CalendarEventService extends BaseService<CalendarEvent, Long>{
	
	private CalendarEventRepository eventRepository;
	
	@Inject
	public CalendarEventService(CalendarEventRepository eventRepository) {
		super(eventRepository);
		this.eventRepository = eventRepository;
	}

	public List<CalendarEvent> get(RequestParams requestParams) {
		// TODO Auto-generated method stub
		String tempId = requestParams.getString("tempId");
		String projectInfoId = requestParams.getString("projectInfoId");
		
		System.out.println("get== projectInfoId " +  projectInfoId);
		System.out.println("get== tempId " +  tempId);
		
		
		if(StringUtils.isEmpty(tempId) && StringUtils.isEmpty(projectInfoId)) {
			return new ArrayList<CalendarEvent>();
		}
		
		
		BooleanBuilder builder = new BooleanBuilder();
		
		if(!StringUtils.isEmpty(tempId)) {
			System.out.println("tempQuery");
			builder.and(qCalendarEvent.tempId.eq(Long.parseLong(tempId)));
		}
		
		if(!StringUtils.isEmpty(projectInfoId)) {
			System.out.println("projectInfoId");
			builder.and(qCalendarEvent.projectInfoId.eq(Long.parseLong(projectInfoId)));
		}
		
		List<CalendarEvent> list = select().from(qCalendarEvent).where(builder).orderBy(qCalendarEvent.createdAt.asc()).fetch();
		
		return list;
	}
	
}
