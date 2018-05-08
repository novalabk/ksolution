package com.ksolution.common.domain.gantt;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface ProjectInfoRepository extends KSolutionJPAQueryDSLRepository<ProjectInfo, Long>{
}
