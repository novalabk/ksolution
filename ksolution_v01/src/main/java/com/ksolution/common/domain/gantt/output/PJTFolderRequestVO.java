package com.ksolution.common.domain.gantt.output;

import java.util.List;

import lombok.Data;

@Data
public class PJTFolderRequestVO {
	private List<PJTFolder> list;
	private List<PJTFolder> deletedList;
	private Long targetId;
	private List<Long> nodeIds;
	private MoveType moveType;
	
}
