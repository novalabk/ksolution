package com.ksolution.common.domain.user;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;

@Repository
public interface UserRepository extends KSolutionJPAQueryDSLRepository<User, String>{
}
