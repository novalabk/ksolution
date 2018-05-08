package com.ksolution.common.domain.gantt;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class TaskVO {
	
	List<TaskVO> children = new ArrayList<>();
	
	String name;
	
	int period;
	
	long start;
	
	long end;
	
	String uuid;
	
	private int progress;
	
	private Integer index;
	
	
	public int getChildCount() {
		return children.size();
	}
	
	public TaskVO getChildAt(int index) {
		return children.get(index);
	}
	
	
}
