package com.ksolution.common.domain.init;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import javax.inject.Inject;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.code.Types;
import com.boot.ksolution.core.db.schema.SchemaGenerator;
import com.boot.ksolution.core.utils.JsonUtils;
import com.ksolution.common.domain.code.CommonCode;
import com.ksolution.common.domain.code.CommonCodeService;
import com.ksolution.common.domain.program.Program;
import com.ksolution.common.domain.program.ProgramService;
import com.ksolution.common.domain.program.menu.Menu;
import com.ksolution.common.domain.program.menu.MenuService;
import com.ksolution.common.domain.user.User;
import com.ksolution.common.domain.user.UserService;
import com.ksolution.common.domain.user.auth.UserAuth;
import com.ksolution.common.domain.user.auth.UserAuthService;
import com.ksolution.common.domain.user.auth.menu.AuthGroupMenu;
import com.ksolution.common.domain.user.auth.menu.AuthGroupMenuService;
import com.ksolution.common.domain.user.role.UserRole;
import com.ksolution.common.domain.user.role.UserRoleService;


@Service
public class DatabaseInitService {
	@Inject
    private SchemaGenerator schemaGenerator;
	
	@Inject
    private JdbcTemplate jdbcTemplate;
	
	@Inject
    private UserService userService;
	
	@Inject
    private UserRoleService userRoleService;
	
	@Inject
    private UserAuthService userAuthService;
	
	@Inject
    private ProgramService programService;
	
	@Inject
    private MenuService menuService;
	
	@Inject
    private CommonCodeService commonCodeService;
	
	@Inject
    private AuthGroupMenuService authGroupMenuService;


	
	public void init() throws Exception {
        createSchema();
    }
	
	public void createSchema() throws Exception{
		dropSchema();
		schemaGenerator.createSchema();
		createDefaultData();
	}
	
	public void dropSchema() {
        try {
            List<String> tableList = schemaGenerator.getTableList();

            tableList.forEach(table -> {
                jdbcTemplate.update("DROP TABLE " + table);
            });
        } catch (Exception e) {
            // ignore
        }
    }
	
	
	
	public void createDefaultData() throws IOException {
		User user = new User();
        user.setUserCd("system");
        user.setUserNm("시스템 관리자");
        user.setUserPs("$2a$11$ruVkoieCPghNOA6mtKzWReZ5Ee66hbeqwvlBT1z.W4VMYckBld6uC");
        user.setUserStatus(Types.UserStatus.NORMAL);
        user.setLocale("ko_KR");
        user.setMenuGrpCd("SYSTEM_MANAGER");
        user.setUseYn(KSolutionTypes.Used.YES);
        user.setDelYn(KSolutionTypes.Deleted.NO);
        userService.save(user);
        
        UserRole aspAccess = new UserRole();
        aspAccess.setUserCd("system");
        aspAccess.setRoleCd("ASP_ACCESS");   //user role security에서 쓰임.
        
        UserRole systemManager = new UserRole();
        systemManager.setUserCd("system");
        systemManager.setRoleCd("SYSTEM_MANAGER");
        userRoleService.save(Arrays.asList(aspAccess, systemManager));
        
        UserAuth userAuth = new UserAuth();
        userAuth.setUserCd("system");
        userAuth.setGrpAuthCd("S0001");  
        userAuthService.save(userAuth);
        
        saveUser("test", "test", "S0002"); //test 일반 유저 비밀번호는 1234
        
        programService.save(Program.of("api", "API", "/swagger-ui.html", "_self", "N", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("axboot-js", "[API]axboot.js", "/jsp/_apis/axboot-js.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));  
        programService.save(Program.of("login", "로그인", "/jsp/login.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("main", "메인", "/jsp/main.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("system-auth-user", "사용자 관리", "/jsp/system/system-auth-user.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("system-config-common-code", "공통코드 관리", "/jsp/system/system-config-common-code.jsp", "_self", "Y", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("system-config-menu", "메뉴 관리", "/jsp/system/system-config-menu.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("system-config-program", "프로그램 관리", "/jsp/system/system-config-program.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("system-operation-log", "에러로그 관리", "/jsp/system/system-operation-log.jsp", "_self", "Y", "Y", "N", "N", "N", "N", "N", "N", "N", "N"));
        
        /*Gantt*/
        programService.save(Program.of("gantt-save", "CREATE WBS", "/jsp/project/gantt-save.jsp", "_self", "Y", "N", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("wbs-list", "WBS LIST", "/jsp/project/wbs-list.jsp", "_self", "Y", "Y", "N", "N", "N", "N", "N", "N", "N", "N"));
        
        
        /*샘플*/ 
        programService.save(Program.of("ax5ui-sample", "UI 템플릿", "/jsp/_samples/ax5ui-sample.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("basic", "기본 템플릿", "/jsp/_samples/basic.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("grid-form", "그리드&폼 템플릿", "/jsp/_samples/grid-form.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("grid-modal", "그리드&모달 템플릿", "/jsp/_samples/grid-modal.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("grid-tabform", "그리드&폼탭 템플릿", "/jsp/_samples/grid-tabform.jsp", "_self", "Y", "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("horizontal-layout", "상하 레이아웃", "/jsp/_samples/horizontal-layout.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("page-structure", "페이지 구조", "/jsp/_samples/page-structure.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("tab-layout", "탭 레이아웃", "/jsp/_samples/tab-layout.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        programService.save(Program.of("vertical-layout", "좌우 레이아웃", "/jsp/_samples/vertical-layout.jsp", "_self", "N", "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        
        
        
        menuService.save(Menu.of(1L, "SYSTEM_MANAGER", "시스템 관리", JsonUtils.fromJson("{\"ko\":\"시스템 관리\",\"jp\":\"システム管理\",\"en\":\"System Management\"}"), null, 0, 0, null));
                
        menuService.save(Menu.of(2L, "SYSTEM_MANAGER", "공통코드 관리", JsonUtils.fromJson("{\"ko\":\"공통코드 관리\",\"jp\":\"共通コード\",\"en\":\"CommonCode Mgmt\"}"), 1L, 1, 0, "system-config-common-code"));
        menuService.save(Menu.of(3L, "SYSTEM_MANAGER", "프로그램 관리", JsonUtils.fromJson("{\"ko\":\"프로그램 관리\",\"jp\":\"プログラム管理\",\"en\":\"Program Mgmt\"}"), 1L, 1, 1, "system-config-program"));
        menuService.save(Menu.of(4L, "SYSTEM_MANAGER", "메뉴 관리", JsonUtils.fromJson("{\"ko\":\"메뉴 관리\",\"jp\":\"メニュー管理\",\"en\":\"Menu Mgmt\"}"), 1L, 1, 2, "system-config-menu"));
        menuService.save(Menu.of(5L, "SYSTEM_MANAGER", "사용자 관리", JsonUtils.fromJson("{\"ko\":\"사용자 관리\",\"jp\":\"ユーザ管理\",\"en\":\"User Mgmt\"}"), 1L, 1, 3, "system-auth-user"));
        menuService.save(Menu.of(6L, "SYSTEM_MANAGER", "에러로그 관리", JsonUtils.fromJson("{\"ko\":\"에러로그 관리\",\"jp\":\"エラーログ 管理\",\"en\":\"ErrorLog Mgmt\"}"), 1L, 1, 4, "system-operation-log"));
        
        
        
        
        /*샘플*/
        menuService.save(Menu.of(7L, "SYSTEM_MANAGER", "샘플", JsonUtils.fromJson("{\"ko\":\"샘플\",\"jp\":\"Samples\",\"en\":\"Samples\"}"), null, 0, 1, null));
        menuService.save(Menu.of(8L, "SYSTEM_MANAGER", "기본 템플릿", JsonUtils.fromJson("{\"ko\":\"기본 템플릿\",\"en\":\"Basic Template\"}"), 7L, 1, 4, "basic"));
        menuService.save(Menu.of(9L, "SYSTEM_MANAGER", "페이지 구조", JsonUtils.fromJson("{\"ko\":\"페이지 구조\",\"en\":\"Page Structure\"}"), 7L, 1, 0, "page-structure"));
        menuService.save(Menu.of(10L, "SYSTEM_MANAGER", "좌우 좌우 레이아웃", JsonUtils.fromJson("{\"ko\":\"좌우 레이아웃\",\"en\":\"Left-Right Layout\"}"), 7L, 1, 1, "vertical-layout"));
        menuService.save(Menu.of(11L, "SYSTEM_MANAGER", "상하 레이아웃", JsonUtils.fromJson("{\"ko\":\"상하 레이아웃\",\"en\":\"Top-Bottom Layout\"}"), 7L, 1, 2, "horizontal-layout"));
        menuService.save(Menu.of(12L, "SYSTEM_MANAGER", "탭 레이아웃", JsonUtils.fromJson("{\"ko\":\"탭 레이아웃\",\"en\":\"Tab Layout\"}"), 7L, 1, 3, "tab-layout"));
        menuService.save(Menu.of(13L, "SYSTEM_MANAGER", "그리드&폼 템플릿", JsonUtils.fromJson("{\"ko\":\"그리드&폼 템플릿\",\"en\":\"Grid&Form Template\"}"), 7L, 1, 5, "grid-form"));
        menuService.save(Menu.of(14L, "SYSTEM_MANAGER", "그리드&탭폼 템플릿", JsonUtils.fromJson("{\"ko\":\"그리드&탭폼 템플릿\",\"en\":\"Grid&Form with Tab\"}"), 7L, 1, 6, "grid-tabform"));
        menuService.save(Menu.of(15L, "SYSTEM_MANAGER", "그리드&모달 템플릿", JsonUtils.fromJson("{\"ko\":\"그리드&모달 템플릿\",\"en\":\"Grid&Modal Template\"}"), 7L, 1, 7, "grid-modal"));
        menuService.save(Menu.of(16L, "SYSTEM_MANAGER", "UI 템플릿", JsonUtils.fromJson("{\"ko\":\"UI 템플릿\",\"en\":\"UI Template\"}"), 7L, 1, 8, "ax5ui-sample"));
        
        
        /*Swagger*/
        menuService.save(Menu.of(17L, "SYSTEM_MANAGER", "Swagger", JsonUtils.fromJson("{\"ko\":\"Swagger\",\"jp\":\"Swagger\",\"en\":\"Swagger\"}"), 1L, 1, 5, "api"));
        /*Gantt*/
        menuService.save(Menu.of(18L, "SYSTEM_MANAGER", "CREATE WBS", JsonUtils.fromJson("{\"ko\":\"WBS 등록\",\"jp\":\"WBS登錄\",\"en\":\"CREATE WBS\"}"), 1L, 1, 6, "gantt-save"));
        menuService.save(Menu.of(19L, "SYSTEM_MANAGER", "WBS List", JsonUtils.fromJson("{\"ko\":\"WBS목록\",\"jp\":\"WBS目錄\",\"en\":\"WBSList\"}"), 1L, 1, 7, "wbs-list"));
        
        
        
        commonCodeService.save(CommonCode.of("USER_STATUS", "계정상태", "ACCOUNT_LOCK", "잠김", 2));
        commonCodeService.save(CommonCode.of("USER_ROLE", "사용자 롤", "API", "API 접근 롤", 6));
        commonCodeService.save(CommonCode.of("USER_ROLE", "사용자 롤", "ASP_ACCESS", "관리시스템 접근 롤", 1));
        commonCodeService.save(CommonCode.of("USER_ROLE", "사용자 롤", "SYSTEM_MANAGER", "시스템 관리자 롤", 2));
        commonCodeService.save(CommonCode.of("USER_ROLE", "사용자 롤", "ASP_MANAGER", "일반괸리자 롤", 3));
        commonCodeService.save(CommonCode.of("LOCALE", "로케일", "en_US", "미국", 2));
        commonCodeService.save(CommonCode.of("LOCALE", "로케일", "ko_KR", "대한민국", 1));
        commonCodeService.save(CommonCode.of("DEL_YN", "삭제여부", "N", "미삭제", 1));
        commonCodeService.save(CommonCode.of("USE_YN", "사용여부", "N", "사용안함", 2));
        commonCodeService.save(CommonCode.of("DEL_YN", "삭제여부", "Y", "삭제", 2));
        commonCodeService.save(CommonCode.of("USE_YN", "사용여부", "Y", "사용", 1));
        
        commonCodeService.save(CommonCode.of("USER_STATUS", "계정상태", "NORMAL", "활성", 1));
        commonCodeService.save(CommonCode.of("AUTH_GROUP", "권한그룹", "S0001", "시스템관리자", 4));
        commonCodeService.save(CommonCode.of("AUTH_GROUP", "권한그룹", "S0002", "일반사용자", 1));
        //commonCodeService.save(CommonCode.of("AUTH_GROUP", "권한그룹", "S0003", "구매조합", 2));
        //commonCodeService.save(CommonCode.of("AUTH_GROUP", "권한그룹", "H_ADMIN", "하우스스타일관리자", 3));
       
        
        commonCodeService.save(CommonCode.of("MENU_GROUP", "메뉴그룹", "SYSTEM_MANAGER", "일반 메뉴", 1));
        commonCodeService.save(CommonCode.of("MENU_GROUP", "메뉴그룹", "USER", "사용자 그룹", 2));
        
        /*메뉴별 권한 셋팅 */
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 1L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));  
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 2L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 3L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 4L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 5L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        //authGroupMenuService.save(AuthGroupMenu.of("H_ADMIN", 5L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));  //사용자 관리 권한  admin
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 6L, "Y", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 7L, "Y", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 8L, "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 9L, "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 10L, "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 11L, "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 12L, "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 13L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 14L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 15L, "N", "N", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 16L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N")); 
        
        /*Swagger*/
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 17L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0002", 17L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        
        /*Gantt*/
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 18L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0002", 18L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));
        authGroupMenuService.save(AuthGroupMenu.of("S0001", 19L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));  
        authGroupMenuService.save(AuthGroupMenu.of("S0002", 19L, "Y", "Y", "N", "N", "N", "N", "N", "N", "N"));  
        
	}
	
	
	private void saveUser(String userId, String userName, String groupCD){
    	User user = new User();
        user.setUserCd(userId);
        user.setUserNm(userName);
        user.setUserPs("$2a$11$zEBBaG7TBTdcu58jbFv4geSzKCyEriOhwPl5ycClevp8W.gA8MxFu");
        user.setUserStatus(Types.UserStatus.NORMAL);
        user.setLocale("ko_KR");
        user.setMenuGrpCd("SYSTEM_MANAGER");
        user.setUseYn(KSolutionTypes.Used.YES);
        user.setDelYn(KSolutionTypes.Deleted.NO);
        userService.save(user);
        
        UserRole aspAccess = new UserRole();
        aspAccess.setUserCd(userId);
        aspAccess.setRoleCd("ASP_ACCESS");
        userRoleService.save(Arrays.asList(aspAccess));
        
        UserAuth userAuth = new UserAuth();
        userAuth.setUserCd(userId);
        userAuth.setGrpAuthCd(groupCD);
        userAuthService.save(userAuth);
    }
	
}
