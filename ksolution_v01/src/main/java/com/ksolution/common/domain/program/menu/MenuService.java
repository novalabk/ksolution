package com.ksolution.common.domain.program.menu;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.BaseService;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.JPQLQuery;

@Service
public class MenuService extends BaseService<Menu, Long>{
	private MenuRepository menuRepository;
	
	@Inject
    public MenuService(MenuRepository menuRepository) {
        super(menuRepository);
        this.menuRepository = menuRepository;
    }
	
	/** 권한이 있는 메뉴만 리턴한다.
	 * @param menuGrpCd
	 * @param authGroupList
	 * @return
	 */
	public List<Menu> getAuthorizedMenuList(String menuGrpCd, List<String> authGroupList) {
        List<Long> menuIds = select().select(qAuthGroupMenu.menuId).distinct()
        		.from(qAuthGroupMenu).where(qAuthGroupMenu.grpAuthCd.in(authGroupList)).fetch();

        RequestParams<Menu> requestParams = new RequestParams<>(Menu.class);
        requestParams.put("menuGrpCd", menuGrpCd);
        requestParams.put("menuIds", menuIds);
        requestParams.put("menuOpen", "false");

        return get(requestParams);
    }
	
	public List<Menu> get(RequestParams requestParams){
		String menuGrpCd = requestParams.getString("menuGrpCd", "");
        String progCd = requestParams.getString("progCd", "");
        String returnType = requestParams.getString("returnType", "hierarchy");
        boolean menuOpen = requestParams.getBoolean("menuOpen", true);
        List<Long> menuIds = (List<Long>) requestParams.getObject("menuIds");
        
        BooleanBuilder builder = new BooleanBuilder();
        
        if (isNotEmpty(menuGrpCd)) {
            builder.and(qMenu.menuGrpCd.eq(menuGrpCd));
        }

        if (isNotEmpty(progCd)) {
            builder.and(qMenu.progCd.eq(progCd));
        }
        
        
        
        /*나중에 서비스로 옮기자 */ 
        /*JPQLQuery query = select()
		.from(qMenu)
		.leftJoin(qMenu.program, qProgram)
		.fetchJoin()
		.where(builder)
		.orderBy(qMenu.level.asc(), qMenu.sort.asc());*/
         //menuRepository.buildPage(countQuery, query, pageable);
        
        
        List<Menu> menuList = select()
        		.from(qMenu)
        		.leftJoin(qMenu.program, qProgram)
        		.fetchJoin()
        		.where(builder)
        		.orderBy(qMenu.level.asc(), qMenu.sort.asc())
                .fetch();
        
        if (returnType.equals("hierarchy")) {
        	List<Menu> hierarchyList = new ArrayList<>();
            List<Menu> filterList = new ArrayList<>();
            
            for(Menu menu : menuList) {
            	menu.setOpen(menuOpen);
            	
            	if (menuIds != null) {
                    if (isNotEmpty(menu.getProgCd()) && !menuIds.contains(menu.getMenuId())) {
                        continue;
                    }
                }
            	
            	Menu parent = getParent(hierarchyList, menu);
            	
            	if(parent == null) {
            		hierarchyList.add(menu);
            	} else {
            		parent.addChildren(menu);
            	}
            	
            }
            
            if (menuIds != null) {
                filterNoChildMenu(filterList, hierarchyList); //program 없는 것은 버림.
            } else {
                filterList.addAll(hierarchyList);  
            }

            return filterList;
            
        }
        
        return menuList;
       	
	}

	
	public Menu getParent(List<Menu> menus, Menu menu) {
        Menu parent = menus.stream().filter(m -> m.getId().equals(menu.getParentId())).findAny().orElse(null);
        
        if(parent == null) {
        	for (Menu _menu : menus) {
                parent = getParent(_menu.getChildren(), menu);
                if (parent != null)
                    break;
            }
        }
        return parent;
	}
	
	public void filterNoChildMenu(List<Menu> filterList, List<Menu> startList) {
        if (isNotEmpty(startList)) {
            for (Menu menu : startList) {
                if (hasTerminalMenu(menu)) {
                    Menu parent = getParent(filterList, menu);

                    if (parent == null) {
                        filterList.add(menu.clone());
                    } else {
                        parent.addChildren(menu.clone());
                    }
                }

                if (isNotEmpty(menu.getChildren())) {
                    filterNoChildMenu(filterList, menu.getChildren());
                }
            }
        }
    }
	
	public boolean hasTerminalMenu(Menu menu) {
        boolean hasTerminalMenu = false;

        if (isNotEmpty(menu.getChildren())) {
            for (Menu _menu : menu.getChildren()) {
                hasTerminalMenu = hasTerminalMenu(_menu);

                if (hasTerminalMenu) {
                    return true;
                }
            }
        }

        if (isNotEmpty(menu.getProgCd())) {
            hasTerminalMenu = true;
        }

        return hasTerminalMenu;
    }
	
	@Transactional
    public void processMenu(MenuRequestVO menuVO) {
        saveMenu(menuVO.getList());
        deleteMenu(menuVO.getDeletedList());
    }
	
	@Transactional
    public void saveMenu(List<Menu> menus) {
        menus.forEach(m -> {
            if (isEmpty(m.getProgCd())) {
                m.setProgCd(null);
            }

            if (m.getLevel() == 0) {
                m.setParentId(null);
            }
        });

        save(menus);
        menus.stream().filter(menu -> isNotEmpty(menu.getChildren())).forEach(menu -> {
            menu.getChildren().forEach(m -> m.setParentId(menu.getId()));
            saveMenu(menu.getChildren());
        });
    }
	
	@Transactional
    public void deleteMenu(List<Menu> menus) {
        delete(menus);
        menus.stream().filter(menu -> isNotEmpty(menu.getChildren())).forEach(menu -> {
            deleteMenu(menu.getChildren());
        });
    }
	
	@Transactional
    public void updateMenu(Long id, Menu request) {
        Menu exist = findOne(id);
        exist.setMultiLanguageJson(request.getMultiLanguageJson());
        save(exist);
    }
}
