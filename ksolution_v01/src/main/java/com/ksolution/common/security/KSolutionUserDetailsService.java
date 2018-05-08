package com.ksolution.common.security;


import java.util.Calendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import javax.inject.Inject;

import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.domain.user.SessionUser;
import com.boot.ksolution.core.parameter.RequestParams;
import com.boot.ksolution.core.utils.DateTimeUtils;
import com.ksolution.common.domain.user.User;
import com.ksolution.common.domain.user.UserService;
import com.ksolution.common.domain.user.auth.UserAuth;
import com.ksolution.common.domain.user.auth.UserAuthService;
import com.ksolution.common.domain.user.role.UserRole;
import com.ksolution.common.domain.user.role.UserRoleService;

@Service
public class KSolutionUserDetailsService implements UserDetailsService {

	@Inject
    private UserService userService;

    @Inject
    private UserRoleService userRoleService;

    @Inject
    private UserAuthService userAuthService;
    
	@Override
	public final SessionUser loadUserByUsername(String userCd) throws UsernameNotFoundException {
		
		User user = userService.findOne(userCd);
		
		if(user == null) {
			throw new UsernameNotFoundException("사용자 정보를 확인하세요.");
		}
		
		if(user.getUseYn() == KSolutionTypes.Used.NO) {
			throw new UsernameNotFoundException("존재하지 않는 사용자 입니다.");
        }
		
		if(user.getDelYn() == KSolutionTypes.Deleted.YES) {
			throw new UsernameNotFoundException("존재하지 않는 사용자 입니다.");
        }
		
		List<UserRole> userRoleList = userRoleService.findByUserCd(userCd);

        List<UserAuth> userAuthList = userAuthService.findByUserCd(userCd);

        SessionUser sessionUser = new SessionUser();
        sessionUser.setUserCd(user.getUserCd());
        sessionUser.setUserNm(user.getUserNm());
        sessionUser.setUserPs(user.getUserPs());
        sessionUser.setMenuGrpCd(user.getMenuGrpCd());
        
        userRoleList.forEach(r -> sessionUser.addAuthority(r.getRoleCd()));
        userAuthList.forEach(a -> sessionUser.addAuthGroup(a.getGrpAuthCd()));

        String[] localeString = user.getLocale().split("_");
        
        Locale locale = new Locale(localeString[0], localeString[1]);
        
        final Calendar cal = Calendar.getInstance();
        final TimeZone timeZone = cal.getTimeZone();
        
        sessionUser.setTimeZone(timeZone.getID());
        
        sessionUser.setDateFormat(DateTimeUtils.dateFormatFromLocale(locale));
        sessionUser.setTimeFormat(DateTimeUtils.timeFormatFromLocale(locale));
        sessionUser.setLocale(locale);
        
		return sessionUser;
	}

}
