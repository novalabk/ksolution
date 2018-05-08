package com.ksolution.common.domain.gantt;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.boot.ksolution.core.jpa.JsonNodeConverter;
import com.fasterxml.jackson.databind.JsonNode;
import com.ksolution.common.domain.BaseJpaModel;


import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(
	name = "GanttJsonData_M"
)
@Comment(value = "칸드 JsonData 이력관리를 위해 저장")
@ToString
public class GanttJsonData extends BaseJpaModel<Long> implements Cloneable {
	
	
	@Id
	@Column(name = "OID", precision = 20, nullable = false)
    @Comment(value = "ID")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @ColumnPosition(1) 
    private Long oid;
	
	
	@Column(name="ProjectInfo_ID", precision = 20, nullable = false)
	@Comment(value = "projectInfo")
	@ColumnPosition(2) 
	private Long projectInfoId;  //브렌드
	
	@ManyToOne
	@JoinColumn(name = "ProjectInfo_ID", referencedColumnName = "OID", insertable = false, updatable = false)
	ProjectInfo projectInfo;
	
	@Column(name= "latest", columnDefinition="tinyint(1) default 1")
	@ColumnPosition(3)
	@Comment(value = "마지막 버전인지")
	private boolean latest = true;
	
	
	@Column(name= "version", length = 100, nullable = false)
	@ColumnPosition(4)
	@Comment(value = "버전")
	private String version = "00";
	
	
	@Column(name = "GANTT_JSON_DATA", length = 100000)
    @ColumnPosition(5)
    @Convert(converter = JsonNodeConverter.class)
    private JsonNode ganttData;
	
	@Column(name= "node", length = 3000)
	@ColumnPosition(6)
	@Comment(value = "버전 변경시 노트")
	private String note;
	
	@Override
	public Long getId() {
		// TODO Auto-generated method stub
		return oid;
	}

}
