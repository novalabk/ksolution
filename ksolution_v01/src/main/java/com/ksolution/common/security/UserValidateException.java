package com.ksolution.common.security;

import org.springframework.security.access.AccessDeniedException;

public class UserValidateException extends AccessDeniedException{

	public UserValidateException(String msg) {
		super(msg);
	}
	
	/**
	 * Constructs an <code>AccessDeniedException</code> with the specified message and
	 * root cause.
	 *
	 * @param msg the detail message
	 * @param t root cause
	 */
	public UserValidateException(String msg, Throwable t) {
		super(msg, t);
	}

}
