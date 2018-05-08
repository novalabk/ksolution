package com.ksolution.common.controller;

import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.validation.Valid;
import javax.validation.constraints.NotNull;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.code.CommonCode;
import com.ksolution.common.domain.code.CommonCodeService;
import com.ksolution.common.utils.CommonCodeUtils;
import com.wordnik.swagger.annotations.ApiImplicitParam;
import com.wordnik.swagger.annotations.ApiImplicitParams;


@Controller
@RequestMapping(value = "/api/v1/commonCodes")
public class CommonCodeController extends BaseController {
	@Inject 
    private CommonCodeService basicCodeService;
	
	 @RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON)
	 @ApiImplicitParams({
         @ApiImplicitParam(name = "groupCd", value = "분류 코드", dataType = "String", paramType = "query"),
         @ApiImplicitParam(name = "useYn", value = "사용여부 (Y/N)", dataType = "String", paramType = "query"),
         @ApiImplicitParam(name = "filter", value = "검색어", dataType = "String", paramType = "query")
	 })
	 public Responses.ListResponse list(RequestParams<CommonCode> requestParams) {
        List<CommonCode> basicCodes = basicCodeService.get(requestParams);
        return Responses.ListResponse.of(basicCodes);
    }
	 
	@RequestMapping(method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
    public ApiResponse save(@Valid @NotNull @RequestBody List<CommonCode> basicCodes) {
        basicCodeService.saveCommonCode(basicCodes);
        return ok();
    }
	
	@RequestMapping(value = "/getAllByMap", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Map<String, List<CommonCode>> getAllByMap() {
        return CommonCodeUtils.getAllByMap();
    }
	 
}
