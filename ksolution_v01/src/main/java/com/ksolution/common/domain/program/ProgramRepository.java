package com.ksolution.common.domain.program;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface ProgramRepository extends KSolutionJPAQueryDSLRepository<Program, String>{
}