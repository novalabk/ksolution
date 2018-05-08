package com.ksolution.common.domain.program.menu;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface MenuRepository extends KSolutionJPAQueryDSLRepository<Menu, Long>{
}