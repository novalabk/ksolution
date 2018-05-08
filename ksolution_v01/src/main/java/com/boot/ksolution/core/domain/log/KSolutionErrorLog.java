package com.boot.ksolution.core.domain.log;
import java.time.Instant;

public interface KSolutionErrorLog {
	String getPhase();

    String getSystem();

    String getLoggerName();

    String getServerName();

    String getHostName();

    String getPath();

    String getMessage();

    String getTrace();

    Instant getErrorDatetime();

    String getAlertYn();

    String getHeaderMap();

    String getParameterMap();

    String getUserInfo();

    void setAlertYn(String alertYn);
}
