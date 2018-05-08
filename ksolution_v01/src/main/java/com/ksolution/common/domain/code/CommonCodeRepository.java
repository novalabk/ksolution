package com.ksolution.common.domain.code;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface CommonCodeRepository extends KSolutionJPAQueryDSLRepository<CommonCode, CommonCodeId>{
}
