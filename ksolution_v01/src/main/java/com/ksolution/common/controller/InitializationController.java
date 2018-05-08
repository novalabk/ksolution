package com.ksolution.common.controller;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.ksolution.common.domain.init.DatabaseInitService;

@RequestMapping("/setup")
@Controller
public class InitializationController extends BaseController{

	@Inject
    private DatabaseInitService databaseInitService;
	
	@RequestMapping(value = "/init", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public ApiResponse init() throws Exception {
        databaseInitService.init();
        return ok();
    }
}  
