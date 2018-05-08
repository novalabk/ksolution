package com.ksolution.common.domain.gantt;

import java.time.Instant;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.fasterxml.jackson.databind.JsonNode;
import com.ksolution.common.domain.BaseJpaModel;
import com.ksolution.common.domain.program.Program;
import com.ksolution.common.domain.program.menu.Menu;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "TASK_M")
@Comment(value = "Task")
public class Task extends BaseJpaModel<Long>{
	
	
	@Id
    @Column(name = "OID", precision = 20, nullable = false)
    @Comment(value = "OID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnPosition(1)
    private Long oid;
	
	@Column(name = "UUID", length = 100)
    @Comment(value = "UUID")
    @ColumnPosition(2)
    private String uuid;
	
	
	@Column(name = "TASK_NM", length = 100)
    @Comment(value = "테스크명")
    @ColumnPosition(3)
    private String taskNm;

	@Column(name = "PERIOD", length = 100)
    @Comment(value = "기간")
    @ColumnPosition(4)
	private int period;
	
	
	@Column(name = "START_DATE")
	@Comment(value = "테스크 시작일")
	@ColumnPosition(5)
	private Instant startDate;
	
	@Column(name = "END_DATE")
	@Comment(value = "테스크 종료일")
	@ColumnPosition(6)
	private Instant endDate;
	
	
	@Column(name = "PARENT_ID", precision = 19)
    @Comment(value = "부모 ID")
    @ColumnPosition(4)
    private Long parentId;
	
	@Column(name = "LEVEL", precision = 10)
    @Comment(value = "레벨")
    @ColumnPosition(5)
    private Integer level;
	
	@Column(name = "INDEX_CM", precision = 10)
    @Comment(value = "인덱스")
    @ColumnPosition(6)
    private Integer index;
	
	
	@Column(name = "PREDECESSOR", length = 100)
	@Comment(value = "선행")
    @ColumnPosition(7)
	String predecessor;
	
	@Column(name = "PROGRESS", precision = 10)
	@Comment(value = "진행율" )
    @ColumnPosition(8)
	private Integer progress;

	@Column(name = "RESOURCE", length = 100)
	@Comment(value = "리소스")
    @ColumnPosition(7)
	String resource;
	
	
	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return oid;
	}

}
