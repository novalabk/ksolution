package com.ksolution.common.domain.file;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.boot.ksolution.core.code.KSolutionTypes;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
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
@Table(name = "FILEMASTER_L", 
uniqueConstraints=
@UniqueConstraint(columnNames=
{"TARGET_TYPE", "TARGET_ID", "FILE_NM"}))
@Comment(value = "공통 파일")
@ToString
public class CommonFileMaster extends BaseJpaModel<Long> {
	@Id
    @Column(name = "ID")
    @Comment(value = "ID")
    @ColumnPosition(1)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "TARGET_TYPE", length = 50)
    @Comment(value = "타겟 TYPE")
    @ColumnPosition(2)
    private String targetType;

    @Column(name = "TARGET_ID", length = 100)
    @Comment(value = "타겟 ID")
    @ColumnPosition(3)
    private String targetId;

    @Column(name = "FILE_NM", columnDefinition = "TEXT")
    @Comment(value = "실제 파일명")
    @ColumnPosition(4)
    private String fileNm;
    
    @Column(name = "FILE_TYPE", length = 30)
    @Comment(value = "파일 타입")
    @ColumnPosition(7)
    private String fileType;

    @Column(name = "EXTENSION", length = 10)
    @Comment(value = "확장자")
    @ColumnPosition(8)
    private String extension;

	
    @Override
	public Long getId() {
		// TODO Auto-generated method stub
		return id; 
	}
    
    public static CommonFileMaster of(String targetType, String targetId, String fileNm) {
    	CommonFileMaster master = new CommonFileMaster();
    	master.setTargetType(targetType);
    	master.setTargetId(targetId);
    	master.setFileNm(fileNm);
    	return master;
    }

}
