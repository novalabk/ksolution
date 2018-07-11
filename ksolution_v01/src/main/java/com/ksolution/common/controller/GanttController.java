package com.ksolution.common.controller;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.time.DateFormatUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.stereotype.Controller;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.boot.ksolution.core.api.response.ApiResponse;
import com.boot.ksolution.core.parameter.RequestParams;
import com.boot.ksolution.core.utils.JsonUtils;
import com.fasterxml.jackson.databind.JsonNode;
import com.ksolution.common.domain.gantt.ProjectInfo;
import com.ksolution.common.domain.gantt.ProjectInfoService;
import com.ksolution.common.domain.gantt.TaskVO;
import com.ksolution.common.domain.program.menu.Menu;
import com.ksolution.common.domain.user.User;

@Controller
@RequestMapping(value = "/api/v1/gantt")
public class GanttController extends BaseController {

	@Inject
	ProjectInfoService projectInfoService;
	
	@RequestMapping(method = RequestMethod.PUT, produces = APPLICATION_JSON)
    public ProjectInfo save(@RequestBody ProjectInfo projectInfo) throws Exception {
		
		String code = null;
		if(!projectInfo.isNew()) {
			code = projectInfo.getCode();
		}
		//System.out.println(projectInfo.getName());
		//System.out.println(JsonUtils.toJson(projectInfo.getGanttData()));
		JsonNode node = projectInfo.getGanttData();
		
		projectInfo = projectInfoService.save(projectInfo);
		if(code != null) {
			projectInfo.setCode(code);
		}

		
        return projectInfo;
    }
	
	/** Task 롤업하여 자동계산한다.
	 * @param list
	 * @return
	 */
	@RequestMapping(value = "/autoCal", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public List<TaskVO> autoCal(@RequestBody List<TaskVO> list){
		
		List<TaskVO> resultList = new ArrayList<TaskVO>();
		for(TaskVO root : list) {
			int period = root.getPeriod();
			if(period == 0) {
				continue;
			}
			settingGanttProcess(root);
			resultList.add(root);
		}
		return resultList;
	}
	
	public void settingGanttProcess(TaskVO root) {
		settingTaskProgress(root);
		 for (int i = 0; i < root.getChildCount(); i++) {
			 settingGanttProcess(root.getChildAt(i));
	      }
	}
	
	public void settingTaskProgress(TaskVO task) {
		List<TaskVO> list = getEndTasks(task);
		
		if(list.size() == 0) {
			return;
		}
		
		int totalDuration = 0;
        float currentDuration = 0.0f;
		for(TaskVO endTask : list) {
			totalDuration += endTask.getPeriod();
			float exPeriod = (float)endTask.getPeriod() * ((float)endTask.getProgress() / 100.0f);
			currentDuration += exPeriod;
		}
		float progress = currentDuration / (float)totalDuration * 100.0f;
		task.setProgress(Math.round(progress));
	}
   
	public List<TaskVO> getEndTasks(TaskVO task){
		List<TaskVO> endTasks = new ArrayList<TaskVO>();
		settingEnds(task, endTasks);
		return endTasks;
	}
	
	private void settingEnds(TaskVO parent, List<TaskVO> endTasks) {
	      for (int i = 0; i < parent.getChildCount(); i++) {
	         settingEnds(parent.getChildAt(i), endTasks);
	      }
	      if (parent.getChildCount() == 0){
	         endTasks.add(parent);
	      }
	}
	
	@RequestMapping(value = "/delete", method = RequestMethod.PUT, produces = APPLICATION_JSON)
	public ApiResponse delete(@RequestBody ProjectInfo projectInfo){
		//System.out.println("id ================ " + oid);
		projectInfoService.delete(projectInfo.getOid());
		return ok();
	}
	
	@RequestMapping(value = "/get/{oid}", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public ProjectInfo get(@PathVariable Long oid){
		//System.out.println("id ================ " + oid);
		ProjectInfo projectInfo =  projectInfoService.getProjectInfo(oid , true);
		System.out.println("projectInfo == " + projectInfo.getPjtState()); 
		return projectInfo;
	}
	
	@RequestMapping(value = "/list", method = RequestMethod.GET, produces = APPLICATION_JSON)
	public List<ProjectInfo> list(RequestParams params){
		
		PageRequest pageable = new PageRequest(0, 1000);
		Page<ProjectInfo> pages = projectInfoService.findProjectInfo(params, pageable);
		
		List<ProjectInfo> list = pages.getContent();
		return list;
	}
	
	@RequestMapping(value = "/export", method = RequestMethod.POST)
    public void download(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
		
		String data = request.getParameter("data"); // 파라메터 data
		String extension = request.getParameter("extension"); // 파라메터 확장자
		
		byte[] dataByte = Base64.decodeBase64(data.getBytes()); // 데이터 base64 디코딩

		String str = new String(dataByte);


		outputStream.write(dataByte);


		String filename = "export." + extension; // 다운로드 될 파일명
			
		response.reset();
		response.setContentType("application/octet-stream");
		response.setHeader("Content-Disposition","attachment; filename=" + filename );
		response.setHeader("Content-Length",String.valueOf(outputStream.size()));

		//FileCopyUtils.copy(inputStream, response.getOutputStream());
		
		//out.clear();
		//pageContext.pushBody();
		ServletOutputStream sos = response.getOutputStream();
		sos.write(outputStream.toByteArray());
		sos.flush();
		sos.close();
		
    }
	
}
