package com.ksolution.common.domain.calendar;

import java.time.Instant;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.ksolution.common.utils.CustomDateTimeDeserializer;

import lombok.Data;

@Data
public class GanttHolidayVo {

	@JsonProperty("start")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy/MM/dd", timezone="Asia/Seoul")
    protected Date start;
	
	@JsonProperty("end")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy/MM/dd", timezone="Asia/Seoul") 
    protected Date end;
	
	protected String text;
}
