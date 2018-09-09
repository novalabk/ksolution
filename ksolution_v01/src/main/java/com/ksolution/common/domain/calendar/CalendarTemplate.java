package com.ksolution.common.domain.calendar;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.jpa.JsonNodeConverter;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import com.ksolution.common.domain.BaseJpaModel;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "CalendarTemplate_T")
public class CalendarTemplate extends BaseJpaModel<Long> {

	@Id
	@Column(name = "OID")
	@Comment(value = "ID")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@ColumnPosition(1)
	private Long oid;
	
	@Column(name = "Calendar_NM", length = 100)
    @Comment(value = "달력이름")
    @ColumnPosition(2)
    private String calendarNm;
	
	@Column(name = "MULTI_LANGUAGE", length = 100)
    @Comment(value = "달력이름 다국어 필드")
    @ColumnPosition(3)
    @Convert(converter = JsonNodeConverter.class)
    private JsonNode multiLanguageJson;

	
	@Column(name = "gCalId", length = 300)
	@Comment(value = "google calendar Id")
	@ColumnPosition(4)
	private String googleCalendarId;
	
	
	@Column(name = "DESC_C", length = 3000)
	@Comment(value = "Description")
	@ColumnPosition(5)
	private String description;
	
	@Override
	public Long getId() {
		return oid;
	}
}
