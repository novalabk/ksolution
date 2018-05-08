package com.boot.ksolution.core.logging;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.commons.lang3.StringUtils;

import com.boot.ksolution.core.config.KSolutionContextConfig;
import com.boot.ksolution.core.domain.log.KSolutionErrorLog;
import com.boot.ksolution.core.utils.JsonUtils;
import com.ksolution.common.domain.log.KSolutionErrorLogService;

import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.core.UnsynchronizedAppenderBase;
import lombok.Getter;
import lombok.Setter;
import net.gpedro.integrations.slack.SlackApi;
import net.gpedro.integrations.slack.SlackAttachment;
import net.gpedro.integrations.slack.SlackField;
import net.gpedro.integrations.slack.SlackMessage;

@Setter
@Getter
public class KSolutionLogbackAppender extends UnsynchronizedAppenderBase<ILoggingEvent> {

	private KSolutionErrorLogService errorLogService;
	
	private KSolutionContextConfig kSolutionContextConfig;
	
	private KSolutionContextConfig.Logging kSolutionLoggingConfig;
	
	public KSolutionLogbackAppender(KSolutionErrorLogService errorLogService,
			KSolutionContextConfig kSolutionContextConfig) {
		
		this.errorLogService = errorLogService;
		this.kSolutionContextConfig = kSolutionContextConfig;
		this.kSolutionLoggingConfig = kSolutionContextConfig.getLoggingConfig(); 
	}
	
	@PostConstruct
	public void created() {
		this.kSolutionLoggingConfig = kSolutionContextConfig.getLoggingConfig();
	}
	
	@Override
	public void doAppend(ILoggingEvent eventObject) {
		super.doAppend(eventObject);
	}
	
	@Override
	protected void append(ILoggingEvent loggingEvent) {
		if(loggingEvent.getLevel().isGreaterOrEqual(kSolutionLoggingConfig.getLevel())) {
			KSolutionErrorLog errorLog = errorLogService.build(loggingEvent);
			
			if(kSolutionLoggingConfig.getDatabase().isEnabled()) {
				if(kSolutionLoggingConfig.getSlack().isEnabled()) {
					errorLog.setAlertYn("Y");
				}
				toDatabase(errorLog);
			}
			
			if(kSolutionLoggingConfig.getSlack().isEnabled()) {
				toSlack(errorLog);
			}
			
		}
		
	}
	
	private void toSlack(KSolutionErrorLog errorLog) {
		SlackApi slackApi = new SlackApi(kSolutionLoggingConfig.getSlack().getWebHookUrl());
		
		List<SlackField> fields = new ArrayList<>();
		
		SlackField message = new SlackField();
		message.setTitle("ERROR MESSAGE");
		message.setValue(errorLog.getMessage());
		message.setShorten(false);
		fields.add(message);
		
		SlackField path = new SlackField();
		path.setTitle("ERROR URL");
		path.setValue(errorLog.getPath());
		path.setShorten(false);
		fields.add(path);
		
		SlackField date = new SlackField();
        date.setTitle("ERROR TIME");
        LocalDateTime localDateTime = LocalDateTime.ofInstant(errorLog.getErrorDatetime(), ZoneId.of("Asia/Seoul"));
        date.setValue(localDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        date.setShorten(true);
        fields.add(date);
        
        SlackField profile = new SlackField();
        profile.setTitle("ERROR FROM");
        profile.setValue(errorLog.getPhase());   //local, product, alpha
        profile.setShorten(true);
        fields.add(profile);
        
        SlackField system = new SlackField();
        system.setTitle("ERROR SYSTEM");
        system.setValue(errorLog.getSystem());
        system.setShorten(true);
        fields.add(system);

        SlackField serverName = new SlackField();
        serverName.setTitle("ERROR SERVERNAME");
        serverName.setValue(errorLog.getServerName());
        serverName.setShorten(true);
        fields.add(serverName);

        SlackField hostName = new SlackField();
        hostName.setTitle("ERROR HOSTNAME");
        hostName.setValue(errorLog.getHostName());
        hostName.setShorten(false);
        fields.add(hostName);

        if (errorLog.getUserInfo() != null) {
            SlackField userInformation = new SlackField();
            userInformation.setTitle("USERINFO");
            userInformation.setValue(JsonUtils.toPrettyJson(errorLog.getUserInfo()));
            userInformation.setShorten(false);
            fields.add(userInformation);
        }
        
        String title = errorLog.getMessage();

        SlackAttachment slackAttachment = new SlackAttachment();
        slackAttachment.setFallback("ERROR !!");
        slackAttachment.setColor("danger");
        slackAttachment.setFields(fields);
        slackAttachment.setTitle(title);
		
        if (StringUtils.isNotEmpty(kSolutionContextConfig.getLoggingConfig().getAdminUrl())) {
            slackAttachment.setTitleLink(kSolutionContextConfig.getLoggingConfig().getAdminUrl());
        }
        slackAttachment.setText(errorLog.getTrace());
        
        SlackMessage slackMessage = new SlackMessage("");
        
        String channel = kSolutionLoggingConfig.getSlack().getChannel();

        if (!kSolutionLoggingConfig.getSlack().getChannel().startsWith("#")) {
            channel = "#" + channel;
        }

        slackMessage.setChannel(channel);
        slackMessage.setUsername(String.format("[%s] - ErrorReport", errorLog.getPhase()));
        slackMessage.setIcon(":exclamation:");
        slackMessage.setAttachments(Collections.singletonList(slackAttachment));
        slackApi.call(slackMessage);
		
	}
	
	private void toDatabase(KSolutionErrorLog errorLog) {
        errorLogService.save(errorLog);
    }
	
	public static void main(String args[]) {
		SlackApi slackApi = new SlackApi("https://hooks.slack.com/services/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");
		List<SlackField> fields = new ArrayList<>();
		
		SlackField message = new SlackField();
		message.setTitle("title");
		message.setValue("message");
		message.setShorten(false);
		fields.add(message);
		
		SlackField path = new SlackField();
		path.setTitle("Path");
        path.setValue("path..");
        path.setShorten(false);
        fields.add(path);
        
        
        SlackAttachment slackAttachment = new SlackAttachment();
        slackAttachment.setFallback("fallback");
        slackAttachment.setColor("danger");
        slackAttachment.setFields(fields);
        slackAttachment.setTitle("uuryerer");
        //slackAttachment.setText("김기dfsfsfffdf.");
        slackAttachment.setText("dkjflsjfs \\n dfjlsjfdsf \\n dfdjslfdjslfdfsdfs \\n dkfjsldfjs");
        
        slackAttachment.setTitleLink("http://www.naver.com");
        
        
        SlackMessage slackMessage = new SlackMessage("");
        
        String channel = "#ksolution"; 
        
        
        
        slackMessage.setChannel(channel);
        slackMessage.setUsername(String.format("[%s] - ErrorReportBot", "khkim"));
        slackMessage.setIcon(":exclamation:");
        slackMessage.setAttachments(Collections.singletonList(slackAttachment));
        
        slackApi.call(slackMessage);
	}

}
