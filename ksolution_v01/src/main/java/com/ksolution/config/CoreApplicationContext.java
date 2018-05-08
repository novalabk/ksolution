package com.ksolution.config;

import javax.inject.Named;
import javax.persistence.EntityManagerFactory;
import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.modelmapper.ModelMapper;
import org.modelmapper.convention.MatchingStrategies;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.mapper.MapperScannerConfigurer;
import org.mybatis.spring.transaction.SpringManagedTransactionFactory;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.AdviceMode;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.annotation.Primary;
import org.springframework.context.support.PropertySourcesPlaceholderConfigurer;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import com.boot.ksolution.core.config.KSolutionContextConfig;
import com.boot.ksolution.core.db.dbcp.KSolutionDBCP2DataSource;
import com.boot.ksolution.core.db.dbcp.KSolutionDataSourceFactory;
import com.boot.ksolution.core.logging.KSolutionLogbackAppender;
import com.boot.ksolution.core.mybatis.MyBatisMapper;
import com.ksolution.common.code.GlobalConstants;
import com.ksolution.common.domain.log.KSolutionErrorLogService;

import ch.qos.logback.classic.LoggerContext;

/**
 * @author khkim
 * 
 * dataSource, entityManager, 
 * transation mybatis logger bean 셋팅  
 */

@Configuration
@EnableTransactionManagement(proxyTargetClass = true, mode = AdviceMode.PROXY)
@EnableJpaRepositories(basePackages = GlobalConstants.DOMAIN_PACKAGE)
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class CoreApplicationContext {
	
	@Bean
	@Primary
	public DataSource dataSource(@Named(value = "kSolutionContextConfig") KSolutionContextConfig kSolutionContextConfig) throws Exception{
		KSolutionDBCP2DataSource dataSource = KSolutionDataSourceFactory.create(kSolutionContextConfig.getDataSource());
		return dataSource;
	}

	/*예) @PropertySource("classpath:jdbc.properties") 
	 @Value("${jdbc.driverClassName}")
	 private String driverClassName;*/
	@Bean
	public static PropertySourcesPlaceholderConfigurer propertyPlaceholderConfigurer() {
        return new PropertySourcesPlaceholderConfigurer();
    }
	
	@Bean
    public ModelMapper modelMapper() {
        ModelMapper modelMapper = new ModelMapper();
        modelMapper.getConfiguration().setFieldMatchingEnabled(true);
        modelMapper.getConfiguration().setMatchingStrategy(MatchingStrategies.STRICT);
        return modelMapper;
    }
	
	@Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory(DataSource dataSource, KSolutionContextConfig kSolutionContextConfig) {
        LocalContainerEntityManagerFactoryBean entityManagerFactory = new LocalContainerEntityManagerFactoryBean();

        entityManagerFactory.setDataSource(dataSource);
        entityManagerFactory.setPackagesToScan(kSolutionContextConfig.getDomainPackageName());
        KSolutionContextConfig.DataSourceConfig.HibernateConfig hibernateConfig = kSolutionContextConfig.getDataSourceConfig().getHibernateConfig();
        entityManagerFactory.setJpaVendorAdapter(hibernateConfig.getHibernateJpaVendorAdapter());
        entityManagerFactory.setJpaProperties(hibernateConfig.getAdditionalProperties());
        
        return entityManagerFactory;
    }
	/*
	 * PersistenceExceptionTranslationPostProcessor를 등록해줘야 한다. 
	 * 이렇게 하면 @Repository 클래스들에 대해 자동으로 예외를 Spring의 DataAccessException으로 일괄 변환해준다.
	 */
	@Bean
    public PersistenceExceptionTranslationPostProcessor exceptionTranslation() {
        return new PersistenceExceptionTranslationPostProcessor();
    }
	
	@Bean
    public PlatformTransactionManager transactionManager(EntityManagerFactory entityManagerFactory) throws ClassNotFoundException {
        JpaTransactionManager jpaTransactionManager = new JpaTransactionManager();
        jpaTransactionManager.setEntityManagerFactory(entityManagerFactory);
        return jpaTransactionManager;
    }
	
	/*myBatis 관련 */
	@Bean
    public SpringManagedTransactionFactory managedTransactionFactory() {
        SpringManagedTransactionFactory managedTransactionFactory = new SpringManagedTransactionFactory();
        return managedTransactionFactory;
    }
	
	@Bean
    public SqlSessionFactory sqlSessionFactory(SpringManagedTransactionFactory springManagedTransactionFactory, DataSource dataSource, KSolutionContextConfig kSolutionContextConfig) throws Exception {
        SqlSessionFactoryBean sqlSessionFactoryBean = new SqlSessionFactoryBean();
        sqlSessionFactoryBean.setDataSource(dataSource);
        sqlSessionFactoryBean.setTypeAliasesPackage(GlobalConstants.DOMAIN_PACKAGE);
        sqlSessionFactoryBean.setTypeHandlers(kSolutionContextConfig.getMyBatisTypeHandlers());
        sqlSessionFactoryBean.setTransactionFactory(springManagedTransactionFactory);
        return sqlSessionFactoryBean.getObject();
    }
	
	@Bean
    public MapperScannerConfigurer mapperScannerConfigurer() throws Exception {
        MapperScannerConfigurer mapperScannerConfigurer = new MapperScannerConfigurer();
        mapperScannerConfigurer.setBasePackage(GlobalConstants.DOMAIN_PACKAGE);
        mapperScannerConfigurer.setMarkerInterface(MyBatisMapper.class);
        mapperScannerConfigurer.setSqlSessionFactoryBeanName("sqlSessionFactory");
        return mapperScannerConfigurer;
    }
	/*myBatis 관련 end */
	
	@Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() {
        return new BCryptPasswordEncoder(11);
    }
	
	/*@Bean
    public JdbcMetadataService jdbcMetadataService() {
        return new JdbcMetadataService();
    }*/
	
	/*@Bean
    public SqlMonitoringService sqlMonitoringService(DataSource dataSource) throws Exception {
        return new SqlMonitoringService(dataSource);
    }*/
	/* @NotNull
    @Size(min=4, max=10, message="아이디는 4자에서 10자 사이로 입력하세요!")
    */
	@Bean
    public LocalValidatorFactoryBean validatorFactoryBean() {	
		////https://blog.outsider.ne.kr/826
        return new LocalValidatorFactoryBean();
    }
	
	@Bean(name = "kSolutionContextConfig")
	public KSolutionContextConfig kSolutionContextConfig() {
	    return new KSolutionContextConfig();
	}
	
	@Bean
	public KSolutionLogbackAppender kSolutionLogbackAppender(KSolutionErrorLogService errorLogService, 
			KSolutionContextConfig kSolutionContextConfig) {
		LoggerContext loggerContext = (LoggerContext)LoggerFactory.getILoggerFactory();
		KSolutionLogbackAppender kSolutionLogbackAppender = new KSolutionLogbackAppender(errorLogService, kSolutionContextConfig);
		kSolutionLogbackAppender.setContext(loggerContext);
		kSolutionLogbackAppender.setName("kSolutionAppender");
		kSolutionLogbackAppender.start();
		loggerContext.getLogger("ROOT").addAppender(kSolutionLogbackAppender);
		return kSolutionLogbackAppender;
	}
	
	
}