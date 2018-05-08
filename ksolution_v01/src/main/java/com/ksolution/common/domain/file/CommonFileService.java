package com.ksolution.common.domain.file;



import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.persistence.Table;
import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaDelete;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;
import javax.persistence.criteria.Subquery;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.hibernate.annotations.NamedQuery;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.boot.ksolution.core.code.KSolutionTypes;
import com.boot.ksolution.core.code.Types;
import com.boot.ksolution.core.parameter.RequestParams;
import com.boot.ksolution.core.utils.EncDecUtils;
import com.ksolution.common.domain.BaseJpaModel;
import com.ksolution.common.domain.BaseService;
import com.ksolution.common.domain.gantt.output.PJTFolderSearchVO;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.JPAExpressions;
import com.querydsl.jpa.JPQLQuery;
import com.querydsl.jpa.impl.JPAQuery;

import lombok.extern.slf4j.Slf4j;
import net.coobird.thumbnailator.Thumbnails;
import net.coobird.thumbnailator.geometry.Positions;
import net.coobird.thumbnailator.name.Rename;

@Service
@Slf4j
/*@NamedQuery(
		update(qCommonFile).set(qCommonFile.lastest, true).where(qCommonFile.versionIndex.eq(
  			  JPAExpressions.select(qCommonFile.versionIndex.max()).from(subTable) 
  			  .where(subTable.masterId.eq(masterId)
  					  .and(subTable.versionIndex.lt(versionIndex))
  			))).execute();
		
	    name="update",
	    query="update file_l a set latest = 1 where  versionIndex <= (select max(sub.versionIndex) from file_l sub where sub.mastereid = 0 and sub.versionIndex < 9);"
	    		+ " 
	)*/
public class CommonFileService extends BaseService<CommonFile, Long> implements InitializingBean{
	private CommonFileRepository commonFileRepository;
	
	private CommonFileMasterService masterSerivce;
	
	@Value("${ksolution.upload.repository}")
	public String uploadRepository;

	@Value("${ksolution.upload.temp}")
	public String tempDir;
	
	@Inject
	public CommonFileService(CommonFileRepository commonFileRepository, CommonFileMasterService masterSerivce) {
		super(commonFileRepository);
		this.commonFileRepository = commonFileRepository;
		this.masterSerivce = masterSerivce;
	}
	
	public void createBaseDirectory() {
        try {
            FileUtils.forceMkdir(new File(uploadRepository));
        } catch (IOException e) {
        }
    }
	
	@Override
	public void afterPropertiesSet() throws Exception {
		createBaseDirectory();
	}
	
	public String getTempDir() {
	   //return System.getProperty("java.io.tmpdir");
    	return tempDir;
    }
	
	/** 
	 * @param multipartFile
	 * @return
	 * @throws IOException
	 * @author khkim
	 * @description MultipartFile객체를 file로 리턴
	 */
	public File multiPartFileToFile(MultipartFile multipartFile) throws IOException {
        String baseDir = getTempDir() + "/" + UUID.randomUUID().toString();

        FileUtils.forceMkdir(new File(baseDir));

        String tmpFileName = baseDir + "/" + FilenameUtils.getName(multipartFile.getOriginalFilename());

        File file = new File(tmpFileName);

        multipartFile.transferTo(file);
        return file;
    }
	
	/**
	 * @param multipartFile
	 * @return
	 * @throws IOException
	 * @author jkeei
	 * @description MultipartFile 객체를 tempDir에 유니크한 폴더를 만들지 않고 유니크한 파일로 리턴한다.
	 */
	public File multiPartFileToFileWithoutFolder(MultipartFile multipartFile) throws IOException {
        String tempFileName = getTempDir() + "/" + UUID.randomUUID().toString() + "." + FilenameUtils.getExtension(multipartFile.getOriginalFilename());

        FileUtils.forceMkdir(new File(getTempDir()));

       // String tmpFileName = baseDir + "/" + FilenameUtils.getName(multipartFile.getOriginalFilename());

        File file = new File(tempFileName);

        multipartFile.transferTo(file);
        return file;
    }
	
	
	/*public int getMaxId(String targetType, String targetId) {
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(qCommonFile.targetId.eq(targetId));
		builder.and(qCommonFile.targetType.eq(targetType));
		
		JPAQuery<Integer> query = select().select(qCommonFile.sort.max().coalesce(0));
    	query.from(qCommonFile).where(builder);
    	int max = query.fetchOne();
    	return max;
	}*/
	
	public int getMaxVersionIndex(CommonFileMaster master) {
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(qCommonFile.master.eq(master));
		
		JPAQuery<Integer> query = select().select(qCommonFile.versionIndex.max().coalesce(0));
    	query.from(qCommonFile).where(builder);
    	int max = query.fetchOne();
    	return max;
	}
	
	@Transactional
	public CommonFile upload(MultipartFile multipartFile, String targetType, String targetId)throws IOException{
		return upload(multiPartFileToFile(multipartFile), targetType, targetId);
	}
		
	
	@Transactional
    public CommonFile upload(MultipartFile multipartFile,  BaseJpaModel<Long> entity, int sort) throws IOException {
    	String targetType = getTargetType(entity);
    	String targetId = String.valueOf(entity.getId());
    	return upload(multiPartFileToFile(multipartFile), targetType, targetId);
    }
	
	public String getTargetType(BaseJpaModel<Long> entity) {
		String targetType = entity.getClass().getAnnotation(Table.class).name();
    	return targetType;
	}
	
	public String getTargetType(Class<?> cl) {
		String targetType = cl.getAnnotation(Table.class).name();
		return targetType;
	}
	
	@Transactional
	public CommonFile upload(File file, String targetType, String targetId)throws IOException{
		UploadParameters uploadParameters = new UploadParameters();
		uploadParameters.setFile(file);
		uploadParameters.setTargetType(targetType);
		uploadParameters.setTargetId(targetId);
		//uploadParameters.setSort(sort);
		
		return upload(uploadParameters);
	}
	
	@Transactional
    public CommonFile upload(UploadParameters uploadParameters) throws IOException {
		File uploadFile = uploadParameters.getFile();
		if(uploadFile == null && uploadParameters.getMultipartFile() != null) {
			uploadFile = multiPartFileToFile(uploadParameters.getMultipartFile());
		}
		
		String targetType = uploadParameters.getTargetType();
        String targetId = uploadParameters.getTargetId();
        String desc = uploadParameters.getDesc();
		
        boolean deleteIfExist = uploadParameters.isDeleteIfExist();
        boolean thumbnail = uploadParameters.isThumbnail();
        
        int sort = uploadParameters.getSort();
        int thumbnailWidth = uploadParameters.getThumbnailWidth();
        int thumbnailHeight = uploadParameters.getThumbnailHeight();
        
        String fileName = FilenameUtils.getName(uploadFile.getName());
        String extension = FilenameUtils.getExtension(fileName);
        
        String fileType = masterSerivce.getFileType(extension);
        
        String baseName = UUID.randomUUID().toString();
        String saveName = baseName + "." + extension;
        String savePath = getSavePath(saveName);
        
        File file = new File(savePath);
        FileUtils.copyFile(uploadFile, file);
        
        if (deleteIfExist) {
            deleteByTargetTypeAndTargetId(targetType, targetId);
        }
        
        CommonFile commonFile = new CommonFile();
        
        CommonFileMaster master = masterSerivce.getInstance(targetType, targetId, fileName);
        
        commonFile.setMaster(master);
        
        commonFile.setSaveNm(saveName);
        //commonFile.setSort(sort);
        commonFile.setDesc(desc);
        //commonFile.setFileType(fileType);
        //commonFile.setExtension(FilenameUtils.getExtension(fileName).toUpperCase());
        commonFile.setFileSize(file.length());
        
        if (fileType.equals(Types.FileType.IMAGE) && thumbnail) {
            try {
                Thumbnails.of(file)
                        .crop(Positions.CENTER)
                        .size(thumbnailWidth, thumbnailHeight)
                        .toFiles(new File(getBasePath()), Rename.SUFFIX_HYPHEN_THUMBNAIL);
            } catch (Exception e) {
            }
        }
        
        FileUtils.deleteQuietly(uploadFile);
        
       // System.out.println("master == " + master);
        updateLatest(master);
        
        commonFile.setVersionIndex(getMaxVersionIndex(master) + 1);
        
        
        save(commonFile);

        return commonFile;
        
	}
	
	@Transactional
	private void updateLatest(CommonFileMaster master) {
		// TODO Auto-generated method stub
		update(qCommonFile).set(qCommonFile.lastest, false)
		.where(qCommonFile.master.eq(master)).execute();
	}
	
	
	public String getBasePath() {
	    return uploadRepository;
	}

    public String getSavePath(String saveName) {
        return getBasePath() + "/" + saveName;
    }
    
    
    @Transactional
    public void deleteFile(CommonFile file) {
    	if(file.isLastest()) {
    		setLatestPreFile(file);
    	}
    	delete(file);
    	long masterId = file.getMasterId();
    	if(!isFile(masterId)) {
    		//System.out.println("masterId delete");
    		masterSerivce.delete(masterId);
    	}
        //delete(qCommonFile).where(qCommonFile.id.eq(id)).execute();
    }
    
    
    @Transactional
    public void deleteFile(List<CommonFile> files) {
    	for(CommonFile file : files) {
    		deleteFile(file);
    	}
    }
    
    public boolean isFile(long masterId) {
    	long count = select().select(qCommonFile.id.count()).from(qCommonFile)
    	.where(qCommonFile.masterId.eq(masterId)).fetchOne();
    	
    	return count > 0;
    }
    
    public List<CommonFile> getListFromMaster(long masterId){
    	List<CommonFile> list =select().from(qCommonFileMaster).where(qCommonFile.masterId.eq(masterId)).fetch();
    	return list;
    }
    
    
    
    
    @Transactional
    public void setLatestPreFile(CommonFile file) {
    	
    	//String tableName = getTargetType(file);
    	
    	/*Query updateQuery = em.createQuery("UPDATE file_l SET latest = 1 WHERE enabled=true AND versionIndex IN (SELECT id FROM MyClasroom WHERE ...)");
        updateQuery.setParameter("phoneNo", "phoneNo");
        ArrayList<Long> paramList = new ArrayList<Long>();
        paramList.add(123L);
        updateQuery.setParameter("ids", paramList);
        int nrUpdated = updateQuery.executeUpdate();*/
    	
    	/*long masterId = file.getMasterId();
    	int versionIndex = file.getVersionIndex();
    	QCommonFile subTable = new QCommonFile("c1");
    	
  
    		
    	
    	update(qCommonFile).set(qCommonFile.lastest, true).where(qCommonFile.versionIndex.eq(
    			  JPAExpressions.select(qCommonFile.versionIndex.max()).from(subTable) 
    			  .where(subTable.masterId.eq(masterId)
    					  .and(subTable.versionIndex.lt(versionIndex))
    			))).execute();
*/    	
    	
    	//getPreFile(file);
    	
    	int versionIndex = getPreFileVerIndex(file);
    	
    	update(qCommonFile).set(qCommonFile.lastest, true).where(qCommonFile.versionIndex.eq(versionIndex)).execute();
  			  
    }
    
    
    public int getPreFileVerIndex(CommonFile file) {
    	 long masterId = file.getMasterId();
    	 int versionIndex = file.getVersionIndex();
    	 QCommonFile subTable = new QCommonFile("c1");
    	 
    	// System.out.println("versionIndex =============== " + versionIndex );
    	
    	 int preVersionIndex = select().select(qCommonFile.versionIndex.max().coalesce(-1)).from(qCommonFile)
    			 .where(qCommonFile.masterId.eq(masterId)
    			 .and(qCommonFile.versionIndex.lt(versionIndex))).fetchOne();
    
    	// System.out.println("preverIndex =============== " + preVersionIndex );
    	 
    	 return preVersionIndex;
    	
    }
    
    @Transactional
    public void deleteByTargetTypeAndTargetIds(String targetType, Set<String> targetIds) {
   
    	
    	delete(qCommonFile).where(qCommonFile.masterId.in(
        		JPAExpressions.select(qCommonFileMaster.id).from(qCommonFileMaster)
                .where(qCommonFileMaster.targetType.eq(targetType).and(qCommonFileMaster.targetId.in(targetIds)))
        		).as("kkk")).execute();
    	
       // delete(qCommonFile).where(qCommonFile.master.targetType.eq(targetType).and(qCommonFile.master.targetId.in(targetIds))).execute();
    }
    
    @Transactional
    private void deleteByTargetTypeAndTargetId(String targetType, String targetId) {
    	
        delete(qCommonFile).where(qCommonFile.masterId.in(
        		JPAExpressions.select(qCommonFileMaster.id).from(qCommonFileMaster)
                .where(qCommonFileMaster.targetType.eq(targetType).and(qCommonFileMaster.targetId.eq(targetId)))
        		)).execute();
    
       /* new JPASubQuery().from(employee.department.employees, e)
        .where(e.manager.eq(employee.manager))
        .unique(e.weeklyhours.avg())*/
    }
    
    
    public ResponseEntity<InputStreamResource> downloadById(Long id)throws IOException{
    	CommonFile commonFile = findOne(id);
    	return downloadStream(commonFile);
    }
    
    public ResponseEntity<byte[]> download(CommonFile commonFile) throws IOException {
    	if(commonFile == null) {
    		return null;
    	}
    	byte[] bytes = FileUtils.readFileToByteArray(new File(getSavePath(commonFile.getSaveNm())));
    	
    	String fileName = EncDecUtils.encodeDownloadFileName(commonFile.getMaster().getFileNm());
    	
    	HttpHeaders httpHeaders = new HttpHeaders();
    	httpHeaders.setContentType(MediaType.APPLICATION_OCTET_STREAM);
    	
    	httpHeaders.setContentLength(bytes.length);
        httpHeaders.setContentDispositionFormData("attachment", fileName);

        return new ResponseEntity<>(bytes, httpHeaders, HttpStatus.OK);
    }
    
    public ResponseEntity<InputStreamResource> downloadStream(CommonFile commonFile) throws IOException {
    	MediaType mediaType = MediaType.APPLICATION_OCTET_STREAM;
    	String savePath = getSavePath(commonFile.getSaveNm());
    	
    	String fileName = EncDecUtils.encodeDownloadFileName(commonFile.getMaster().getFileNm());
    	File file = new File(savePath);
        InputStreamResource resource = new InputStreamResource(new FileInputStream(file));
    	return ResponseEntity.ok()
    			.header(HttpHeaders.CONTENT_DISPOSITION, "attachment;filename=" + fileName)
    			.contentType(mediaType)
    			.contentLength(file.length())
    			.body(resource);
    }
    
    public Page<CommonFile> getList(RequestParams<CommonFile> requestParams){
    	String targetType = requestParams.getString("targetType", "");
        String targetId = requestParams.getString("targetId", "");
        String delYn = requestParams.getString("delYn", "");
        String targetIds = requestParams.getString("targetIds", "");
        requestParams.addSort("sort", Sort.Direction.ASC);
        requestParams.addSort("id", Sort.Direction.ASC);
        
        Pageable pageable = requestParams.getPageable();
        
        BooleanBuilder builder = new BooleanBuilder();
        
        if(isNotEmpty(targetType)) {
        	builder.and(qCommonFile.master.targetType.eq(targetType));
        }
        
        if (isNotEmpty(targetId)) {
            builder.and(qCommonFile.master.targetId.eq(targetId));
        }
        
        if (isNotEmpty(delYn)) {
            KSolutionTypes.Deleted deleted = KSolutionTypes.Deleted.get(delYn);
            builder.and(qCommonFile.delYn.eq(deleted));
        }
        
        if(isNotEmpty(targetIds)) {
        	Set<String> _ids = Arrays.stream(targetIds.split(",")).collect(Collectors.toSet());
        	builder.and(qCommonFile.master.targetId.in(_ids));
        }
        
        builder.and(qCommonFile.lastest.eq(true));
        
       /*if(isNotEmpty(contentType)) {
        	builder.and(qCommonFile.contentType.eq(contentType));
        }*/
        
        JPQLQuery<CommonFile> query = select().from(qCommonFile)
    	.innerJoin(qCommonFile.master, qCommonFileMaster)
    	.where(builder);
        
        return commonFileRepository.buildPage(query, query, pageable);
        //return findAll(builder, pageable);
    }
    
    public Page<CommonFile> getListForProjectOutput(PJTFolderSearchVO searchVO){
    	String targetType = searchVO.getTargetType();
        String targetId = "";
        if(searchVO.getTargetId() != null) {
        	targetId = String.valueOf(searchVO.getTargetId());
        }
        long projectInfoId = searchVO.getProjectInfoId();
        Set<String> targetIds = searchVO.getTargetIds();
        String searchKeyWord = searchVO.getSearchKeyWord();
        
        List<Sort.Order> sortOrders = new ArrayList<>();
        sortOrders.add(new Sort.Order(Sort.Direction.ASC, "sort"));
        sortOrders.add(new Sort.Order(Sort.Direction.ASC, "id"));
        
        JPQLQuery<CommonFile> query = select().from(qCommonFile)
            	.innerJoin(qCommonFile.master, qCommonFileMaster);
            	
        
        Pageable pageable = new PageRequest(0, Integer.MAX_VALUE, new Sort(sortOrders));
        
        BooleanBuilder builder = new BooleanBuilder();
        
        if(isNotEmpty(targetType)) {
        	builder.and(qCommonFile.master.targetType.eq(targetType));
        }
        
        if (isNotEmpty(targetId) && targetIds.size() < 2) {
            builder.and(qCommonFile.master.targetId.eq(targetId));
        }else {
        	query.from(qPjtFolder);
        	//query.where(qCommonFile.master.targetId.eq(qPjtFolder.oid.stringValue())); 
        	builder.and(qCommonFile.master.targetId.eq(qPjtFolder.oid.stringValue()));
        	builder.and(qPjtFolder.projectInfoId.eq(projectInfoId));
        }
        
        if(isNotEmpty(searchKeyWord)) {
        	
        	
        	builder.and(qCommonFile.master.fileNm.upper().like("%" + searchKeyWord.toUpperCase() + "%"));
        }
        
        if(targetIds.size() > 1) {
        	builder.and(qCommonFile.master.targetId.in(targetIds));
        }
        
        builder.and(qCommonFile.lastest.eq(true));
        
        
        query.where(builder);
       /*if(isNotEmpty(contentType)) {
        	builder.and(qCommonFile.contentType.eq(contentType));
        }*/
        
        
        
        return commonFileRepository.buildPage(query, query, pageable);
        //return findAll(builder, pageable);
    }
    
    public List<CommonFile> getFiles(String targetType, Long targetId){
    	BooleanBuilder builder = new BooleanBuilder();

    	builder.and(qCommonFile.master.targetType.eq(targetType));
    	builder.and(qCommonFile.master.targetId.eq(targetId.toString()));
    	
    	List<CommonFile> list = select().from(qCommonFile)
    	.innerJoin(qCommonFile.master, qCommonFileMaster)
    	.where(builder).fetch();
    	
    	return list;
    }
    
    public CommonFile get(RequestParams<CommonFile> requestParams) {
        List<CommonFile> commonFiles = getList(requestParams).getContent();
        return isEmpty(commonFiles) ? null : commonFiles.get(0);
    }
    
    public CommonFile get(String targetType, String targetId) {
        RequestParams<CommonFile> requestParams = new RequestParams<>(CommonFile.class);
        requestParams.put("targetType", targetType);
        requestParams.put("targetId", targetId);
        return get(requestParams);
    }

	public List<CommonFile> versionList(long masterId) {
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(qCommonFile.masterId.eq(masterId));
		return findAll(builder);
	}
    
    /*@Transactional
    public void updateOrDelete(List<CommonFile> commonFileList) {
    	for(CommonFile file : commonFileList) {
    		if(file.isDeleted()) {
    			deleteFile(file.getId());
    		} else {
    			update(qCommonFile).set(qCommonFile.master.targetType, file.getMaster().getTargetType())
    			.set(qCommonFile.master.targetId, file.getMaster().getTargetId())
    			.where(qCommonFile.id.eq(file.getId())).execute();
    		}
    	}
    }*/

    /*@Transactional
	public void deleteFiles(List<Long> ids) {
		for(long id : ids) {
			deleteFile(id);
		}
	}*/
    
}
