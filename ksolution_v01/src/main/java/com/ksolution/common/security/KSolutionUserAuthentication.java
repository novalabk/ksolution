package com.ksolution.common.security;

import java.util.Collection;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import com.boot.ksolution.core.domain.user.SessionUser;


/** 
 *  UsernamePasswordAuthenticationToken 이것도 Authentication상속 받았다.
 *  //if(this.tokenUtils.validateToken(authToken, userDetails)) {
			  UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
			  //authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(httpRequest));
			  SecurityContextHolder.getContext().setAuthentication(authentication); 
			 //securityContext.setAuthentication(authentication);
	         //SecurityContextHolder.setContext(securityContext);  다른곳에서는    
		  //}
 * @author jkeei
 *
 */
public class KSolutionUserAuthentication implements Authentication{

	private final SessionUser user;

    private boolean authenticated = true;
    
    public KSolutionUserAuthentication(SessionUser user) {
    	this.user = user;
	}
    
	@Override
	public String getName() {
		return user.getUsername();
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return user.getAuthorities();
	}

	@Override
	public Object getCredentials() {
		return user.getPassword();
	}

	@Override
	public SessionUser getDetails() {
		return user;
	}

	@Override
	public Object getPrincipal() {
		return user.getUsername();
	}

	@Override
	public boolean isAuthenticated() {
		return authenticated;
	}

	@Override
	public void setAuthenticated(boolean isAuthenticated) throws IllegalArgumentException {
		this.authenticated = authenticated;
	}
	
}
