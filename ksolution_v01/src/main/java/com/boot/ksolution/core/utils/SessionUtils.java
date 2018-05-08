package com.boot.ksolution.core.utils;

import javax.servlet.http.HttpServletRequest;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import com.boot.ksolution.core.domain.user.MDCLoginUser;
import com.boot.ksolution.core.domain.user.SessionUser;

public class SessionUtils {
	
	public static UserDetails getCurrentUserDetail() {
		
		try {
			return (UserDetails)SecurityContextHolder.getContext().getAuthentication().getDetails();
		}catch(Exception e) {
			
		}
		return null; 
	}
	
	public static SessionUser getCurrentUser() {
		UserDetails userDetails = getCurrentUserDetail();
		
		if(userDetails != null) {
			if(userDetails instanceof SessionUser) {
				return (SessionUser) userDetails;
			}
		}
		
		return null;
	}
	
	public static MDCLoginUser getCurrentMdcLoginUser(HttpServletRequest request) {
		UserDetails userDetails = getCurrentUserDetail();
		
		if(userDetails != null) {
			SessionUser sessionUser = (SessionUser)userDetails; 
			sessionUser.setUserPs(null);
			MDCLoginUser mdcLoginUser = new MDCLoginUser();
			mdcLoginUser.setSessionUser(sessionUser);
			mdcLoginUser.setUserAgent(AgentUtils.getUserAgent(request));
            mdcLoginUser.setBrowserType(AgentUtils.getBrowserType(request));
            mdcLoginUser.setRenderingEngine(AgentUtils.getRenderingEngine(request));
            mdcLoginUser.setDeviceType(AgentUtils.getDeviceType(request));
            mdcLoginUser.setManufacturer(AgentUtils.getManufacturer(request));
            return mdcLoginUser;
		}
		
		return null;
	}
	
	public static boolean isLoggedIn() {
        return getCurrentUser() != null;
    }
	
	public static String getCurrentLoginUserCd() {
        UserDetails userDetails = getCurrentUserDetail();
        return userDetails == null ? "system" : userDetails.getUsername();
    }
	
}
