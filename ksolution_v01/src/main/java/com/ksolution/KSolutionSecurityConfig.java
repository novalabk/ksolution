package com.ksolution;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.builders.WebSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.session.SessionRegistryImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.authentication.logout.CookieClearingLogoutHandler;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;
import org.springframework.security.web.authentication.session.CompositeSessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.RegisterSessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.SessionAuthenticationStrategy;
import org.springframework.security.web.authentication.session.SessionFixationProtectionStrategy;
import org.springframework.security.web.session.ConcurrentSessionFilter;
import org.springframework.security.web.session.HttpSessionEventPublisher;
import org.springframework.security.web.session.SimpleRedirectSessionInformationExpiredStrategy;

import com.boot.ksolution.core.filters.KSolutionLogbackMdcFilter;
import com.boot.ksolution.core.utils.CookieUtils;
import com.ksolution.common.code.GlobalConstants;
import com.ksolution.common.domain.user.UserService;
import com.ksolution.common.security.ConcurrentSessionControlAuthenticationStrategySupport;
import com.ksolution.common.security.KSolutionAuthenticationEntryPoint;
import com.ksolution.common.security.KSolutionAuthenticationFilter;
import com.ksolution.common.security.KSolutionLoginFilter;
import com.ksolution.common.security.KSolutionTokenAuthenticationService;
import com.ksolution.common.security.KSolutionUserDetailsService;

@EnableWebSecurity
@EnableGlobalMethodSecurity(securedEnabled = true, proxyTargetClass = true)
@Configuration
public class KSolutionSecurityConfig extends WebSecurityConfigurerAdapter {
	
	public static final String LOGIN_API = "/api/login";
	public static final String LOGOUT_API = "/api/logout";
    public static final String LOGIN_PAGE = "/jsp/login.jsp";
    public static final String ACCESS_DENIED_PAGE = "/jsp/common/not-authorized.jsp?errorCode=401";
    public static final String USER_VALIDATE = "/jsp/common/userValidate.jsp?errorCode=401";
    public static final String ROLE = "ASP_ACCESS";
    public static final String DuplicationPAGE = "/KLogin/Duplication";
    
    @Inject
    private KSolutionUserDetailsService userDetailsService;
    
    @Inject
    private UserService userService;

    @Inject
    private BCryptPasswordEncoder byCryptPasswordEncoder;
    
    @Inject
    private KSolutionTokenAuthenticationService tokenAuthenticationService;
    

    
    public static final String[] ignorePages = new String[] {
    		"/resources/**",
            "/axboot.config.js",
            "/assets/**",
            "/webjars/**",
            "/grid/**",
            "/gantt/**",
            "/jsp/common/**",
            "/jsp/setup/**",
            "/swagger-ui.html",            //swagger
            "/swagger-resources/**",       //swagger
            "/v2/api-docs/**",			   //swagger						
            "/webjars/**",
            "/api-docs/**", 
            "/setup/**",
            "/h2-console/**",
            "/health"
            //"/coding/**",
            //"/demo/**"
    };
	
    public KSolutionSecurityConfig() {
		super(true);
	}
    
    @Override
    public void configure(WebSecurity webSecurity) throws Exception {
    //	org.springframework.boot.autoconfigure.web.WebMvcAutoConfiguration
        webSecurity.ignoring().antMatchers(ignorePages);
    }
    
    @Override
    protected void configure(HttpSecurity http) throws Exception {
    	
    	KSolutionAuthenticationEntryPoint entryPoint = new KSolutionAuthenticationEntryPoint();
    	// /api/login 요청에만  유저 패스워드 이름을 가지고 인증을 필터링 한다 */
    	KSolutionLoginFilter loginFilter = new 
    			KSolutionLoginFilter(LOGIN_API,    
    					tokenAuthenticationService,
    					userService,
    					authenticationManager(),
    					entryPoint
    					);
    	// 로그인 성공시 sessionStrategy Authentication저장해준다.
    	//loginFilter.setSessionAuthenticationStrategy(sessionStrategy);
    	
    	// 로그인 요청외의 모든 페이지 쿠키 인증 검사 
    	KSolutionAuthenticationFilter authfilter = new KSolutionAuthenticationFilter(tokenAuthenticationService);
    	
    	//sessionStrategy.onAuthentication(auth, request, response); 이렇게 처리해주면 된다.
    
    	
    	http
    	.anonymous()
        .and()
        .authorizeRequests()
        .anyRequest().hasRole(ROLE)  //어떤 요청도 Role(ASP_ACCESS)을 가져야한다.
        .antMatchers(HttpMethod.POST, LOGIN_API).permitAll()
        .antMatchers(LOGIN_PAGE).permitAll()
        .and()
        .formLogin().loginPage(LOGIN_PAGE).permitAll()
        .and()
        .logout().logoutUrl(LOGOUT_API).deleteCookies(GlobalConstants.ADMIN_AUTH_TOKEN_KEY, GlobalConstants.LAST_NAVIGATED_PAGE)
        .logoutSuccessHandler(new LogoutSuccessHandler(LOGIN_PAGE))
        .and()
        .exceptionHandling().authenticationEntryPoint(entryPoint)
        .and()
       //expired session을 사전에 체크하여 로그아웃 시킴 duplication 로그인 처리로 사용했음. 
        //.addFilterBefore(concurrentSessionFilter(), UsernamePasswordAuthenticationFilter.class)
        .addFilterBefore(loginFilter, UsernamePasswordAuthenticationFilter.class)
        .addFilterBefore(authfilter, UsernamePasswordAuthenticationFilter.class)
        //Mdc 라고 각 유저마다의 client 정보를 기록한다 로그 찍을 떼 사용 될 수 있다.
        .addFilterAfter(new KSolutionLogbackMdcFilter(), UsernamePasswordAuthenticationFilter.class);
        ;                 
         //   .and()
        //.httpBasic();         
    }
    
    @Bean
    @Override
    public AuthenticationManager authenticationManagerBean() throws Exception {
        return super.authenticationManagerBean();
    }
    
    
    
    @Bean
    public DaoAuthenticationProvider daoAuthenticationProvider() {
        DaoAuthenticationProvider daoAuthenticationProvider = new DaoAuthenticationProvider();
        daoAuthenticationProvider.setUserDetailsService(userDetailsService);
        daoAuthenticationProvider.setPasswordEncoder(byCryptPasswordEncoder);
        daoAuthenticationProvider.setHideUserNotFoundExceptions(false);
        return daoAuthenticationProvider;
    }
    
    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(daoAuthenticationProvider());
    }
    
    @Override
    protected KSolutionUserDetailsService userDetailsService() {
        return userDetailsService;
    }
    
    class LogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {
    	public LogoutSuccessHandler(String defaultTargetURL) {
            this.setDefaultTargetUrl(defaultTargetURL);
        }
    	@Override
    	public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {
    		CookieUtils.deleteCookie(GlobalConstants.ADMIN_AUTH_TOKEN_KEY);
            CookieUtils.deleteCookie(GlobalConstants.LAST_NAVIGATED_PAGE);
            request.getSession().invalidate();
            super.onLogoutSuccess(request, response, authentication);
    	}
    }
    
    
    
    /*duplication 로그인을 막는 로직이다. 아래부터는 지금은 사용안함 */
    
    /** session저장소
     * @return
     */
    @Bean 
    public SessionRegistry sessionRegistry() {
    	return new SessionRegistryImpl();
    }
    
    /** 셋션 event publish 해준다 세션에 등록되고 expire되는 등...
     * @return
     */
    @Bean
    public static HttpSessionEventPublisher httpSessionEventPublisher() {
        return new HttpSessionEventPublisher();
    }
    
    /** 새로 인증 된 사용자에 대해 이미 세션이있는 경우 (세션 고정 보호 공격에 대한 방어 수단으로) 새 세션을 만들고 해당 세션 속성을 새 세션으로 복사합니다. 속성의 복사는 migrateSessionAttributes
     *  를 false 로 설정하여 비활성화 할 수 있습니다 (이 경우에도 내부 스프링 보안 속성은 여전히 ​​새 세션으로 마이그레이션됩니다).
     *  여기서는 사용하지 않음
     * @return
     */
    @Bean
	public SessionFixationProtectionStrategy sp() {
		SessionFixationProtectionStrategy sp = new SessionFixationProtectionStrategy();
		sp.setMigrateSessionAttributes(false);
		return sp;
	}

    
    /** SessionAuthenticationStrategy session에다가 Authentication을 저장해 준다.
     * @return
     */
    @Bean
	public CompositeSessionAuthenticationStrategy sas() {
		List<SessionAuthenticationStrategy> delegateStrategies = new ArrayList<>();
		
		delegateStrategies.add(rs());  //sessionResitory에 저장
		delegateStrategies.add(cs());  //maxSession체크  
		//delegateStrategies.add(sp());
	
		CompositeSessionAuthenticationStrategy com = new CompositeSessionAuthenticationStrategy(delegateStrategies);
		return com;
	}
    
    /** authenticate이 성립되면 onAuthentication이 호출되어 sessionRepository에 authentication 저장된다.
     *  request.getSession().getId()키로   authentication.getPrincial() 저장
     * @return
     */
    @Bean
    public RegisterSessionAuthenticationStrategy rs() {
    	RegisterSessionAuthenticationStrategy rs = new RegisterSessionAuthenticationStrategy(sessionRegistry());
    	return rs;
    }
    
    /** 
     *  maxSession수를 정해 같은 유저로 셋션수 제한 등을 sessionResitry에서 체크해준다 
     *  그래서 위의  RegisterSessionAuthenticationStrategy 와 짝궁으로 쓰면 유저 session제한을 할수 있다.
     * @return
     */
    @Bean 
	public ConcurrentSessionControlAuthenticationStrategySupport cs() {
		ConcurrentSessionControlAuthenticationStrategySupport cs = 
				new ConcurrentSessionControlAuthenticationStrategySupport(sessionRegistry());
		cs.setDuplicationLoginDisable(true);
		return cs;
	}
    
    
    
    /** session expired 되었을 때 로그아웄 시키기 위해 필터를 사용한다.
     *  ConcurrentSessionFilter 셋션이 expired되었을때 LogoutHander를 등록해주면 
     *  logout처리후  Redirect주소로 처리해준다.
     * @return
     */
    @Bean
	public ConcurrentSessionFilter concurrentSessionFilter() {
		
		
		SimpleRedirectSessionInformationExpiredStrategy ss = new SimpleRedirectSessionInformationExpiredStrategy(DuplicationPAGE);
		/*session expired 되었을 때 로그아웄 시킨다.*/
		ConcurrentSessionFilter filter = new ConcurrentSessionFilter(sessionRegistry(), ss); 
		  //"/member/error/duplicationLogin"
		List<LogoutHandler> list = new ArrayList<>();
		//  list.add(rememberMeServices());
		list.add(securityContextLogoutHandler());
		list.add(cookieClearingLogoutHandler());
		//  list.add(new LogoutSuccessHandler(LOGIN_PAGE));
		  
		LogoutHandler[] sArrays = list.toArray(new LogoutHandler[list.size()]);  
		filter.setLogoutHandlers(sArrays);
		return filter;
	 }
	
	 /**
	  * SecurityContextHolder.clearContext();을 처리하며 로그아웃한다.
	  * @return
	  */
	@Bean
	  public SecurityContextLogoutHandler securityContextLogoutHandler() {
		  SecurityContextLogoutHandler s = new SecurityContextLogoutHandler();
		  s.setClearAuthentication(true);
		  s.setInvalidateHttpSession(true);
		  return s;
	  }
	  
	 /** cookieCleraing해주며 logout해준다.
	 * @return
	 */
	@Bean
	public CookieClearingLogoutHandler cookieClearingLogoutHandler() {
		CookieClearingLogoutHandler s = new CookieClearingLogoutHandler("JSESSIONID",
				GlobalConstants.ADMIN_AUTH_TOKEN_KEY, GlobalConstants.LAST_NAVIGATED_PAGE);
		return s;
	}
	
	public static void main(String args[])throws Exception{
		String tempDir = System.getProperty("java.io.tmpdir");
		System.out.println("tempDir = " + tempDir);
	}

}
