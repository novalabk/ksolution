package com.ksolution.common.domain.user.auth;

import java.io.Serializable;

import javax.persistence.Embeddable;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@Embeddable
@Data
@NoArgsConstructor
@RequiredArgsConstructor(staticName = "of")
public class UserAuthId implements Serializable{
	@NonNull
    private String userCd;

    @NonNull
    private String grpAuthCd;
    
    public static void main(String args[]) {
    	UserAuthId.of("kkk", "kdjfldkf");
    }
}
