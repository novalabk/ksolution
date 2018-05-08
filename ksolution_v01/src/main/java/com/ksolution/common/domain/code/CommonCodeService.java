package com.ksolution.common.domain.code;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.BaseService;
import com.querydsl.core.BooleanBuilder;

@Service
public class CommonCodeService extends BaseService<CommonCode, CommonCodeId>{
	
	private CommonCodeRepository basicCodeRepository;
	
	@Inject
	public CommonCodeService(CommonCodeRepository basicCodeRepository) {
		super(basicCodeRepository);
		this.basicCodeRepository = basicCodeRepository;
	}
	
	public List<CommonCode> get(RequestParams requestParams) {
        String groupCd = requestParams.getString("groupCd", "");
        String useYn = requestParams.getString("useYn", "");

        String filter = requestParams.getString("filter");

        BooleanBuilder builder = new BooleanBuilder();

        if (isNotEmpty(groupCd)) {
            builder.and(qCommonCode.groupCd.eq(groupCd));
        }

        if (isNotEmpty(useYn)) {
            KSolutionTypes.Used used = KSolutionTypes.Used.get(useYn);
            builder.and(qCommonCode.useYn.eq(used));
        }

        List<CommonCode> commonCodeList = select().from(qCommonCode).where(builder).orderBy(qCommonCode.groupNm.asc(), qCommonCode.sort.asc()).fetch();

        if (isNotEmpty(filter)) {
            commonCodeList = filter(commonCodeList, filter);
        }

        return commonCodeList;
    }
	
	@Transactional
    public void saveCommonCode(List<CommonCode> basicCodes) {
        save(basicCodes);
    }
	
}
