package com.ksolution.common.utils;
import java.util.List;
import java.util.Map;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.context.AppContextManager;
import com.boot.ksolution.core.parameter.RequestParams;
import com.boot.ksolution.core.utils.JsonUtils;
import com.ksolution.common.domain.code.CommonCode;
import com.ksolution.common.domain.code.CommonCodeService;

import static java.util.stream.Collectors.groupingBy;

public class CommonCodeUtils {
    
    public static List<CommonCode> get(String groupCd) {
        RequestParams<CommonCode> requestParams = new RequestParams<>(CommonCode.class);
        requestParams.put("groupCd", groupCd);
        requestParams.put("useYn", KSolutionTypes.Used.YES.getLabel());
        return getService().get(requestParams);
    }

    public static Map<String, List<CommonCode>> getAllByMap() {
        RequestParams<CommonCode> requestParams = new RequestParams<>(CommonCode.class);
        requestParams.put("useYn", KSolutionTypes.Used.YES.getLabel());
        List<CommonCode> commonCodes = getService().get(requestParams);

        Map<String, List<CommonCode>> commonCodeMap = commonCodes.stream().collect(groupingBy(CommonCode::getGroupCd));

        return commonCodeMap;
    }

    public static String getAllByJson() {
        return JsonUtils.toJson(getAllByMap());
    }


    public static CommonCodeService getService() {
        return AppContextManager.getBean(CommonCodeService.class);
    }
}
