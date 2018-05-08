package com.boot.ksolution.core.db.dbcp;

import java.sql.Connection;

import org.modelmapper.ModelMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.ui.ModelMap;

import com.boot.ksolution.core.config.KSolutionContextConfig;


/**
 * @author khkim
 *
 */
public class KSolutionDataSourceFactory {
	private static Logger logger = LoggerFactory.getLogger(KSolutionDataSourceFactory.class);
	
	public static KSolutionDBCP2DataSource create(String dataSourceId, KSolutionContextConfig.DataSourceConfig dataSourceConfig)throws Exception{
		try {
			KSolutionDBCP2DataSource kSolutionDBCP2DataSource = new ModelMapper().map(dataSourceConfig, KSolutionDBCP2DataSource.class);
			kSolutionDBCP2DataSource.setDatabaseType(dataSourceConfig.getHibernateConfig().getDatabaseType());
			Connection conn = kSolutionDBCP2DataSource.getConnection();
			conn.close();
			logger.info("sucess to create DataSource('{}')", dataSourceId);
			return kSolutionDBCP2DataSource;
		} catch(Exception exception) {
			logger.error("fail to create DataSource('{}')", dataSourceId);
			throw exception;
		}
	}
	
	public static KSolutionDBCP2DataSource create(KSolutionContextConfig.DataSourceConfig dataSourceConfig)throws Exception{
		return create("MainDataSource", dataSourceConfig);
	}
}
