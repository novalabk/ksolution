package com.ksolution.common.domain.user.auth.menu;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.domain.user.SessionUser;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.BaseService;
import com.ksolution.common.domain.program.ProgramService;
import com.ksolution.common.domain.program.menu.Menu;
import com.ksolution.common.domain.program.menu.MenuService;
import com.querydsl.core.BooleanBuilder;

@Service
public class AuthGroupMenuService extends BaseService<AuthGroupMenu, AuthGroupMenu.AuthGroupMenuId> {
	private AuthGroupMenuRepository authGroupMenuRepository;
	
	@Inject
    private ProgramService programService;
	
	@Inject
	private MenuService menuService;
	
	@Inject
	public AuthGroupMenuService(AuthGroupMenuRepository authGroupMenuRepository) {
		super(authGroupMenuRepository);
        this.authGroupMenuRepository = authGroupMenuRepository;
	}
	
	public AuthGroupMenuVO get(RequestParams requestParams) {
		Long menuId = requestParams.getLong("menuId");
		
		Menu menu = menuService.findOne(menuId);
		AuthGroupMenuVO authGroupMenuV2VO = new AuthGroupMenuVO();
		
		List<AuthGroupMenu> list = select().from(qAuthGroupMenu)
				.where(qAuthGroupMenu.menuId.eq(menuId))
				.orderBy(qAuthGroupMenu.createdAt.asc()).fetch();
		authGroupMenuV2VO.setList(list);
		authGroupMenuV2VO.setProgram(menu.getProgram());
		
		return authGroupMenuV2VO;
	}
	
	public AuthGroupMenu getCurrentAuthGroupMenu(Long menuId, SessionUser sessionUser) {
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(qAuthGroupMenu.grpAuthCd.in(sessionUser.getAuthGroupList()));
		builder.and(qAuthGroupMenu.menuId.eq(menuId));
		
		List<AuthGroupMenu> authorizationList = select()
				.from(qAuthGroupMenu).where(builder).fetch();
		
		AuthGroupMenu authorization = null;
		
		for(AuthGroupMenu authGroupMenu : authorizationList) {
			if(authorization == null) {
				authorization = authGroupMenu;
			} else {
				authorization.updateAuthorization(authGroupMenu);
			}
		}
		
		return authorization;
	}
	
	@Transactional
	public void saveAuth(List<AuthGroupMenu> authGroupMenuList) {
		for(AuthGroupMenu authGroupMenu : authGroupMenuList) {
			if(authGroupMenu.getUseYn() == KSolutionTypes.Used.NO) {
				delete(authGroupMenu);
			}else {
				save(authGroupMenu);
			}
		}
	}
}
