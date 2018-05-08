package com.ksolution.common.security;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.web.filter.GenericFilterBean;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.utils.ContextUtil;
import com.boot.ksolution.core.utils.CookieUtils;
import com.boot.ksolution.core.utils.HttpUtils;
import com.boot.ksolution.core.utils.JsonUtils;
import com.boot.ksolution.core.utils.RequestUtils;
import com.ksolution.KSolutionSecurityConfig;
import com.ksolution.common.code.GlobalConstants;

/**
 * 인증체크 필터 이다.
 * @author jkeei
 *
 */
public class KSolutionAuthenticationFilter extends GenericFilterBean {

	private final KSolutionTokenAuthenticationService tokenAuthenticationService;
	
	private static Object lock = new Object();
	
	public KSolutionAuthenticationFilter(KSolutionTokenAuthenticationService adminTokenAuthenticationService) {
	    this.tokenAuthenticationService = adminTokenAuthenticationService;
	}
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        try {
        	//System.out.println("kkk...");
        	
        	Authentication auth = tokenAuthenticationService.getAuthentication(request, response); //쿠키를 통행 인증을 가져온다.
        	
//        	System.out.println("AuthenticationFilter = " + auth);        	
//        	System.out.println("matches = " + new AntPathRequestMatcher("/api/login").matches(request));
       	
        	
        	SecurityContextHolder.getContext().setAuthentication(auth);
        	
        	chain.doFilter(req, res);
        	
        }catch(AccessDeniedException e) {
        	RequestUtils requestUtils = RequestUtils.of(request);
        	String rpage = KSolutionSecurityConfig.ACCESS_DENIED_PAGE;
        	if(e instanceof UserValidateException) {
        		CookieUtils.deleteCookie(request, response, GlobalConstants.ADMIN_AUTH_TOKEN_KEY);
            	rpage = KSolutionSecurityConfig.USER_VALIDATE;
        	} else {
        		
        	}
        	if(requestUtils.isAjax()) {
        		ApiResponse apiResponse = new ApiResponse();
        		apiResponse.setMessage("접근권한이 없습니다.");
        		response.setContentType(HttpUtils.getJsonContentType(request));
        		response.getWriter().write(JsonUtils.toJson(apiResponse));
                response.getWriter().flush();
        	}else {
                response.sendRedirect(ContextUtil.getPagePath(rpage));
            }
        }
	}

}
