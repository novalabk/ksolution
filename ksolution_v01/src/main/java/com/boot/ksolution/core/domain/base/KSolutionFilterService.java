package com.boot.ksolution.core.domain.base;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.boot.ksolution.core.utils.FilterUtils;


public class KSolutionFilterService<T> {
	public boolean recursionListFilter(List<T> lists, String searchParams) {
        return FilterUtils.recursionListFilter(lists, searchParams);
    }

    public List<T> filter(List<T> lists, String searchParams) {
        return FilterUtils.filter(lists, searchParams);
    }

    public Page<T> filter(List<T> lists, Pageable pageable, String searchParams) {
        return FilterUtils.filterWithPaging(lists, pageable, searchParams);
    }
}
