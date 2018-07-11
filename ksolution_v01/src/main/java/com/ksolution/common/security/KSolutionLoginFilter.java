package com.ksolution.common.security;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;
import org.springframework.security.web.util.matcher.RequestMatcher;
import org.springframework.transaction.annotation.Transactional;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.code.ApiStatus;
import com.boot.ksolution.core.domain.user.SessionUser;
import com.boot.ksolution.core.utils.HttpUtils;
import com.boot.ksolution.core.utils.JsonUtils;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ksolution.common.domain.user.UserService;

/**
 * @author jkeei
 * urlMapping에 해당되는 넘만.. attemptAuthentication 시동한다.
 */
public class KSolutionLoginFilter extends AbstractAuthenticationProcessingFilter{

	private final KSolutionTokenAuthenticationService adminTokenAuthenticationService;
	private final KSolutionAuthenticationEntryPoint adminAuthenticationEntryPoint;
	private final UserService userService;

	public KSolutionLoginFilter(String urlMapping, 
			KSolutionTokenAuthenticationService adminTokenAuthenticationService,
			UserService userService, 
			AuthenticationManager authenticationManager,
			KSolutionAuthenticationEntryPoint adminAuthenticationEntryPoint) {
		
		super(new AntPathRequestMatcher(urlMapping));
	    
		this.adminTokenAuthenticationService = adminTokenAuthenticationService;
		this.userService = userService;
		this.adminAuthenticationEntryPoint = adminAuthenticationEntryPoint;
		this.setAuthenticationFailureHandler(new LoginFailureHandler());		
		setAuthenticationManager(authenticationManager);
	}
	
	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		/*System.out.println("call LoginFilter");
		HttpServletRequest request = (HttpServletRequest) req;
		HttpServletResponse response = (HttpServletResponse) res;
		
		String url = request.getServletPath();

		if (request.getPathInfo() != null) {
			url += request.getPathInfo();
		}
		//System.out.println("url ======== " + url);
		//System.out.println(!requiresAuthentication(request, response));*/
		super.doFilter(req, res, chain);
	}

	@Override
	public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
			throws AuthenticationException, IOException, ServletException {
		final SessionUser user = new ObjectMapper().readValue(request.getInputStream(), SessionUser.class);
		final UsernamePasswordAuthenticationToken loginToken = new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword());
		return getAuthenticationManager().authenticate(loginToken);
		
	}

	@Override
	@Transactional
	protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain, Authentication authentication) throws IOException, ServletException {
		final KSolutionUserAuthentication userAuthentication = 
				new KSolutionUserAuthentication((SessionUser) authentication.getPrincipal());
		
		 //쿠키설정하고  SecurityContextHolder.getContext().setAuthentication(userAuthentication); 
		adminTokenAuthenticationService.addAuthentication(response, userAuthentication);
        
		/*로그인 로직은 ajax호출이기에 결과를 json으로 리턴해 준다 */
		response.setContentType(HttpUtils.getJsonContentType(request));
        response.getWriter().write(JsonUtils.toJson(ApiResponse.of(ApiStatus.SUCCESS, "Login Success")));
        response.getWriter().flush();
	}
	
	private class LoginFailureHandler implements AuthenticationFailureHandler{

		@Override
		public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
				AuthenticationException authException) throws IOException, ServletException {
			adminAuthenticationEntryPoint.commence(request, response, authException);
			
		}
		
	}
}
