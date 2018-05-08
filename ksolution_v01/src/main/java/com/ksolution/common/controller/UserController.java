package com.ksolution.common.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.user.User;
import com.ksolution.common.domain.user.UserService;

@Controller
@RequestMapping(value = "/api/v1/users")
public class UserController extends BaseController {
	
	@Inject
	private UserService userService;
	
	@RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse list(RequestParams requestParams){
		List<User> users = userService.get(requestParams); 
		userService.setUserAuth(users);
		return Responses.ListResponse.of(users);
	}
	
	@RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON, params = "userCd")
	public User get(RequestParams requestParams) {
        return userService.getUser(requestParams);
    }
	
	@RequestMapping(method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public ApiResponse save(@Valid @RequestBody List<User> users) throws Exception {
        userService.saveUser(users);
        return ok();
    }
	
	/*@RequestMapping(value="/isAdmin",  method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Map<String, Boolean> isAdmin(){
    	Map<String, Boolean> map = new HashMap<>();
    	boolean isAdmin = CommonUtil.isAdmin();
    	map.put("isAdmin", isAdmin);
		return map;
    }*/
}
