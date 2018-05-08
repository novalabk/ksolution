package com.ksolution.common.domain.gantt;

import java.util.List;

import javax.inject.Inject;
import javax.transaction.Transactional;

import org.springframework.stereotype.Service;

import com.ksolution.common.domain.BaseService;
import com.querydsl.core.BooleanBuilder;

@Service
public class GanttJsonDataService extends BaseService<GanttJsonData, Long>{
	
	private GanttJsonDataRepository ganttJsonDataRepository;
	
	@Inject
	public GanttJsonDataService(GanttJsonDataRepository ganttJsonDataRepository) {
		super(ganttJsonDataRepository);
		this.ganttJsonDataRepository = ganttJsonDataRepository;
	}
	
	@Override
	@Transactional
	public GanttJsonData save(GanttJsonData ganttJsonData) {
		ganttJsonData = super.save(ganttJsonData);
		return ganttJsonData;
	}
	
	public GanttJsonData getFromProjectId(Long projectId) {
		BooleanBuilder builder = new BooleanBuilder();
        builder.and(qGanttJsonData.projectInfoId.eq(projectId));
        builder.and(qGanttJsonData.latest.eq(true));
        GanttJsonData ganttData = select().from(qGanttJsonData).where(builder).fetchOne();
        return ganttData;
	}
}
