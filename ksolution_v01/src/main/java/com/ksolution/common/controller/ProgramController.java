package com.ksolution.common.controller;

import java.util.List;

import javax.inject.Inject;
import javax.validation.Valid;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.json.Views;
import com.boot.ksolution.core.parameter.RequestParams;
import com.fasterxml.jackson.annotation.JsonView;
import com.ksolution.common.domain.program.Program;
import com.ksolution.common.domain.program.ProgramService;

@Controller
@RequestMapping(value = "/api/v1/programs")
public class ProgramController extends BaseController{
	
	@Inject
	private ProgramService programService;
	
	//RequestParamsArgumentResolver 에서 requestParams Resolver를 구현함.
	@RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.ListResponse list(RequestParams requestParams){
		List<Program> programs = programService.get(requestParams);
		return Responses.ListResponse.of(programs);
	}
	
	@RequestMapping(method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public ApiResponse save(@Valid @RequestBody List<Program> request) {
        programService.saveProgram(request);
        return ok();
    }
}
