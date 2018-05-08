package com.ksolution;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Import;
import org.springframework.context.annotation.PropertySource;

import com.boot.ksolution.core.KSolutionCoreConfiguration;
import com.boot.ksolution.core.context.AppContextManager;
import com.boot.ksolution.core.jpa.InstantPersistenceConverter;

@SpringBootApplication
@EnableAutoConfiguration(exclude = {DataSourceAutoConfiguration.class, 
		DataSourceTransactionManagerAutoConfiguration.class,
		HibernateJpaAutoConfiguration.class})
@PropertySource(value = {"classpath:ksolution-common.properties", "classpath:ksolution-${spring.profiles.active:production}.properties"})
@ComponentScan({"com.ksolution","com.boot.ksolution.core.jpa"})
@Import(KSolutionCoreConfiguration.class)
public class KSolutionApplication {

	private static final Logger logger = LoggerFactory.getLogger(KSolutionApplication.class);

	
	public static void main(String[] args) {
		SpringApplication.run(KSolutionApplication.class, args);
	}
	
	
	@Bean
	public CommandLineRunner init() {

		return new CommandLineRunner() {
			public void run(String... strings) throws Exception {
				System.out.println("initBasicCode............");
				// myService.initBasicCode();*/
				AppContextManager.getBean(InstantPersistenceConverter.class);
				// myService.createPersons();
				//logger.error("kkdfjksflsfjslfdjdsdf error");
			}
		};
	}
}
