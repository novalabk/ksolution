package com.ksolution.common.domain.calendar;

import java.time.Instant;
import java.util.ArrayList;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Type;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.jpa.InstantPersistenceConverter;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.ksolution.common.domain.BaseJpaModel;
import com.ksolution.common.domain.gantt.ProjectInfo;
import com.ksolution.common.domain.program.Program;
import com.ksolution.common.domain.program.menu.Menu;
import com.ksolution.common.utils.CustomDateTimeDeserializer;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "CalendarEvent_T")
public class CalendarEvent extends BaseJpaModel<Long>{

	@Id
	@Column(name = "OID", precision = 20, nullable = false)
    @Comment(value = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnPosition(1) 
    private Long oid;
	
	@JsonProperty("title")
	@Column(name= "event_title", nullable=false, length = 200)
	@Comment(value = "title")
	@ColumnPosition(2)
	private String title;
	
	@JsonProperty("start")
	@JsonDeserialize(using=CustomDateTimeDeserializer.class)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone="Asia/Seoul")
    @Column(name = "startDate")
    @ColumnPosition(3)
	@Convert(converter = InstantPersistenceConverter.class) 
    protected Instant startDate;
	
	@JsonProperty("end")
	@JsonDeserialize(using=CustomDateTimeDeserializer.class)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone="Asia/Seoul")
    @Column(name = "endDate")
    @ColumnPosition(4)
	@Convert(converter = InstantPersistenceConverter.class) 
    protected Instant endDate;
	
	@Column(name = "isHoliday", length = 1)
    @Type(type = "labelEnum")
	@ColumnPosition(5)
    private KSolutionTypes.IsHoliday isHoliday = KSolutionTypes.IsHoliday.YES;
	
	@Column(name = "DESC_C", length = 3000)
	@Comment(value = "Description")
	@ColumnPosition(6)
	private String description;
	
	@Column(name = "gCalId", length = 200)
	@Comment(value = "google_calendar_Id")
	@ColumnPosition(7)
	private String gCalId;
	
	@Column(name = "tempId", length = 50)
    @Comment(value = "CalendarTemplate")
    @ColumnPosition(8)
    private Long tempId;

    @ManyToOne
    @JoinColumn(name = "tempId", referencedColumnName = "oid", insertable = false, updatable = false)
    private CalendarTemplate template;
    
    @Column(name = "projectInfoId", length = 50)
    @Comment(value = "ProjectInfo")
    @ColumnPosition(9)
    private Long projectInfoId;

    @ManyToOne
    @JoinColumn(name = "projectInfoId", referencedColumnName = "oid", insertable = false, updatable = false)
    private ProjectInfo projectInfo;
    
	
	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return oid;
	}
	
	@JsonProperty("editable")
	public boolean editable() {
		return this.gCalId == null || gCalId.length() == 0;
	}

}
