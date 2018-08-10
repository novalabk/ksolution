package com.ksolution.common.utils;


import java.util.List;

import com.boot.ksolution.core.context.AppContextManager;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.calendar.CalendarTemplate;
import com.ksolution.common.domain.calendar.CalendarTemplateService;
import com.ksolution.common.domain.user.UserService;
import com.ksolution.common.domain.user.auth.UserAuthService;

public class CommonUtil {
	public static UserService getUserService() {
        return AppContextManager.getBean(UserService.class);
    }
	
	public static CalendarTemplateService getCalendarTemplateService() {
		return AppContextManager.getBean(CalendarTemplateService.class);
	}
	
	
	public static List<CalendarTemplate> getCalendarTempList(){
		CalendarTemplateService service = getCalendarTemplateService();
		List<CalendarTemplate> list = service.get(new RequestParams<>());
		return list;
	}
}
