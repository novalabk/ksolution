package com.ksolution.common.domain.base;
import javax.persistence.Transient;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;


import lombok.Data;

/**
 * table이나 grid 저장 삭제시 쓰임.
 * @author khkim
 *
 */
@Data
public abstract class KSolutionCrudModel {
	
	@Transient
    @JsonProperty("__deleted__")
    protected boolean __deleted__;

	@Transient 
    @JsonProperty("__created__")
    protected boolean __created__;

    @Transient
    @JsonProperty("__modified__")
    protected boolean __modified__;
	
	
	@Transient
	public KSolutionTypes.DataStatus getDataStatus(){
		if(__deleted__) {
			return KSolutionTypes.DataStatus.DELETED;
		}
		if(__created__) {
			return KSolutionTypes.DataStatus.CREATED;
		}
		if(__modified__) {
			return KSolutionTypes.DataStatus.MODIFIED;
		}
		
		return KSolutionTypes.DataStatus.ORIGIN;
	}
	
	@Transient
    @JsonIgnore
    public boolean isDeleted() {
        return __deleted__;
    }

    @Transient
    @JsonIgnore
    public boolean isCreated() {
        return __created__;
    }

    @Transient
    @JsonIgnore
    public boolean isModified() {
        return __modified__;
    }

}
