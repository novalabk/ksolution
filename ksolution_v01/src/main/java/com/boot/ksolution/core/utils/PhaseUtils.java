package com.boot.ksolution.core.utils;

import org.springframework.context.EnvironmentAware;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import com.boot.ksolution.core.code.KSolutionTypes;

@Component
public class PhaseUtils implements EnvironmentAware{

	private static Environment environment;
	@Override
	public void setEnvironment(Environment _environment) {
		environment = _environment;
		phase();
	}
	
	/** spring.profiles.active 에 샛팅된 값을 가져옴
	 * @return
	 */
	public static String phase() {
		String[] activeProfiles = environment.getActiveProfiles();
		String activeProfile = KSolutionTypes.ApplicationProfile.LOCAL;
		if (activeProfiles != null && activeProfiles.length > 0) {
            activeProfile = activeProfiles[0];
        }
		return activeProfile;
	}
	
	public static boolean isLocal() {
        return phase().equals(KSolutionTypes.ApplicationProfile.LOCAL);
    }

    public static boolean isAlpha() {
        return phase().equals(KSolutionTypes.ApplicationProfile.ALPHA);
    }

    public static boolean isBeta() {
        return phase().equals(KSolutionTypes.ApplicationProfile.BETA);
    }

    public static boolean isProduction() {
        return phase().equals(KSolutionTypes.ApplicationProfile.PRODUCTION);
    }

    public static Environment getEnvironment() {
        return environment;
    }

    public static boolean isDevelopmentMode() {
        return isLocal() || Boolean.parseBoolean(System.getProperty("ksolution.profiles.development"));
    }

}
