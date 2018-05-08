package com.ksolution.common.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.context.ConfigurableWebApplicationContext;

/**spring.profiles.active 에 대해 변경 가능하다는 예제 
 * @author khkim
 *
 */
@Controller
public class ProfileController {
    @Autowired ConfigurableWebApplicationContext subContext;
     
    /**
     * 현재 profile 보기
     * @param model
     */
    @RequestMapping("/profile")
    public void profile(Model model){
        model.addAttribute("currentProfile", currentProfile());
    }
     
    /**
     * 운영/개발 profile 토글
     * @return
     */
    @RequestMapping("/toggleProfile")
    public String changeProfile(){
        String toChangeProfile = currentProfile().equals("product") ? "development" : "product";
 
        ConfigurableWebApplicationContext rootContext = (ConfigurableWebApplicationContext)subContext.getParent();
         
         
        // root, sub 싹다 엑티브 프로파일을 바꾼후 리프레쉬 해야 적용됨
         
        // Refreshing Root WebApplicationContext
        rootContext.getEnvironment().setActiveProfiles(toChangeProfile);
        rootContext.refresh();
         
        // Refreshing Spring-servlet WebApplicationContext
        subContext.getEnvironment().setActiveProfiles(toChangeProfile);
        subContext.refresh();
         
        return "redirect:/profile";
    }
     
    /**
     * 현재 프로파일 가져오기
     * @return
     */
    private String currentProfile(){
        String[] profiles = subContext.getEnvironment().getActiveProfiles();
         
        if( profiles.length==0 ){
            profiles = subContext.getEnvironment().getDefaultProfiles();
        }
        return profiles[0];
    }
}