package com.boot.ksolution.core.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import com.boot.ksolution.core.servlet.MultiReadableHttpServletRequest;
import com.boot.ksolution.core.utils.HttpUtils;


public class MultiReadableHttpServletRequestFilter implements Filter{

	@Override
	public void destroy() {
		
	}

	@Override
	public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
			throws IOException, ServletException {
		if (!HttpUtils.isMultipartFormData((HttpServletRequest) req)) {
            MultiReadableHttpServletRequest multiReadRequest = new MultiReadableHttpServletRequest((HttpServletRequest) req);
            chain.doFilter(multiReadRequest, res);
        } else {
            chain.doFilter(req, res);
        }
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		
		
	}

}
