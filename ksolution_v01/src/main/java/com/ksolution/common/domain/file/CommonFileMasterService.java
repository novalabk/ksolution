package com.ksolution.common.domain.file;

import javax.inject.Inject;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.boot.ksolution.core.code.Types;
import com.ksolution.common.domain.BaseService;
import com.querydsl.core.BooleanBuilder;

import lombok.extern.slf4j.Slf4j;

@Service
public class CommonFileMasterService extends BaseService<CommonFileMaster, Long>{
	
	private CommonFileMasterRepository commonFileMasterRepository;
	
	@Inject
	public CommonFileMasterService(CommonFileMasterRepository commonFileRepository) {
		super(commonFileRepository);
		this.commonFileMasterRepository = commonFileMasterRepository;
	}
	
	@Transactional
	public CommonFileMaster getInstance(String targetType, String targetId, String fileNm) {
		CommonFileMaster master = get(targetType, targetId, fileNm);
		if(master != null) {
			return master;
		}
		
		master = CommonFileMaster.of(targetType, targetId, fileNm);
		
		String extension = FilenameUtils.getExtension(fileNm).toUpperCase();
 
        String fileType = getFileType(extension);
        
        master.setExtension(extension);
        
        master.setFileType(fileType);
        
		master = save(master);
		
		return master;
		
	}
	
	public CommonFileMaster get(String targetType, String targetId, String fileNm) {
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(qCommonFileMaster.targetType.eq(targetType));
		builder.and(qCommonFileMaster.targetId.eq(targetId));
		builder.and(qCommonFileMaster.fileNm.toLowerCase().eq(fileNm.toLowerCase()));
		CommonFileMaster master = select().from(qCommonFileMaster).where(builder).fetchOne();
		return master;
	}
	
	
	public String getFileType(String extension) {
        switch (extension.toUpperCase()) {
        case Types.FileExtensions.PNG:
        case Types.FileExtensions.JPG:
        case Types.FileExtensions.JPEG:
        case Types.FileExtensions.GIF:
        case Types.FileExtensions.BMP:
        case Types.FileExtensions.TIFF:
        case Types.FileExtensions.TIF:
            return Types.FileType.IMAGE;

        case Types.FileExtensions.PDF:
            return Types.FileType.PDF;

        default:
            return Types.FileType.ETC;
        }
	}
	
}
