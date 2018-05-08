package com.ksolution.common.domain.user.auth;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface UserAuthRepository extends KSolutionJPAQueryDSLRepository<UserAuth, UserAuthId>{
	List<UserAuth> findByUserCd(String userCd);
}
