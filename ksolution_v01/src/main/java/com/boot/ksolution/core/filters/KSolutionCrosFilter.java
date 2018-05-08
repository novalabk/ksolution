package com.boot.ksolution.core.filters;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

/**
 * X-Frame-Options 을 통해 브라우저가 <frame>, <iframe> 혹은 <object> 태그를 렌더링 해야하는지 막아야하는지를 알려준다.
   X-Frame-Options 은 다음 세가지 값 중 하나를 사용할 수 있다. 

   DENY	 해당 페이지는 frame 내에서 표시할 수 없다. 
   SAMEORIGIN	 해당 페이지와 동일한 orgin에 해당하는 frame 내에서 표시를 허용한다.
   ALLOW-FROM uri	 해당 페이지는 지정된 orgin에 해당하는 frame 내에서 표시할 수 있다.
 * @author jkeei
 *
 */
public class KSolutionCrosFilter implements Filter {
	@Override
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        response.setHeader("X-Frame-Options", "SAMEORIGIN");
        filterChain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {

    }
}
