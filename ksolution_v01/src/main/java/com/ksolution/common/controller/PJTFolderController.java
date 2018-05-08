package com.ksolution.common.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.code.ApiStatus;
import com.boot.ksolution.core.parameter.RequestParams;
import com.boot.ksolution.core.utils.MessageUtils;
import com.ksolution.common.domain.gantt.output.PJTFolder;
import com.ksolution.common.domain.gantt.output.PJTFolderRequestVO;
import com.ksolution.common.domain.gantt.output.PJTFolderService;
import com.ksolution.common.domain.program.menu.Menu;

@Controller
@RequestMapping(value = "/api/v2/pjtFolder")
public class PJTFolderController extends BaseController{

	@Inject
	private PJTFolderService folderService;
	
	@RequestMapping(method = RequestMethod.GET, produces = APPLICATION_JSON )
    public Responses.ListResponse menuList(RequestParams requestParams){
    	List<PJTFolder> list = folderService.get(requestParams);
        return Responses.ListResponse.of(list);
    }
	
	@RequestMapping(method = {RequestMethod.PUT}, produces = APPLICATION_JSON)
	public ApiResponse save(@RequestBody PJTFolderRequestVO folderVO) {
		
		
		
		//System.out.println("folderVO.getList() == " + folderVO.getList());
		//folderService.processPJTFolder(folderVO);
		folderService.saveFolder(folderVO.getList());
		/*System.out.println("folderVO.getList().get(0).getId() "
		+ folderVO.getList().get(0).getId());*/
		long id = 0;
		if(folderVO.getList() != null) {
			id = folderVO.getList().get(0).getId();
		}
		String resultValue = String.valueOf(id);
		return ApiResponse.of(ApiStatus.SUCCESS, "SUCCESS" , resultValue);
	}
	
	@RequestMapping(value = "delete", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse delete(@RequestBody PJTFolderRequestVO folderVO) {
		
		boolean result = folderService.deleteFolder(folderVO.getDeletedList());
		
		if(!result) {
    		String errorMessage = MessageUtils.getMessage("ks.Msg.9");  //파일이 존재합니다.
    		return ApiResponse.error(ApiStatus.SYSTEM_ERROR, errorMessage);
    	}else {
    		return ok();
    	}
	}
	
	@RequestMapping(value = "/move", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse move(@RequestBody PJTFolderRequestVO folderVO){
		//System.out.println("folderVO" + folderVO.getMoveType());
		folderService.moveFolder(folderVO);
		return ok();
	}
	
	@RequestMapping(value = "/pathInfo", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.MapResponse pathInfo(@RequestParam(value = "oid", required = true) long id){
		
		PJTFolder folder = folderService.findOne(id);
		
		String path = folderService.getFolderPath(folder, "/");
		 
		Map<String, Object> map = new HashMap<>();
		
		map.put("path", path);
		
		map.put("oid", id);
		
		return Responses.MapResponse.of(map);
		
	}
	
	
	
}
