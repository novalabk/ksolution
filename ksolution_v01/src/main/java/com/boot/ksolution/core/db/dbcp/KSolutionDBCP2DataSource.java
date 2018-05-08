package com.boot.ksolution.core.db.dbcp;


import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLFeatureNotSupportedException;
import java.sql.Statement;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.aop.framework.ProxyFactory;

import com.boot.ksolution.core.db.aop.CreateStatementInterceptor;
import com.boot.ksolution.core.db.aop.StatementExecutionInfo;
import com.boot.ksolution.core.db.monitor.sql.SqlTaskPool;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class KSolutionDBCP2DataSource extends BasicDataSource {
	/*실행된 sql문과 SqlExecutionInfo(sql수행하면서 걸린 시간 error회수 ..등등 정보) 키와 value로 가지고 있다 */
	private SqlTaskPool sqlTaskPool = new SqlTaskPool();
    
	/* 참고로 putIfAbsent 사용하면 존재하면 put을 못하는 함수가 있다. 여기에서는 사용안함  걍  put 함수사용
	 * statement 가 close될때까지 StatementExecutionInfo 에 파라미터를 넣어주면 정보관리 
	 */
    private ConcurrentHashMap<Statement, StatementExecutionInfo> statementInfoMap = new ConcurrentHashMap<>();

    private String dataSourceId;

    private String databaseType;

    private Long slowQueryThreshold;

    private boolean useStatementCache = false;

    private int statementCacheSize = 250;

    private boolean sqlOutput = false;
    
    
    @Override
    public Connection getConnection() throws SQLException {
        Connection connection = super.getConnection();
        return createProxy(connection);
    }

    @Override
    public Connection getConnection(String user, String pass) throws SQLException {
        Connection connection = super.getConnection(user, pass);
        return createProxy(connection);
    }

    @Override
    public synchronized void close() throws SQLException {
        super.close();
    }
    
    private Connection createProxy(Connection originalConnection) {
        ProxyFactory proxyFactory = new ProxyFactory();
        proxyFactory.setTarget(originalConnection);
        proxyFactory.addAdvice(new CreateStatementInterceptor(getDataSourceId(), getDatabaseType(), getSlowQueryThreshold(), getStatementInfoMap(), getSqlTaskPool(), isSqlOutput()));
        proxyFactory.setInterfaces(new Class[]{Connection.class});
        return (Connection) proxyFactory.getProxy();
    }

    @Override
    public Logger getParentLogger() throws SQLFeatureNotSupportedException {
        return null;
    }
}
