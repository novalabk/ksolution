package com.boot.ksolution.core.filters;

import java.io.IOException;
import java.util.Map;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.commons.io.IOUtils;
import org.springframework.core.io.ClassPathResource;

import com.boot.ksolution.core.utils.JsonUtils;


public class KSolutionConfigFilter implements Filter {
	
	private static Map<String, Object> config = null;
	 
	@Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }
	
	@Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
		try {
			if(config == null) {
				config = JsonUtils.fromJsonToMap(IOUtils.toString(new ClassPathResource("ksolution.json").getInputStream(), "UTF-8"));
			}
			servletRequest.setAttribute("config", config);
		} catch (Exception e) {
            e.printStackTrace();
        }

        filterChain.doFilter(servletRequest, servletResponse);
	}

	@Override
    public void destroy() {

    }
	
	public static void main(String args[])throws Exception{
		System.out.println(IOUtils.toString(new ClassPathResource("ksolution.json").getInputStream(), "UTF-8"));
		config = JsonUtils.fromJsonToMap(IOUtils.toString(new ClassPathResource("ksolution.json").getInputStream(), "UTF-8"));
	}
}
