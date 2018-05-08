package com.ksolution.common.domain.log;

import com.boot.ksolution.core.domain.log.KSolutionErrorLog;

import ch.qos.logback.classic.spi.ILoggingEvent;

public interface KSolutionErrorLogService {
	void save(KSolutionErrorLog errorLog);
	void deleteAllLogs();
	void deleteLog(Long id);
	KSolutionErrorLog build(ILoggingEvent loggingEvent);
}
