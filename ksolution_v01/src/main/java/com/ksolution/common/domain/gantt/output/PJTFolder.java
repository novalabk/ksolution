package com.ksolution.common.domain.gantt.output;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Generated;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JsonNode;
import com.ksolution.common.domain.BaseJpaModel;
import com.ksolution.common.domain.program.Program;
import com.ksolution.common.domain.program.menu.Menu;

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
@Table(name = "PJTFolder_M")
@Comment(value = "메뉴")
@ToString
public class PJTFolder extends BaseJpaModel<Long> implements Cloneable{
	
	@Id
	@Column(name = "OID")
	@Comment(value = "ID")
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@ColumnPosition(1)
	private Long oid;
	
	@Column(name="ProjectInfo_ID", nullable = false)
	@Comment(value = "제품 ID")
	@ColumnPosition(2)
	private Long projectInfoId; //프로젝트정보 Id
	
	@Column(name = "FOLDER_NM", length = 100)
    @Comment(value = "폴더명")
    @ColumnPosition(3)
    private String folderName;
	
	@Column(name = "PARENT_ID", precision = 19 ) 
    @Comment(value = "부모 ID")
    @ColumnPosition(4)
    private Long parentId ;
	
	@Column(name = "LEVEL", precision = 10)
    @Comment(value = "레벨")
    @ColumnPosition(5)
    private Integer level;

    @Column(name = "SORT", precision = 10)
    @Comment(value = "정렬")
    @ColumnPosition(6)
    private Integer sort;
    
    @Transient
    private boolean open = false;
    
    @Transient
    private List<PJTFolder> children = new ArrayList<>();
 	
	@Override
	public Long getId() {
		return oid;
	}

	public void addChildren(PJTFolder folder) {
		children.add(folder);
	}
	
	
	@JsonProperty("name")
    public String label() {
        return folderName; 
    }

    @JsonProperty("id")
    public Long id() {
        return oid;
    }
	
}
