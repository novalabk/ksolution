package com.boot.ksolution.core.message;

import java.util.Locale;
import java.util.Properties;

import org.springframework.context.support.ReloadableResourceBundleMessageSource;

public class KSolutionReloadableResourceBundleMessageSource extends ReloadableResourceBundleMessageSource{

	public Properties getAllProperties(Locale locale) {
		clearCacheIncludingAncestors();
		PropertiesHolder propertiesHolder = getMergedProperties(locale);
        return propertiesHolder.getProperties();
	}
}
