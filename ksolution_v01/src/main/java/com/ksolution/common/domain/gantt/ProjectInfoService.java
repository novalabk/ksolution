package com.ksolution.common.domain.gantt;

import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.time.Instant;

import javax.inject.Inject;
import javax.transaction.Transactional;
import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import com.boot.ksolution.core.parameter.RequestParams;
import com.fasterxml.jackson.databind.JsonNode;
import com.ksolution.common.domain.BaseService;
import com.querydsl.jpa.impl.JPAQuery;

@Service
public class ProjectInfoService extends BaseService<ProjectInfo, Long>{

	private ProjectInfoRepository projectInfoRepository;
	
	@Inject
	private GanttJsonDataService ganttDataService;
	
	@Inject
	public ProjectInfoService(ProjectInfoRepository projectInfoRepository) {
		super(projectInfoRepository);
		this.projectInfoRepository = projectInfoRepository;
	}
	
	@Override
	@Transactional
	public ProjectInfo save(ProjectInfo projectInfo) {
		boolean isNew = projectInfo.isNew();
		if(isNew) {
			String code = "PRJ";
			
			long nextId = getMaxId() + 1;
			
			String next_str = new DecimalFormat("000000").format(nextId);
			code = code.concat(next_str);
			projectInfo.setCode(code);
		}
		
		JsonNode ganttData = projectInfo.getGanttData();
		
		JsonNode tasks = ganttData.get("tasks");
		
		if(tasks != null && tasks.size() > 0) {
			JsonNode taskNode = tasks.get(0);

			long start = taskNode.get("start").asLong();
			long end = taskNode.get("start").asLong();
			
			Instant startDate = Instant.ofEpochMilli(start);
			Instant endDate = Instant.ofEpochMilli(end);
			
			projectInfo.setStartDate(startDate);
			projectInfo.setEndDate(startDate);
			//taskNode.get("end");
		}
		
		super.save(projectInfo);
		GanttJsonData ganttJsonData = null; 
		if(isNew) {
			ganttJsonData = new GanttJsonData();
		}else {
			ganttJsonData = ganttDataService.getFromProjectId(projectInfo.getId());
		}
		
		ganttJsonData.setProjectInfoId(projectInfo.getId());
		ganttJsonData.setGanttData(ganttData);
		ganttJsonData = ganttDataService.save(ganttJsonData);
		
		
		projectInfo.setGanttData(ganttJsonData.getGanttData());
		
		return projectInfo;
	}
	
	public long getMaxId() {
		JPAQuery<Long> query = select().select(qProjectInfo.oid.max().coalesce(0l));
    	query.from(qProjectInfo);
    	Long max = query.fetchOne();
    	return max;
	}
	
	public Page<ProjectInfo> findProjectInfo(RequestParams params, PageRequest pageable){
		String name = params.getString("name");
		String code = params.getString("code");
		String state = params.getString("state");
		
		JPAQuery<ProjectInfo> query = select();
		query.from(qProjectInfo);
		
		Page<ProjectInfo> pList = projectInfoRepository.buildPage(query, query, pageable);
		
		return pList;
	}
	
	@Transactional
	public void delete(Long id) {
		GanttJsonData data = ganttDataService.getFromProjectId(id);
		if(data != null) {
			ganttDataService.delete(data);
		}
		super.delete(id); 
	}

	public ProjectInfo getProjectInfo(Long id, boolean withGanttData) {
		
		ProjectInfo projectInfo = projectInfoRepository.findOne(id);
		if(withGanttData) {
			
			GanttJsonData data = ganttDataService.getFromProjectId(id);
			projectInfo.setGanttData(data.getGanttData()); 
		}
		
		return projectInfo;
	}
	
	
}
