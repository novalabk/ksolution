package com.ksolution.common.domain;

import java.io.Serializable;
import java.time.Clock;
import java.time.Instant;

import javax.persistence.Column;
import javax.persistence.Convert;
import javax.persistence.MappedSuperclass;
import javax.persistence.PostLoad;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Transient;

import org.apache.commons.lang3.StringUtils;
import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.hibernate.annotations.TypeDef;
import org.hibernate.annotations.TypeDefs;

import org.springframework.data.domain.Persistable;

import com.boot.ksolution.core.annotations.ColumnPosition;
import com.boot.ksolution.core.context.AppContextManager;
import com.boot.ksolution.core.db.type.LabelEnumType;
import com.boot.ksolution.core.db.type.MySQLJSONUserType;
import com.boot.ksolution.core.jpa.InstantPersistenceConverter;
import com.boot.ksolution.core.utils.SessionUtils;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.ksolution.common.domain.base.KSolutionCrudModel;
import com.ksolution.common.domain.user.User;
import com.ksolution.common.utils.CommonUtil;

import lombok.Getter;
import lombok.Setter;

@TypeDefs({
	@TypeDef(name = "jsonNode", typeClass = MySQLJSONUserType.class, parameters = {@org.hibernate.annotations.Parameter(name = MySQLJSONUserType.CLASS, value = "com.fasterxml.jackson.databind.JsonNode")}),
	@TypeDef(name = "labelEnum", typeClass = LabelEnumType.class
	//의미가 없는 거 같다.parameters = {@org.hibernate.annotations.Parameter(name = MySQLJSONUserType.CLASS, value = "com.boot.ksolution.core.db.type.LabelEnumType")}
   )
})

@Setter
@Getter
@MappedSuperclass //entity 상위클래스 선언
@DynamicInsert   //set한것만 insert한다.
@DynamicUpdate  //변경된 컬럼만 업데이트한다.
public abstract class BaseJpaModel<PK extends Serializable> extends KSolutionCrudModel implements Persistable<PK>, Serializable {
	@Override
    @JsonIgnore
    public boolean isNew() {
        return null == getId();
    }
	
	@JsonProperty("generatedcreatedAt")
    @JsonFormat(shape=JsonFormat.Shape.STRING, pattern="yyyy-MM-dd HH:mm:ss", timezone="GMT")
    @Column(name = "CREATED_AT", updatable = false)
    @ColumnPosition(Integer.MAX_VALUE - 4)
	@Convert(converter = InstantPersistenceConverter.class) 
    protected Instant createdAt;
	
	@Column(name = "CREATED_BY", updatable = false)
    @ColumnPosition(Integer.MAX_VALUE - 3)
    protected String createdBy;
	
	@Column(name = "UPDATED_AT")
    @ColumnPosition(Integer.MAX_VALUE - 2)
	@Convert(converter = InstantPersistenceConverter.class) 
    protected Instant updatedAt;
	
	@Column(name = "UPDATED_BY")
    @ColumnPosition(Integer.MAX_VALUE - 1)
    protected String updatedBy;
	
	//@Transient
	//protected User createdUser;
	
	//@Transient
    //protected User modifiedUser;
	
	@Transient
	@JsonIgnore
	protected String _creatorNm;
	
	@JsonProperty("creatorNm")
    public String creatorNm() { 
        if (StringUtils.isEmpty(_creatorNm) && !StringUtils.isEmpty(createdBy)) {
            User user = CommonUtil.getUserService().getByCd(createdBy);
            _creatorNm = user.getUserNm();
        }
        return _creatorNm;
    }
	
	@PrePersist
    protected void onPersist() {
        this.createdBy = this.updatedBy = SessionUtils.getCurrentLoginUserCd();
        this.createdAt = this.updatedAt = Instant.now(Clock.systemUTC());
    }
	
	@PreUpdate
    protected void onUpdate() {
        this.updatedBy = SessionUtils.getCurrentLoginUserCd();
        this.updatedAt = Instant.now(Clock.systemUTC());
    }
	
	@PostLoad
    protected void onPostLoad() {
    }
	
}
