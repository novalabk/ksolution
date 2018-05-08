package com.ksolution.common.domain.user.role;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface UserRoleRepository extends KSolutionJPAQueryDSLRepository<UserRole, Long>{
	List<UserRole> findByUserCd(String userCd);
}
