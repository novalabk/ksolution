package com.boot.ksolution.core.domain.base;

import java.io.Serializable;
import java.util.Collections;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.querydsl.QueryDslPredicateExecutor;
import org.springframework.data.repository.NoRepositoryBean;

import com.querydsl.jpa.JPQLQuery;

@NoRepositoryBean
public interface KSolutionJPAQueryDSLRepository<T, ID extends Serializable> extends JpaRepository<T, ID>, QueryDslPredicateExecutor<T> {
	
	default Page<T> buildPage(JPQLQuery countQuery, JPQLQuery query, Pageable pageable) {
		Long total = countQuery.fetchCount();
		query.offset(pageable.getOffset());
		query.limit(pageable.getPageSize());
		List<T> content = total > pageable.getOffset() ? query.fetch() : Collections.<T>emptyList();
		return new PageImpl<T>(content, pageable, total);
	}
}
