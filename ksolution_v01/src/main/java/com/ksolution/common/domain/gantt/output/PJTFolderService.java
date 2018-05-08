package com.ksolution.common.domain.gantt.output;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

import javax.inject.Inject;
import javax.transaction.Transactional;

import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;

import com.boot.ksolution.core.parameter.RequestParams;
import com.ksolution.common.domain.BaseService;
import com.ksolution.common.domain.file.CommonFile;
import com.ksolution.common.domain.file.CommonFileService;
import com.ksolution.common.domain.program.menu.Menu;
import com.querydsl.core.BooleanBuilder;
import com.querydsl.jpa.impl.JPAUpdateClause;

@Service
public class PJTFolderService extends BaseService<PJTFolder, Long>{
	
	private PJTFolderRepository pjtFolderRepository;
	
	@Inject
	CommonFileService fileService;
	
	@Inject
	public PJTFolderService(PJTFolderRepository pjtFolderRepository) {
		super(pjtFolderRepository);
		this.pjtFolderRepository = pjtFolderRepository;
	}
	
	public List<PJTFolder> get(RequestParams requestParams){
		
		List<PJTFolder> list = new ArrayList<PJTFolder>();
		
		String projectId = requestParams.getString("projectInfoId", "");
		
		boolean menuOpen = requestParams.getBoolean("menuOpen", true);
		
		BooleanBuilder builder = new BooleanBuilder();
		
		if(isNotEmpty(projectId)) {
			long project_id = Long.parseLong(projectId);
			builder.and(qPjtFolder.projectInfoId.eq(project_id));
		}else {
			return list;
		}
		
		list = select()
				.from(qPjtFolder)
				.where(builder)
				.orderBy(qPjtFolder.level.asc(), qPjtFolder.sort.asc())  
				.fetch(); 
		List<PJTFolder> hierarchyList = new ArrayList<>();
		List<PJTFolder> filterList = new ArrayList<>();
        
		for(PJTFolder folder : list) {
			folder.setOpen(menuOpen);
			PJTFolder parent = getParent(hierarchyList, folder);
			
			if(parent == null) {
				hierarchyList.add(folder);
			}else {
				parent.addChildren(folder);
			}
		}
		filterList.addAll(hierarchyList);
		return filterList;
	}
	
	public PJTFolder getParent(List<PJTFolder> list, PJTFolder folder) {
		PJTFolder parent = list.stream().filter(m -> m.getId().equals(folder.getParentId())).findAny().orElse(null);
		if(parent == null) {  //업으면 리스트들으 하위도 싹 몽탕 뒤져서 찿아봄
			for(PJTFolder _folder : list) {
				parent = getParent(_folder.getChildren(), folder);
				if (parent != null)
                    break;
			}
		}
		return parent;
	}
	
	@Transactional
	public void processPJTFolder(PJTFolderRequestVO folderVO) {
		if(folderVO.getList() != null) {
			saveFolder(folderVO.getList());
		}
		
		if(folderVO.getDeletedList() != null ) {
			deleteFolder(folderVO.getDeletedList());
		}
		
	}
	
	@Transactional
	public void saveFolder(List<PJTFolder> folders) {
		folders.forEach(m -> {
			if(m.getLevel() == 0) {
				m.setParentId(null);
			}
		});
		save(folders);
		folders.stream().filter(folder -> isNotEmpty(folder.getChildren())).forEach(folder -> {
			folder.getChildren().forEach(m -> m.setParentId(folder.getId()));
			saveFolder(folder.getChildren());
		});
	}
	
	public List<PJTFolder> getChildFolder(long parentId){
		
		BooleanBuilder builder = new BooleanBuilder();
		builder.and(qPjtFolder.parentId.eq(parentId));
		List<PJTFolder> child = select().from(qPjtFolder).where(builder).fetch();
		return child;
		//if(parentId < 0) {
		//builder.and(qPjtFolder.parentId.isNull());
		
	}
	
	
	
	/**
	 * 폴더 안에 파일이 존재 하면 false를 리턴한다.
	 * @param folders
	 * @return
	 * @author jkeei
	 */
	@Transactional
    public boolean deleteFolder(List<PJTFolder> folders) {
		boolean existFile = existFile(folders);
		if(existFile) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return false;
		}
		
		folders.forEach(folder -> {
			folder.setChildren(getChildFolder(folder.getId()));
		});
		
        delete(folders);
        
        List<PJTFolder> list = folders.stream().filter(folder -> isNotEmpty(folder.getChildren())).collect(Collectors.toList());
        
        for(PJTFolder parent : list) {
        	boolean isFile = deleteFolder(parent.getChildren());
        	if(!isFile) {
        		return false;
        	}
        }
        
        
        return true;
    }
	
	/** 폴더안에 파일 존재여부
	 * @param folder
	 * @return
	 * @author jkeei
	 */
	public boolean existFile(PJTFolder folder) {	
		String targetType = fileService.getTargetType(folder);
		List<CommonFile> fileList = fileService.getFiles(targetType, folder.getId());
		return isNotEmpty(fileList);
	}
	
	
	/**  폴더안에 파일 존재 여부
	 * @param folders
	 * @return
	 * @author jkeei
	 * 
	 */
	public boolean existFile(List<PJTFolder> folders) {
		for(PJTFolder folder : folders) {
			boolean exist = existFile(folder);
			if(exist) {
				return true;
			}
		}
		return false;
		
	}
	
	public int getMaxSortNo(long parentOid) {
		BooleanBuilder builder = new BooleanBuilder();
		if(parentOid < 0) {
			builder.and(qPjtFolder.parentId.isNull());
		}else {
			builder.and(qPjtFolder.parentId.eq(parentOid));
		}
		builder.and(qPjtFolder.parentId.eq(parentOid));
		int max = select().from(qPjtFolder)
		.select(qPjtFolder.sort.max().coalesce(0))
		.where(builder).fetchOne();
		return max;
		
	}
	
	public boolean isExist(long oid) {
		long count = select().from(qPjtFolder).select(qPjtFolder.oid.count())
				.where(qPjtFolder.oid.eq(oid))
				.fetchOne();
		return count > 0;
	}
	
	@Transactional
	public boolean addChild(long parentOid, List<Long> childs, int sortNum) {
		
		PJTFolder parent = null;
		if(parentOid > -1) {
			parent = findOne(parentOid);
			if(parent == null) {
				return false;
			}
		}
		
		Long parentId = null;
		
		int level = 0;
		
		if(parent != null) {
			parentId = parent.getId();
			level = parent.getLevel() + 1;
		}
		
		for(long childOid : childs) {
			PJTFolder child = findOne(childOid);
			child.setParentId(parentId);
			child.setLevel(level);
			child.setSort(sortNum++);
			save(child);
			updateLevel(parent);
		}
		
		return true;
	}
	
	@Transactional
	public void updateLevel(PJTFolder parent) {
		List<PJTFolder> childs = getChildFolder(parent.getId());
		for(PJTFolder child : childs) {
			child.setLevel(parent.getLevel() + 1);
			save(child);
			updateLevel(child);
		}
	}
	
	
	
	
	@Transactional
	public boolean addChild(long parentOid, List<Long> childs) {
		
		int maxSort = getMaxSortNo(parentOid);
		return addChild(parentOid, childs, maxSort + 1);
	}
	
	@Transactional
	public boolean addNext(long targetId, List<Long> childs) {
		PJTFolder targetFolder = findOne(targetId);
		int sortNum = targetFolder.getSort() + 1;
		int addCount = childs.size();
		Long parentId = targetFolder.getParentId();
		if(parentId == null) {
			parentId = Long.valueOf(-1);
		}
		
		updateSortNumber(parentId, sortNum, addCount);
		
		return addChild(parentId, childs, sortNum);
	}
	
	
	@Transactional 
	public void updateSortNumber(long parentId, int sortNum, int addCount){
		BooleanBuilder builder = new BooleanBuilder();
		
		if(parentId < 0) {
			builder.and(qPjtFolder.parentId.isNull());
		}else {
			builder.and(qPjtFolder.parentId.eq(parentId));
		}
		
		builder.and(qPjtFolder.sort.goe(sortNum));
		
		update(qPjtFolder).where(builder).set(qPjtFolder.sort, 
				qPjtFolder.sort.add(addCount)).execute();
	}
	
	@Transactional
	public boolean addPre(long targetId, List<Long> childs) {
		PJTFolder targetFolder = findOne(targetId);
		Long parentId = targetFolder.getParentId();
		if(parentId == null) {
			parentId = Long.valueOf(-1);
		}
		int sortNum = targetFolder.getSort();
		int addCount = childs.size();
		
		updateSortNumber(parentId, sortNum, addCount);
		
		boolean isAdd = addChild(parentId, childs, sortNum);
		
		if(!isAdd) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return false;
		}
		
		return true;
		
	}

	@Transactional
	public boolean moveFolder(PJTFolderRequestVO folderVO) {
		boolean result = false;
		Long targetId = folderVO.getTargetId();
		if(targetId == null) {
			targetId = Long.valueOf(-1);
		}
		List<Long> nodes = folderVO.getNodeIds();
	    MoveType type = folderVO.getMoveType();
	   
	    switch(type) {
	    case inner : {
	    	result = addChild(targetId, nodes);
	    	break;
	    }
	    case next : {
	    	result = addNext(targetId, nodes);
	    	break;
	    }
	    case prev :{
	    	result = addPre(targetId, nodes);
	    	break;
	    }
	    
	
	    }
	    
	    return result;
		
		/*new JPAUpdateClause(em, qPjtFolder).where(qPjtFolder.folderName.eq("Bob")).set(qPjtFolder.sort, 
				qPjtFolder.sort.add(1)).execute();  */
		//String moveType = folderVO.getMoveType();
		
	}
	
	public void setPath(PJTFolder folder, LinkedList<String> list) {
		list.push(folder.getFolderName());
		Long parentId = folder.getParentId();	
		if(parentId != null) {
			PJTFolder parent = findOne(parentId);
			setPath(parent, list);
		}else {
			return;
		}
	}
	
	public List<String> getFolderPath(PJTFolder folder) {
		
		LinkedList<String> list = new LinkedList<String>();
		setPath(folder, list);
		return list;
	}
	
	public String getFolderPath(PJTFolder folder, String separator) {
		List<String> list = getFolderPath(folder);
		
		String path="";
		for(String name : list) {
			path += separator;
			path += name;
		}
		
		return path;
	}
	
}
