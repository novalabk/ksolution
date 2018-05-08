package com.ksolution.common.domain.file;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface CommonFileRepository extends KSolutionJPAQueryDSLRepository<CommonFile, Long>{
}
