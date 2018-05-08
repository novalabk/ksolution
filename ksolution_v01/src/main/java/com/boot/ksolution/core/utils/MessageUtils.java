package com.boot.ksolution.core.utils;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.context.MessageSource;

import com.boot.ksolution.core.context.AppContextManager;

public class MessageUtils {

    public static MessageSource messageSource = null;

    public static String getMessage(HttpServletRequest request, String id, String arguments) {
        String message = null;

        try {
            if (messageSource == null) {
                messageSource = AppContextManager.getBean(MessageSource.class);
            }

            Locale locale = RequestUtils.getLocale(request);


            if (StringUtils.isNotEmpty(arguments)) {
                message = messageSource.getMessage(id, arguments.split(","), locale);
            } else {
                message = messageSource.getMessage(id, null, locale);
            }
        } catch (Exception e) {
        }

        return message;
    }

    public static String getMessage(HttpServletRequest request, String id) {
        return getMessage(request, id, null);
    }
    
    public static String getMessage(String id, String argumensts) {
    	HttpServletRequest request = HttpUtils.getCurrentRequest();
    	return getMessage(request, id, argumensts);
    }
    
    public static String getMessage(String id) {
    	return getMessage(id, null);
    }
    
}