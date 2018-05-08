package com.ksolution.common.domain.log;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface ErrorLogRepository extends KSolutionJPAQueryDSLRepository<ErrorLog, Long>{
}
