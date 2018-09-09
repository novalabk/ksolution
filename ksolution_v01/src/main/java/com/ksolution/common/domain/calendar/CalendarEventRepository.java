package com.ksolution.common.domain.calendar;

import org.springframework.stereotype.Repository;

import com.boot.ksolution.core.domain.base.KSolutionJPAQueryDSLRepository;
@Repository
public interface CalendarEventRepository extends KSolutionJPAQueryDSLRepository<CalendarEvent, Long>{
}
