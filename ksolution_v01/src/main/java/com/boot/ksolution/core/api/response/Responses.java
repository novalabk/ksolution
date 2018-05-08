package com.boot.ksolution.core.api.response;

import java.util.List;
import java.util.Map;

import org.springframework.data.domain.Page;

import com.boot.ksolution.core.json.Views;
import com.boot.ksolution.core.vo.PageableVO; 
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonView;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;

public class Responses {
	
	@Data
    @NoArgsConstructor
    @RequiredArgsConstructor(staticName = "of")
    public static class ListResponse {
		//JsonView class를 정의해두면 
	    //나중에 controller에서 class에 따라 뿌린거만 뿌린다. 
		
        
        @NonNull
        @JsonProperty("list")
        @JsonView(Views.Root.class)  
        List<?> list;
		
		@NonNull
		@JsonView(Views.Root.class)
        PageableVO page = PageableVO.of(0, 0L, 0, 0);
	}
	
	@Data
    @NoArgsConstructor
    @RequiredArgsConstructor(staticName = "of")
	public static class MapResponse{
	@NonNull
       // @ApiModelProperty(value = "Map", required = true)
        @JsonProperty("map")
        @JsonView(Views.Root.class)
        Map<String, Object> map;
    }
	
	@Data
    @NoArgsConstructor
    public static class PageResponse {
        @NonNull
        @JsonProperty("list")
        @JsonView(Views.Root.class)
        List<?> list;

        @NonNull
        @JsonView(Views.Root.class)
        PageableVO page;

        public static Responses.PageResponse of(List<?> content, Page<?> page) {
            Responses.PageResponse pageResponse = new Responses.PageResponse();
            pageResponse.setList(content);
           
            //pageResponse.of(pages.getTotalPages(), pages.getTotalElements(), pages.getNumber(), pages.getSize());
            
            pageResponse.setPage(PageableVO.of(page));
            return pageResponse;
        }

        public static Responses.PageResponse of(Page<?> page) {
            return of(page.getContent(), page);
        }
    }

}
