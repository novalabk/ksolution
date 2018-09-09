package com.ksolution.common.domain.calendar;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Convert;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.jpa.InstantPersistenceConverter;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.ksolution.common.utils.CustomDateTimeDeserializer;

import lombok.Data;

@Data
public class SimpleEventVo {
	
	Long oid;
	
	@JsonProperty("start")
	@JsonDeserialize(using=CustomDateTimeDeserializer.class)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone="Asia/Seoul")
    protected Instant startDate;
	
	@JsonProperty("end")
	@JsonDeserialize(using=CustomDateTimeDeserializer.class)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone="Asia/Seoul") 
    protected Instant endDate;
}
