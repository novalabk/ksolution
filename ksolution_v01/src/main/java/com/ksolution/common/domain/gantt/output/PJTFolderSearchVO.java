package com.ksolution.common.domain.gantt.output;


import java.util.Set;

import lombok.Data;

@Data
public class PJTFolderSearchVO {
	private long projectInfoId;
	private String searchKeyWord;
	private Set<String> targetIds;
	private Long targetId;
	private String targetType;
}
