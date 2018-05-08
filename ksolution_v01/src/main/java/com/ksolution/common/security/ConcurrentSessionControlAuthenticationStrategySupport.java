package com.ksolution.common.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.web.authentication.session.ConcurrentSessionControlAuthenticationStrategy;

public class ConcurrentSessionControlAuthenticationStrategySupport extends ConcurrentSessionControlAuthenticationStrategy {

	public ConcurrentSessionControlAuthenticationStrategySupport(SessionRegistry sessionRegistry) {
		super(sessionRegistry);
		//super.setMaximumSessions(maximumSessions);
		//super.setExceptionIfMaximumExceeded(exceptionIfMaximumExceeded);
	}

	/**
	 * 중복로그인 비활성화인 경우 동시 세션 설정을 수정한다.
	 *
	 * @param duplicationLoginDisable the duplication login disable
	 */
	public void setDuplicationLoginDisable(boolean duplicationLoginDisable) {
		if (duplicationLoginDisable) {
			super.setMaximumSessions(1);
			super.setExceptionIfMaximumExceeded(false);  //새로운 세션이 전세션을 없애고 지가 들어간다.
		}
	}
	
	@Override
	public void onAuthentication(Authentication authentication, HttpServletRequest request, HttpServletResponse response) {
		
		super.onAuthentication(authentication, request, response);
	}
	
}
