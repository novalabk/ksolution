package com.ksolution.common.utils;


import com.boot.ksolution.core.context.AppContextManager;
import com.ksolution.common.domain.user.UserService;
import com.ksolution.common.domain.user.auth.UserAuthService;

public class CommonUtil {
	public static UserService getUserService() {
        return AppContextManager.getBean(UserService.class);
    }
}
