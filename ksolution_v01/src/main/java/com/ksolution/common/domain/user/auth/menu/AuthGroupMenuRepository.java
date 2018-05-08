package com.ksolution.common.domain.user.auth.menu;

import javax.inject.Inject;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface AuthGroupMenuRepository extends KSolutionJPAQueryDSLRepository<AuthGroupMenu, AuthGroupMenu.AuthGroupMenuId>{
	
}