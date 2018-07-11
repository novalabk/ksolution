package com.ksolution.common.security;

import java.io.IOException;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.DatatypeConverter;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.config.KSolutionContextConfig;
import com.boot.ksolution.core.domain.user.SessionUser;
import com.boot.ksolution.core.session.JWTSessionHandler;
import com.boot.ksolution.core.utils.ContextUtil;
import com.boot.ksolution.core.utils.CookieUtils;
import com.boot.ksolution.core.utils.JsonUtils;
import com.boot.ksolution.core.utils.ModelMapperUtils;
import com.boot.ksolution.core.utils.PhaseUtils;
import com.boot.ksolution.core.utils.RequestUtils;
import com.boot.ksolution.core.vo.ScriptSessionVO;
import com.ksolution.common.code.GlobalConstants;
import com.ksolution.common.domain.program.Program;
import com.ksolution.common.domain.program.ProgramService;
import com.ksolution.common.domain.program.menu.Menu;
import com.ksolution.common.domain.program.menu.MenuService;
import com.ksolution.common.domain.user.User;
import com.ksolution.common.domain.user.UserService;
import com.ksolution.common.domain.user.auth.menu.AuthGroupMenu;
import com.ksolution.common.domain.user.auth.menu.AuthGroupMenuService;


/**
 * 인증된 정보 SessionUser를 암호화하여 쿠키에 저장.
 * @author jkeei
 *
 */
@Service
public class KSolutionTokenAuthenticationService {
	
	private final JWTSessionHandler jwtSessionHandler;
	
	@Inject
    private ProgramService programService;
	
	@Inject
	private AuthGroupMenuService authGroupMenuService;
	
	@Inject
	private MenuService menuService;
	
	@Inject
    private UserService userService;
	
	public KSolutionTokenAuthenticationService() {
		jwtSessionHandler = new JWTSessionHandler(DatatypeConverter.parseBase64Binary("YXhib290"));
	}
	
	public int tokenExpiry() {
		if (PhaseUtils.isProduction()) {
            //return 60 * 50;
			return 60 * 10 * 10 * 10 * 10;
        } else {
            return 60 * 10 * 10 * 10 * 10;
        }
	}
	
	public void addAuthentication(HttpServletResponse response, KSolutionUserAuthentication authentication) throws IOException{
		final SessionUser user = authentication.getDetails();
		setUserEnvironments(user, response);
		SecurityContextHolder.getContext().setAuthentication(authentication);
	}
	
	/**
	 * cookie에 SessionUser를 암호화하여 토큰화하여 저장한다.
	 * @param user
	 * @param response
	 * @throws IOException
	 */
	public void setUserEnvironments(SessionUser user, HttpServletResponse response) throws IOException {
		String token = jwtSessionHandler.createTokenForUser(user);
		CookieUtils.addCookie(response, GlobalConstants.ADMIN_AUTH_TOKEN_KEY, 
				token, tokenExpiry());
	}
	
	/** KSolutionAuthenticationFilter 에서 쿠키를 통해 인증체크 하기 위해 만든 함수.
	 * @param req
	 * @return 
	 */
	public Authentication getAuthentication(HttpServletRequest request, HttpServletResponse response) throws IOException {
		RequestUtils requestUtils = RequestUtils.of(request);
		final String token = CookieUtils.getCookieValue(request, GlobalConstants.ADMIN_AUTH_TOKEN_KEY);
        final String progCd = FilenameUtils.getBaseName(request.getServletPath());
        
        Long menuId = requestUtils.getLong("menuId");
        final String requestUri = request.getRequestURI();
        
       
        
        final String language = requestUtils.getString(GlobalConstants.LANGUAGE_PARAMETER_KEY, "");
        
        if (StringUtils.isNotEmpty(language)) {
            CookieUtils.addCookie(response, GlobalConstants.LANGUAGE_PARAMETER_KEY, language);
        }
        if (token == null) {
            return deleteCookieAndReturnNullAuthentication(request, response);
        }
        
        SessionUser user = jwtSessionHandler.parseUserFromToken(token);
        
        if(user == null) {
        	return deleteCookieAndReturnNullAuthentication(request, response);
        }
        
        User checkUser = userService.findOne(user.getUserCd());
        
        if (checkUser.getUseYn() == KSolutionTypes.Used.NO) {
        	UserValidateException e = new UserValidateException("user used no");
        	throw e;
        }
        
   
        String mainPage = KSolutionContextConfig.getInstance().getMainPage();
        Long mainId = KSolutionContextConfig.getInstance().getMainMenuId();
        if(requestUri.equals(ContextUtil.getContext() + mainPage)) {
        	if(menuId < 1) {
        		menuId = mainId;
        	}
        }
        
        if(!requestUri.startsWith(ContextUtil.getBaseApiPath())) {
        	if (menuId > 0) {
        		
        		
        		Menu menu = menuService.findOne(menuId);
        		System.out.println("menu = " + menu.getMenuNm()); 
        		if(menu != null) {
        			Program program = menu.getProgram();
        			if(program != null) {
        				requestUtils.setAttribute("program", program);
                        requestUtils.setAttribute("pageName", menu.getLocalizedMenuName(request));
                        requestUtils.setAttribute("pageRemark", program.getRemark());
                        if (program.getAuthCheck().equals(KSolutionTypes.Used.YES.getLabel())) {
                            AuthGroupMenu authGroupMenu = authGroupMenuService.getCurrentAuthGroupMenu(menuId, user);
                            if (authGroupMenu == null) {
                                throw new AccessDeniedException("Access is denied");
                            }
                            requestUtils.setAttribute("authGroupMenu", authGroupMenu);  //머지된 authGroupMenu를 
                        }
        			}
        		}
        	}
        	
        	ScriptSessionVO scriptSessionVO = ModelMapperUtils.map(user, ScriptSessionVO.class);
            scriptSessionVO.setDateFormat(scriptSessionVO.getDateFormat().toUpperCase());
            scriptSessionVO.getDetails().put("language", requestUtils.getLocale(request).getLanguage());
            requestUtils.setAttribute("loginUser", user);
            requestUtils.setAttribute("scriptSession", JsonUtils.toJson(scriptSessionVO));
            
            if (progCd.equals("main")) {  //url path main 경우
                List<Menu> menuList = menuService.getAuthorizedMenuList(user.getMenuGrpCd(), user.getAuthGroupList());
                requestUtils.setAttribute("menuJson", JsonUtils.toJson(menuList));
            }
        }
        
        setUserEnvironments(user, response); 
        return new KSolutionUserAuthentication(user);
	}
	
	private Authentication deleteCookieAndReturnNullAuthentication(HttpServletRequest request, HttpServletResponse response) {
        CookieUtils.deleteCookie(request, response, GlobalConstants.ADMIN_AUTH_TOKEN_KEY);
        ScriptSessionVO scriptSessionVO = ScriptSessionVO.noLoginSession();
        request.setAttribute("scriptSession", JsonUtils.toJson(scriptSessionVO));
        return null;
    }
}
