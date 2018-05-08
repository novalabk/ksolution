package com.boot.ksolution.core.parameter;

import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import org.springframework.core.MethodParameter;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;


public class RequestParamsArgumentResolver implements HandlerMethodArgumentResolver{

	@Override
	public boolean supportsParameter(MethodParameter paramter) {
		return RequestParams.class.isAssignableFrom(paramter.getParameterType());
	}
	
	@Override
	public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, 
			NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
		Type type = parameter.getGenericParameterType();
		RequestParams requestParams = null;
		
		if(type instanceof ParameterizedType) {
			ParameterizedType pType = (ParameterizedType) type;
			requestParams = new RequestParams((Class<?>) pType.getActualTypeArguments()[0]);
		}else {
			requestParams = new RequestParams(Object.class);
		}
		
		requestParams.setParameterMap(webRequest.getParameterMap());
		return requestParams;		
	}
	
	/*public static void main(String args[])throws Exception{
		List<String> list = new ArrayList<String>();
		Class clazz = GenericSample.class;
        ParameterizedType type = (ParameterizedType) clazz.getField("list").getGenericType();
        
        String typeName = type.getTypeName();             
        Type rawType = type.getRawType();                
        Type actual = type.getActualTypeArguments()[0];    
        
        System.out.println("***파라미터화된 형: List<T> ***");
        System.out.println(typeName);    // => "java.util.List<T>"
        System.out.println(rawType);    // => Class<List>
        System.out.println(actual);        // => T
    }

	public class GenericSample<T, U extends Exception> {
	    public T t;
	    public T[] tArray;
	    public List<String> list;
	    public List<T> tList;
	    public List<U> boundList;
	    public List<? extends Exception> wildList;

	}*/


}
