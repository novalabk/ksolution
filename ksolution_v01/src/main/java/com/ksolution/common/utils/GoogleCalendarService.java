package com.ksolution.common.utils;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.joda.time.format.DateTimeFormat;
import org.joda.time.format.DateTimeFormatter;

import com.boot.ksolution.core.utils.JsonUtils;
import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.DateTime;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.calendar.Calendar;
import com.google.api.services.calendar.CalendarScopes;

import com.google.api.services.calendar.model.CalendarList;
import com.google.api.services.calendar.model.CalendarListEntry;
import com.google.api.services.calendar.model.Event;
import com.google.api.services.calendar.model.EventDateTime;
import com.google.api.services.calendar.model.Events;
import com.ksolution.common.domain.calendar.CalendarEvent;
import com.ksolution.common.domain.calendar.CalendarEventRepository;

import springfox.documentation.swagger2.mappers.ServiceModelToSwagger2Mapper;
 
public class GoogleCalendarService {
 
    private static final String APPLICATION_NAME = "Google Calendar API Java Quickstart";
 
    private static final java.io.File DATA_STORE_DIR = new java.io.File(
            System.getProperty("user.home"),
            ".credentials/calendar-java-quickstart");
 
    private static FileDataStoreFactory DATA_STORE_FACTORY;
 
    private static final JsonFactory JSON_FACTORY = JacksonFactory
            .getDefaultInstance();
 
    private static HttpTransport HTTP_TRANSPORT;
 
    private static final List<String> SCOPES = Arrays
            .asList(CalendarScopes.CALENDAR);
 
    static {
        try {
            HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();
            DATA_STORE_FACTORY = new FileDataStoreFactory(DATA_STORE_DIR);
        } catch (Throwable t) {
            t.printStackTrace();
            System.exit(1);
        }
    }
 
    public static Credential authorize() throws IOException {
        InputStream in = GoogleCalendarService.class
                .getResourceAsStream("/client_secret.json");
        GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(
                JSON_FACTORY, new InputStreamReader(in));
 
        GoogleAuthorizationCodeFlow flow = new GoogleAuthorizationCodeFlow.Builder(
                HTTP_TRANSPORT, JSON_FACTORY, clientSecrets, SCOPES)
                .setDataStoreFactory(DATA_STORE_FACTORY)
                .setAccessType("offline").build();
        Credential credential = new AuthorizationCodeInstalledApp(flow,
                new LocalServerReceiver()).authorize("user");
//        System.out.println("Credentials saved to "
//                + DATA_STORE_DIR.getAbsolutePath());
        return credential;
    }
 
    public static Calendar getCalendarService() throws IOException {
        Credential credential = authorize();
        return new Calendar.Builder(HTTP_TRANSPORT, JSON_FACTORY, credential)
                .setApplicationName(APPLICATION_NAME).build();
    }
    
    public static List<CalendarListEntry> getCalendarListEntry()throws Exception{
    	
    	List<CalendarListEntry> list = new ArrayList<>();
    	
    	com.google.api.services.calendar.Calendar service = getCalendarService();
        
        String pageToken = null;
        do {
          CalendarList calendarList = service.calendarList().list().setPageToken(pageToken).execute();
          List<CalendarListEntry> items1 = calendarList.getItems();
          
         
          for (CalendarListEntry calendarListEntry : items1) {
        	if(calendarListEntry.getSelected() != null && calendarListEntry.getSelected().booleanValue()) {
        		list.add(calendarListEntry);
        	}
        	/*if(calendarListEntry.getId().indexOf("#holiday") > 0) {
        		list.add(calendarListEntry);
        	}*/
           
          }
          pageToken = calendarList.getNextPageToken();
        } while (pageToken != null);
        
        return list;
    }
    
    private static DateTimeFormatter formatter = DateTimeFormat.forPattern("yyyy-MM-dd");
    
    public static List<CalendarEvent> getEventList(String gCalId, Long tempOid)throws Exception{
    	com.google.api.services.calendar.Calendar service = getCalendarService();
    	
    	int gap = 2;
    	
    	java.util.Calendar start = java.util.Calendar.getInstance();
    	start.add(java.util.Calendar.YEAR, -gap);
    	start.set(java.util.Calendar.MONTH, 0);
    	start.set(java.util.Calendar.DATE, 1);
    	start.set(java.util.Calendar.HOUR_OF_DAY, 0);
    	start.set(java.util.Calendar.MINUTE, 0);
    	start.set(java.util.Calendar.SECOND, 0);
    	start.set(java.util.Calendar.MILLISECOND, 0);
    	
    	
    	java.util.Calendar end = java.util.Calendar.getInstance();
    	end.add(java.util.Calendar.YEAR, gap + 1);
    	end.set(java.util.Calendar.MONTH, 0);
    	end.set(java.util.Calendar.DATE, 1);
    	end.set(java.util.Calendar.HOUR_OF_DAY, 0);
    	end.set(java.util.Calendar.MINUTE, 0);
    	end.set(java.util.Calendar.SECOND, 0);
    	end.set(java.util.Calendar.MILLISECOND, 0);
    	
    	DateTime now = new DateTime(start.getTime());
        DateTime max = new DateTime(end.getTime());
        
        
        Events events = service.events().list(gCalId)
                .setMaxResults(200)
                .setTimeMin(now)
                .setTimeMax(max)
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .execute();
        List<Event> items = events.getItems();
        
        List<CalendarEvent> eventlist = new ArrayList<>();
        
        for(Event event : items) {
           
           
           
           String start_str = event.getStart().get("date").toString();
           
          
           
           long startMillis = formatter.parseDateTime(start_str).getMillis();
   
          
           
           String end_str = event.getEnd().get("date").toString();
           
           
           long endMillis = formatter.parseDateTime(end_str).getMillis();
           
           //long endMillis = formatter.parseDateTime((String)event.get("end")).getMillis();
           CalendarEvent calendarEvent = new CalendarEvent();
           calendarEvent.setTitle(event.getSummary());
           calendarEvent.setGCalId(event.getId());
           
           calendarEvent.setStartDate(Instant.ofEpochMilli(startMillis));
           calendarEvent.setEndDate(Instant.ofEpochMilli(endMillis));
           
           calendarEvent.setTempId(tempOid);
           
           eventlist.add(calendarEvent);
    
        }
        
        return eventlist;
    }
    
 
    public static void main(String[] args) throws Exception {
        com.google.api.services.calendar.Calendar service = getCalendarService();
        
        String pageToken = null;
        do {
        	
        
        		  
          CalendarList calendarList = service.calendarList().list().setPageToken(pageToken).execute();
          List<CalendarListEntry> items1 = calendarList.getItems();
          System.out.println("call main.." + items1.size());
          for (CalendarListEntry calendarListEntry : items1) {
        	//System.out.println("calendarListEntry.getKind() = " + calendarListEntry.getSelected());
        	  
            //System.out.println(calendarListEntry.getSummary() + " id = " + calendarListEntry.getId());
           
            
          }
          pageToken = calendarList.getNextPageToken();
        } while (pageToken != null);
        
        SimpleDateFormat fomat = new SimpleDateFormat("yyyy/MM/dd");
        
        DateTime now = new DateTime(fomat.parse("2018/01/01"));
        DateTime max = new DateTime(fomat.parse("2019/05/01"));
        
        
        Events events = service.events().list("ja.japanese#holiday@group.v.calendar.google.com")
                .setMaxResults(100)
                .setTimeMin(now)
                .setTimeMax(max)
                .setOrderBy("startTime")
                .setSingleEvents(true)
                .execute();     
        List<Event> items = events.getItems();
        if (items.size() == 0) {
             System.out.println("kk");
        } else {
           for (Event event : items) {
        	   System.out.println( event.getStart().get("date") + " ~ " + event.get("end"));
        	   System.out.println(event.getSummary());
        	   System.out.println(event.getId());
           }
        }

    }
}

