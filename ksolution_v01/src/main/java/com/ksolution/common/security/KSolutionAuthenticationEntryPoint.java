package com.ksolution.common.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.authentication.www.BasicAuthenticationEntryPoint;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.code.ApiStatus;
import com.boot.ksolution.core.utils.ContextUtil;
import com.boot.ksolution.core.utils.CookieUtils;
import com.boot.ksolution.core.utils.HttpUtils;
import com.boot.ksolution.core.utils.JsonUtils;
import com.boot.ksolution.core.utils.RequestUtils;
import com.ksolution.KSolutionSecurityConfig;
import com.ksolution.common.code.GlobalConstants;

/*로그인 전 Access Deny에 대한 에러를 전달 받아 다시 로그인 페이지로 이등 하는 역할 */
/**
 * @author jkeei
 *
 */

public class KSolutionAuthenticationEntryPoint extends BasicAuthenticationEntryPoint {

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException) throws IOException, ServletException {
		
		CookieUtils.deleteCookie(request, response, GlobalConstants.ADMIN_AUTH_TOKEN_KEY);	
		RequestUtils requestUtils = RequestUtils.of(request);
		
		ApiResponse apiResponse;
		
		if (authException instanceof BadCredentialsException) {
			apiResponse = ApiResponse.error(ApiStatus.SYSTEM_ERROR, "비밀번호가 일치하지 않습니다.");
		} else if(authException instanceof UsernameNotFoundException) {
			apiResponse = ApiResponse.error(ApiStatus.SYSTEM_ERROR, authException.getLocalizedMessage());
		} else {
			apiResponse = ApiResponse.redirect(ContextUtil.getPagePath(KSolutionSecurityConfig.LOGIN_PAGE));
		}
		
		if (requestUtils.isAjax()) {
			response.setContentType(HttpUtils.getJsonContentType(request));
			//System.out.println("JsonUtils.toJson(apiResponse) = " + JsonUtils.toJson(apiResponse));
			response.getWriter().write(JsonUtils.toJson(apiResponse));
            response.getWriter().flush();
		}else {
			response.sendRedirect(ContextUtil.getPagePath(KSolutionSecurityConfig.LOGIN_PAGE));
		}
	}
}
