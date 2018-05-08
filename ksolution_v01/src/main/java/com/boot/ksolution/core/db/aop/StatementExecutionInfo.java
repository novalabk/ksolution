package com.boot.ksolution.core.db.aop;
import org.apache.commons.lang3.StringUtils;

import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * statement 문과 query문과 파라미터 정보를 가지고 있다.
 * @author jkeei
 *
 */
public class StatementExecutionInfo {
	StatementType statementType;
	String queryFormat;
	List<Object> currentParameters;
	String firstBatchQuery;
	AtomicInteger batchCount = new AtomicInteger(0);

	public StatementExecutionInfo(Statement statement) {
		this.statementType = StatementType.getStatementType(statement);
		this.currentParameters = new ArrayList<>();
	}

	public StatementType getStatementType() {
		return this.statementType;
	}

	public void setQueryFormat(String queryFormat) {
		this.queryFormat = StringUtils.trim(queryFormat);
	}

	public String getQueryFormat() {
		return this.queryFormat;
	}

	public List<Object> getCurrentParameters() {
		return this.currentParameters;
	}

	public String getFirstBatchQuery() {
		return this.firstBatchQuery;
	}

	public void setFirstBatchQuery(String firstBatchQuery) {
		this.firstBatchQuery = firstBatchQuery;
	}

	public void incrementBatchCount() {
		this.batchCount.incrementAndGet();
	}

	public int getBatchCount() {
		return this.batchCount.get();
	}
}
