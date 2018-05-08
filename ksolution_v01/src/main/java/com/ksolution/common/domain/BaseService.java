package com.ksolution.common.domain;

import java.io.Serializable;

import com.boot.ksolution.core.domain.base.KSolutionBaseService;
import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;
import com.ksolution.common.domain.code.QCommonCode;
import com.ksolution.common.domain.file.QCommonFile;
import com.ksolution.common.domain.file.QCommonFileMaster;
import com.ksolution.common.domain.gantt.QGanttJsonData;
import com.ksolution.common.domain.gantt.QProjectInfo;
import com.ksolution.common.domain.gantt.output.QPJTFolder;
import com.ksolution.common.domain.program.QProgram;
import com.ksolution.common.domain.program.menu.QMenu;
import com.ksolution.common.domain.user.QUser;
import com.ksolution.common.domain.user.auth.QUserAuth;
import com.ksolution.common.domain.user.auth.menu.QAuthGroupMenu;
import com.ksolution.common.domain.user.role.QUserRole;

public class BaseService<T, ID extends Serializable> extends KSolutionBaseService<T, ID> {
	
	protected QUserRole qUserRole = QUserRole.userRole;
	protected QAuthGroupMenu qAuthGroupMenu = QAuthGroupMenu.authGroupMenu;
	protected QCommonCode qCommonCode = QCommonCode.commonCode;
	protected QProjectInfo qProjectInfo = QProjectInfo.projectInfo;
	protected QGanttJsonData qGanttJsonData = QGanttJsonData.ganttJsonData;
    
	protected QUserAuth qUserAuth = QUserAuth.userAuth;
	
	
	protected QUser qUser = QUser.user;
	protected QProgram qProgram = QProgram.program;
    protected QMenu qMenu = QMenu.menu;
    
    protected QPJTFolder qPjtFolder = QPJTFolder.pJTFolder;
    protected QCommonFile qCommonFile = QCommonFile.commonFile; 
    
    protected QCommonFileMaster qCommonFileMaster = QCommonFileMaster.commonFileMaster;
    
    
	protected KSolutionJPAQueryDSLRepository<T, ID> repository;
	
	public BaseService() {
		super();
	}
	
	public BaseService(KSolutionJPAQueryDSLRepository<T, ID> repository) {
		super(repository);
		this.repository = repository;
	}
}
