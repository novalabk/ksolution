package com.ksolution.common.domain.file;

import com.ksolution.common.domain.BaseJpaModel;
import com.ksolution.common.domain.program.Program;
import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.annotations.Comment;
import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.utils.SessionUtils;
import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.Type;

import java.time.Clock;
import java.time.Instant;

import javax.persistence.*;
import javax.validation.constraints.NotNull;


@Setter
@Getter
@DynamicInsert
@DynamicUpdate
@Entity
@EqualsAndHashCode(callSuper = true)
@Table(name = "FILE_L")
@Comment(value = "공통 파일")
@ToString
public class CommonFile extends BaseJpaModel<Long> {
    @Id
    @Column(name = "ID")
    @Comment(value = "ID")
    @ColumnPosition(1)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /*@Column(name = "TARGET_TYPE", length = 50)
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
    private String fileNm;*/
    
    @Column(name = "Latest")
    @Comment(value = "최신인지")
    @ColumnPosition(2)
    private boolean lastest = true;
    
    @Column(name = "VersionInfo", length = 5)
    @Comment(value = "버전")
    @ColumnPosition(3)
    private String versionInfo;
    
    @Column(name = "versionIndex", length = 5)
    @Comment(value = "버전 인텍스")
    @ColumnPosition(4)
    private int versionIndex;
    
    
   
    
    @Column(name= "MASTER_ID")
    @Comment(value = "마스터 ID")
    @NotNull
    @ColumnPosition(5)
    private Long masterId;
    
    @ManyToOne
    @JoinColumn(name = "MASTER_ID", referencedColumnName = "ID", insertable = false, updatable = false)
    private CommonFileMaster master;

    @Column(name = "SAVE_NM", columnDefinition = "TEXT")
    @Comment(value = "저장 파일명")
    @ColumnPosition(6)
    private String saveNm;


    @Column(name = "FILE_SIZE")
    @Comment(value = "파일 크기")
    @ColumnPosition(9)
    private Long fileSize;

    @Column(name = "DEL_YN", length = 1)
    @Comment(value = "삭제여부")
    @Type(type = "labelEnum")
    @ColumnPosition(10)
    private KSolutionTypes.Deleted delYn = KSolutionTypes.Deleted.NO;

    @Column(name = "FILE_DESC", columnDefinition = "TEXT")
    @Comment(value = "설명")
    @ColumnPosition(11)
    private String desc;

    /*@Column(name = "SORT")
    @Comment(value = "정렬")
    @ColumnPosition(12)
    private Integer sort;*/
    

    @JsonIgnore
    @Transient
    private String _preview;

    @JsonIgnore
    @Transient
    private String _thumbnail;

    @JsonIgnore
    @Transient
    private String _download;
    
    @JsonIgnore
    @Transient
    private String _fileNm;
 
    
    @JsonIgnore
    @Transient
    private String _extension;
   
    
    @JsonIgnore
    @Transient
    private String realPath;
    
    @JsonProperty("fileNm")
    public String fileName() {
    	if (StringUtils.isEmpty(_fileNm)) {
    		return master.getFileNm();
    	}
    	return _fileNm;
    }
    
    @JsonProperty("extension")
    public String extension() {
    	if (StringUtils.isEmpty(_extension)) {
    		return master.getExtension();
    	}
    	return _extension;
    }
    
    @JsonProperty("preview")
    public String preview() {
        if (StringUtils.isEmpty(_preview)) {
            return "/api/v1/ax5uploader/preview?id=" + getId();
        }
        return _preview;
    }

    @JsonProperty("thumbnail")
    public String thumbnail() {
        if (StringUtils.isEmpty(_thumbnail)) {
           // return "/api/v1/files/thumbnail?id=" + getId();
        	 return "/api/v1/ax5uploader/thumbnail.jpg?id=" + getId();
        }
        return _thumbnail;
    }

    @JsonProperty("download")
    public String download() {
        if (StringUtils.isEmpty(_download)) {
            return "/api/v1/ax5uploader/download?id=" + getId();
        }
        return _download;
    }

    @Transient
    public String getThumbnailFileName() {
        return FilenameUtils.getBaseName(getSaveNm()) + "-thumbnail" + "." + FilenameUtils.getExtension(getSaveNm());
    }

    @Override
    public Long getId() {
        return id;
    }
    
    @Override
    @PrePersist
    protected void onPersist() {
    	super.onPersist();
    	setMasterId(this.getMaster().getId());
        /*this.createdBy = this.updatedBy = SessionUtils.getCurrentLoginUserCd();
        this.createdAt = this.updatedAt = Instant.now(Clock.systemUTC());*/
    }
    
}
