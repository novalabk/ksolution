package com.ksolution.common.domain.gantt.output;

import com.boot.ksolution.core.code.LabelEnum;

public enum MoveType implements LabelEnum{
	
	inner("inner"),
	next("next"),
	prev("prev");
	
	private final String label;
	
	MoveType(String label){
		this.label = label;
	}

	@Override
	public String getLabel() {
		// TODO Auto-generated method stub
		return this.label;
	}

	
}
