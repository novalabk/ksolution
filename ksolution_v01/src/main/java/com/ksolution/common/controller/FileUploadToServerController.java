package com.ksolution.common.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.api.response.Responses;
import com.boot.ksolution.core.code.ApiStatus;
import com.boot.ksolution.core.parameter.RequestParams;
import com.boot.ksolution.core.utils.MessageUtils;
import com.ksolution.common.domain.file.CommonFile;
import com.ksolution.common.domain.file.CommonFileService;
import com.ksolution.common.domain.gantt.output.PJTFolderSearchVO;

@Controller
@RequestMapping(value = "/api/v1/ax5uploader")
public class FileUploadToServerController extends BaseController{
	
	@Inject
	private CommonFileService commonFileService;
	
	@RequestMapping(value = "/upload", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public CommonFile upload(
			@RequestParam(value = "file") MultipartFile multipartFile,
			@RequestParam(value = "targetType", required = false) String targetType,
            @RequestParam(value = "targetId", required = false) String targetId,
            @RequestParam(value = "sort", required = false, defaultValue = "0") int sort,
            @RequestParam(value = "deleteIfExist", required = false, defaultValue = "false") boolean deleteIfExist,
            @RequestParam(value = "desc", required = false) String desc,
            @RequestParam(value = "thumbnail", required = false, defaultValue = "false") boolean thumbnail,
            @RequestParam(value = "thumbnailWidth", required = false, defaultValue = "640") int thumbnailWidth,
            @RequestParam(value = "thumbnailHeight", required = false, defaultValue = "640") int thumbnailHeight
			)throws IOException {
		
		
		
		String fNm = FilenameUtils.getName(multipartFile.getOriginalFilename());
		String ext = FilenameUtils.getExtension(multipartFile.getOriginalFilename());
		
		File uploadFile = commonFileService.multiPartFileToFileWithoutFolder(multipartFile);
	       
		//System.out.println("uploadFile == " + uploadFile.getPath()  + " size == " + uploadFile.length()  + " targetId = " + targetId);
        
        CommonFile commonFile = new CommonFile();
        commonFile.set_fileNm(fNm);
        commonFile.set_extension(ext);
        commonFile.set_thumbnail("/api/v1/ax5uploader/prethumbnail?sname=" + uploadFile.getName());
        commonFile.set_download("/api/v1/ax5uploader/prethumbnail?sname=" + uploadFile.getName());
        commonFile.setFileSize(uploadFile.length());
        commonFile.setSaveNm(uploadFile.getName());
        
       
        return commonFile;
	}
	
	@RequestMapping(value = "/uploadWithSave", method = RequestMethod.POST, produces = APPLICATION_JSON)
	public CommonFile uploadWithSave(
			@RequestParam(value = "file") MultipartFile multipartFile,
			@RequestParam(value = "targetType", required = false) String targetType,
            @RequestParam(value = "targetId", required = false) String targetId
            )throws IOException {
		
		CommonFile commonFile = commonFileService.upload(multipartFile, targetType, targetId);   
        return commonFile;
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public Responses.PageResponse list(RequestParams<CommonFile> requestParams) {
		Page<CommonFile> files = commonFileService.getList(requestParams);
        return Responses.PageResponse.of(files);
    }
	

    @RequestMapping(value = "/download", method = RequestMethod.GET)
    public ResponseEntity<InputStreamResource> download(@RequestParam Long id) throws IOException {
        return commonFileService.downloadById(id);
    }
    
    @RequestMapping(value = "/versionList", method = RequestMethod.GET, produces = APPLICATION_JSON)
    public Responses.ListResponse versionList(@RequestParam Long masterId){
    
    	List<CommonFile> files = commonFileService.versionList(masterId);
    	return Responses.ListResponse.of(files);
    }
    

    /*@RequestMapping(value = "/download", method = RequestMethod.GET, params = {"targetType", "targetId"})
    public ResponseEntity<byte[]> downloadByTargetTypeAndTargetId(@RequestParam String targetType, @RequestParam String targetId) throws IOException {
        return commonFileService.downloadByTargetTypeAndTargetId(targetType, targetId);
    }
    
	@RequestMapping(value = "/preview", method = RequestMethod.GET)
    public void preview(HttpServletResponse response, @RequestParam Long id) throws IOException {
        commonFileService.preview(response, id);
    }

    @RequestMapping(value = "/thumbnail", method = RequestMethod.GET)
    public void thumbnail(HttpServletResponse response, @RequestParam Long id) throws IOException {
        commonFileService.thumbnail(response, id);
    }*/
    
    @RequestMapping(value = "/delete", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse delete(@RequestBody List<CommonFile> files) {
    	
    	commonFileService.deleteFile(files);
    	
    	return ok();
    }
    
    @RequestMapping(value = "/searchForInProject", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public Responses.PageResponse search(@RequestBody PJTFolderSearchVO seachVo) throws IOException {
		
		System.out.println("seachVo = " + seachVo);
		
		Page<CommonFile> files = commonFileService.getListForProjectOutput(seachVo);
        return Responses.PageResponse.of(files);
      
    }
}
