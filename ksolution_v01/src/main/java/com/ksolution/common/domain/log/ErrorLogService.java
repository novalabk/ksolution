package com.ksolution.common.domain.log;

import javax.inject.Inject;
import javax.persistence.Query;

import org.springframework.boot.logging.LoggingInitializationContext;
import org.springframework.stereotype.Service;

import com.boot.ksolution.core.config.KSolutionContextConfig;
import com.boot.ksolution.core.domain.log.KSolutionErrorLog;
import com.boot.ksolution.core.utils.MDCUtil;
import com.boot.ksolution.core.utils.ModelMapperUtils;
import com.boot.ksolution.core.utils.PhaseUtils;
import com.ksolution.common.domain.BaseService;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.classic.spi.StackTraceElementProxy;
import ch.qos.logback.core.util.ContextUtil;

@Service
public class ErrorLogService extends BaseService<ErrorLog, Long> implements KSolutionErrorLogService{

	private ErrorLogRepository errorLogRepository;
	
	@Inject
	private KSolutionContextConfig kSolutionContextConfig;
	
	@Inject
	public ErrorLogService(ErrorLogRepository errorLogRepository) {
		super(errorLogRepository);
		this.errorLogRepository = errorLogRepository;
	}
	
	@Override
	public void save(KSolutionErrorLog ksolutionErrorLog) {
		ErrorLog errorLog = ModelMapperUtils.map(ksolutionErrorLog, ErrorLog.class);
		save(errorLog);
	}

	@Override
	public void deleteAllLogs() {
		// TODO Auto-generated method stub
		Query query = em.createNativeQuery("DELETE FROM ERROR_LOG_M");
		query.executeUpdate();
	}

	@Override
	public void deleteLog(Long id) {
		// TODO Auto-generated method stub
		delete(id);
	}

	@Override
	public KSolutionErrorLog build(ILoggingEvent loggingEvent) {
		ErrorLog errorLog = new ErrorLog();
		errorLog.setPhase(PhaseUtils.phase());  //local, product, alpha
		errorLog.setSystem(kSolutionContextConfig.getApplication().getName());
		errorLog.setLoggerName(loggingEvent.getLoggerName());
        errorLog.setServerName(kSolutionContextConfig.getServerName());
        errorLog.setHostName(getHostName());
        errorLog.setPath(MDCUtil.get(MDCUtil.REQUEST_URI_MDC));
        errorLog.setMessage(loggingEvent.getFormattedMessage());
        errorLog.setHeaderMap(MDCUtil.get(MDCUtil.HEADER_MAP_MDC));
        errorLog.setParameterMap(MDCUtil.get(MDCUtil.PARAMETER_BODY_MDC));
        errorLog.setUserInfo(MDCUtil.get(MDCUtil.USER_INFO_MDC));
		
        if(loggingEvent.getThrowableProxy() != null) {
        	errorLog.setTrace(getStackTrace(loggingEvent.getThrowableProxy().getStackTraceElementProxyArray()));
        }
		return errorLog;
	}
	
	public String getHostName() {
		try {
			return ContextUtil.getLocalHostName();
		}catch(Exception e) {
			
		}
		return null;
	}
	
	public String getStackTrace(StackTraceElementProxy[] stackTraceElements) {
		if (stackTraceElements == null || stackTraceElements.length == 0) {
            return null;
        }
		StringBuilder sb = new StringBuilder();
		for(StackTraceElementProxy element: stackTraceElements) {
			sb.append(element.toString());
            sb.append("\n");
		}
		return sb.toString();
	}
	
	public static void main(String args[])throws Exception{
        System.out.println("main..");		
		System.out.println("kkkk  = " + ContextUtil.getLocalHostName());
	}
}
