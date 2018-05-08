(function () {
    if (axboot && axboot.def) {
    	
        axboot.def["DEFAULT_TAB_LIST"] = [
            {menuId: 19, id: 19, progNm:"WEBList", menuNm:"WBSList", progPh: '/jsp/project/wbs-list.jsp', url: CONTEXT_PATH + '/jsp/project/wbs-list.jsp', status: "on", fixed: true}
        ];
     
        axboot.def["API"] = { 
            "users": "/api/v1/users",
            "commonCodes": "/api/v1/commonCodes", 
            "programs": "/api/v1/programs",
            "menu": "/api/v2/menu",
            "manual": "/api/v1/manual",
            "errorLogs": "/api/v1/errorLogs",
            "files": "/api/v1/ax5uploader",
            //"files": "/api/v1/files",  
            
            "samples": "/api/v1/samples",
            "basicCode": "/api/v2/basicCode",
            "gantt" : "/api/v1/gantt",
            "pjtFolder" : "/api/v2/pjtFolder",
            "project": "/api/v1/project", 
            "projectInfo" : "/api/v1/projectInfo",
            "material": "/api/v1/material",
            "discompany":"/api/v1/discompany",
            "spBasket" :"/api/v1/spBasket",
            "mfcompanys" : "/api/v1/mfcompanys"
        };

        axboot.def["MODAL"] = {
            "ZIPCODE": {
                width: 500,
                height: 500,
                iframe: {
                    url: "/pms/jsp/common/zipcode.jsp"
                }
            },
            "PROJECT_MATERIAL": {
                width: 1280,
                height: 700,
                iframe: {
                    url: "/jsp/project/project-material.jsp"
                },
            },
            "MATERIAL_LIST": {
                width: 1024,
                height: 500,
                iframe: {
                    url: "/jsp/material/select-material-list.jsp"
                },
            },
            "BASKET_LIST": {
                width: 1024,
                height: 500,
                iframe: {
                    url: "/jsp/basket/select-basket-list.jsp"
                },
            },
            "SAMPLE-MODAL": {
                width: 500,
                height: 500,
                zIndex : 5020,
                iframe: {
                    url: "/jsp/_samples/modal.jsp"
                },
              //  header: false
            },
            "COMMON_CODE_MODAL": {
                width: 600,
                height: 400,
                iframe: {
                    url: "/jsp/system/system-config-common-code-modal.jsp"
                },
                header: false
            },
            
            "SAVE_GANTT" :{
             	 width: 500,
                 height: 250, 
                 iframe: {
                     url: CONTEXT_PATH + "/jsp/project/gantt_save_modal.jsp"  
                 }
            },
            
            "DOC_VERSION_LIST" : {
            	width : 670, 
            	heigth : 350,
            	iframe : {
            		url : CONTEXT_PATH + "/jsp/common/version_list_modal.jsp"  
            	}
            }
        };
    }


    var preDefineUrls = {
        "manual_downloadForm": "/api/v1/manual/excel/downloadForm",
        "manual_viewer": "/jsp/system/system-help-manual-view.jsp"
    };
    axboot.getURL = function (url) {
        if (ax5.util.isArray(url)) {
            if (url[0] in preDefineUrls) {
                url[0] = preDefineUrls[url[0]];
            }
            return url.join('/');

        } else {
            return url;
        }
    }
})();