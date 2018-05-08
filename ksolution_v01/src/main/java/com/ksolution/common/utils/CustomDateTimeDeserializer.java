package com.ksolution.common.utils;
import java.io.IOException;
import java.time.Instant;

import org.joda.time.DateTime;
import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;

public class CustomDateTimeDeserializer extends JsonDeserializer<Instant> { 
     

    private static DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
    @Override
    public Instant deserialize(JsonParser jp, DeserializationContext ctxt)
            throws IOException, JsonProcessingException {
         
    	 String date = jp.getText();
    	 try {
    		 DateTime time =  formatter.parseDateTime(date);
    		 return Instant.ofEpochMilli(time.getMillis());
    	 }catch(IllegalArgumentException e) {
    		 
    	 }
         return null;
         //  return formatter.parseDateTime(date);
    }
}