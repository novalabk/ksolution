package com.ksolution.common.domain.gantt;

import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.boot.ksolution.core.jpa.InstantPersistenceConverter;
import com.boot.ksolution.core.jpa.JsonNodeConverter;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.ksolution.common.domain.BaseJpaModel;
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
@Table(name = "ProjectInfo_T")
public class ProjectInfo extends BaseJpaModel<Long>{
	
	@Id
	@Column(name = "OID", precision = 20, nullable = false)
    @Comment(value = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnPosition(1) 
    private Long oid;
	
	@Column(name = "CODE", unique=true, nullable=false, length = 200, updatable = false) 
	@Comment(value = "CODE")
	@ColumnPosition(2)
	private String code;
	
	@Column(name= "PROJECT_NM", nullable=false, length = 200)
	@Comment(value = "PROJECTNAME")
	@ColumnPosition(3)
	private String name;
	

	@JsonDeserialize(using=CustomDateTimeDeserializer.class)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone="GMT+9")
    @Column(name = "START_DATE")
    @Comment(value = "프로젝트 시작일")
    @ColumnPosition(4)
	@Convert(converter = InstantPersistenceConverter.class)
    private Instant startDate;
	
	
	@JsonDeserialize(using=CustomDateTimeDeserializer.class)
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd", timezone="GMT+9")
    @Column(name = "END_DATE")
    @Comment(value = "프로젝트 종료일")
    @ColumnPosition(5)
	@Convert(converter = InstantPersistenceConverter.class)
    private Instant endDate;
	
	@Column(name = "DESC_T", length = 3000)
	@Comment(value = "Description")
	@ColumnPosition(6)
	private String description;
	
	
	@Column(name = "PJTSTATE", length = 50)
	@Comment(value = "project State")
	@ColumnPosition(7)
	private String pjtState;
	
	
	@Transient
	private String stateDisplay;
	
	
/*	@Column(name = "GANTT_JSON_DATA", length = 100000)
    @ColumnPosition(7)*/
	@Transient
    @Convert(converter = JsonNodeConverter.class)
    private JsonNode ganttData;
	
	
	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return oid;
	}
	
}
