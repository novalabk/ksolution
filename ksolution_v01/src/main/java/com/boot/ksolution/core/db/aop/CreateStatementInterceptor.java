package com.boot.ksolution.core.db.aop;
import org.aopalliance.intercept.MethodInterceptor;
import org.aopalliance.intercept.MethodInvocation;
import org.apache.commons.lang3.StringUtils;
import org.springframework.aop.framework.Advised;
import org.springframework.aop.framework.ProxyFactory;
import org.springframework.aop.support.AopUtils;

import com.boot.ksolution.core.db.monitor.sql.SqlExecutionInfo;
import com.boot.ksolution.core.db.monitor.sql.SqlTaskPool;

import java.lang.reflect.Method;
import java.sql.Statement;
import java.util.Map;

/**
 * 
 * createStatement, prepareStatement, prepareCall 함수의 리던인 
 * statement를 proxy하여 수행정보를 로그로 찍으려고
 * @author khkim
 *
 */
public class CreateStatementInterceptor implements MethodInterceptor {

    private static final String[] CREATE_STATEMENT_METHOD = {"createStatement", "prepareStatement", "prepareCall"};

    private String dataSourceId;

    private String databaseType;

    private Long slowQueryThreshold;

    
    //statement정보 및 paramter 정보를 가지고 있다. statement close 될때까지 가지고  활동하다가 close되면 제거
    private Map<Statement, StatementExecutionInfo> statementInfoMap; 

    private SqlTaskPool sqlTaskPool; //sql 수행정보 타임아웃,실행시간 등등을 관리한다. 1000정도만.

    private boolean sqlOutput;

    public CreateStatementInterceptor(String dataSourceId, String databaseType, Long slowQueryThreshold,
                                      Map<Statement, StatementExecutionInfo> statementInfoMap,
                                      SqlTaskPool sqlTaskPool, boolean sqlOutput) {
        this.dataSourceId = dataSourceId;
        this.databaseType = databaseType;
        this.slowQueryThreshold = slowQueryThreshold;
        this.statementInfoMap = statementInfoMap;
        this.sqlTaskPool = sqlTaskPool;
        this.sqlOutput = sqlOutput;
    }

    @Override
    public Object invoke(MethodInvocation invocation) throws Throwable {
        Object returnValue = invocation.proceed();
        Method invokedMethod = invocation.getMethod();

        if (StringUtils.indexOfAny(invokedMethod.getName(), CREATE_STATEMENT_METHOD) == -1) {
            return returnValue;
        }

        Statement statement = getRealStatement(returnValue);

        if (!statementInfoMap.containsKey(statement)) {
            StatementExecutionInfo statementExecutionInfo = new StatementExecutionInfo(statement);

            if (statementExecutionInfo.getStatementType() != StatementType.statement) {
                String queryFormat = (String) invocation.getArguments()[0];
                statementExecutionInfo.setQueryFormat(queryFormat);

                SqlExecutionInfo sqlExecutionInfo = sqlTaskPool.get(queryFormat);

                if (sqlExecutionInfo.isNew()) {
                    sqlExecutionInfo.setDataSourceId(dataSourceId);
                    sqlExecutionInfo.setType(statementExecutionInfo.getStatementType());
                }
            }
            statementInfoMap.put(statement, statementExecutionInfo);
        }

        ProxyFactory proxyFactory = new ProxyFactory();
        proxyFactory.addAdvice(new StatementMethodInterceptor(dataSourceId, databaseType, slowQueryThreshold, statementInfoMap, sqlTaskPool, sqlOutput));
        proxyFactory.setTarget(returnValue);
        proxyFactory.setInterfaces(returnValue.getClass().getInterfaces());
        return proxyFactory.getProxy();
    }

    private Statement getRealStatement(Object returnValue) throws Throwable {
        if (AopUtils.isAopProxy(returnValue)) {
            Advised advised = (Advised) returnValue;
            return (Statement) advised.getTargetSource().getTarget();
        }
        return (Statement) returnValue;
    }
}
