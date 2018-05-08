package com.boot.ksolution.core.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import com.boot.ksolution.core.utils.HttpUtils;
import com.boot.ksolution.core.utils.MDCUtil;
import com.boot.ksolution.core.utils.RequestUtils;
import com.boot.ksolution.core.utils.SessionUtils;

public class KSolutionLogbackMdcFilter implements Filter{

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		
	}
	

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		if(!HttpUtils.isMultipartFormData((HttpServletRequest) request)) {
			RequestUtils requestWrapper = RequestUtils.of(request);
			MDCUtil.setJsonValue(MDCUtil.HEADER_MAP_MDC, requestWrapper.getRequestHeaderMap());
			MDCUtil.setJsonValue(MDCUtil.PARAMETER_BODY_MDC, requestWrapper.getRequestBodyJson());
			MDCUtil.setJsonValue(MDCUtil.USER_INFO_MDC, SessionUtils.getCurrentMdcLoginUser((HttpServletRequest) request));
			MDCUtil.set(MDCUtil.REQUEST_URI_MDC, requestWrapper.getRequestUri());
		}
		chain.doFilter(request, response);
	}


	@Override
	public void destroy() {
		
	}

}
