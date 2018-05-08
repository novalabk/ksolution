package com.ksolution.common.domain.user.auth.menu;

import java.util.List;

import com.ksolution.common.domain.program.Program;

import lombok.Data;

@Data
public class AuthGroupMenuVO {

    private List<AuthGroupMenu> list;

    private Program program;
}
