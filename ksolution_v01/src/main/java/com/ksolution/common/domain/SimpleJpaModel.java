package com.ksolution.common.domain;
import java.io.Serializable;

import javax.persistence.MappedSuperclass;

import org.hibernate.annotations.DynamicInsert;
import org.hibernate.annotations.DynamicUpdate;
import org.springframework.data.domain.Persistable;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.ksolution.common.domain.base.KSolutionCrudModel;

import lombok.Getter;
import lombok.Setter;

@Setter 
@Getter
@MappedSuperclass //entity 상위클래스 선언
@DynamicInsert   //set한것만 insert한다.
@DynamicUpdate  //변경된 컬럼만 업데이트한다.
public abstract class SimpleJpaModel<PK extends Serializable> extends KSolutionCrudModel implements Persistable<PK>, Serializable {
	
	@Override
	@JsonIgnore
	public boolean isNew() {
		return null == getId();
	}
}