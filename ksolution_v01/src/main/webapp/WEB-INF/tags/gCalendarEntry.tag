<%@tag import="com.google.api.services.calendar.model.CalendarListEntry"%>
<%@tag import="com.ksolution.common.utils.GoogleCalendarService"%>
<%@ tag import="org.apache.commons.lang3.StringUtils" %>
<%@ tag import="java.util.List" %>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty" %>
<%@ attribute name="name" required="false" %> 
<%@ attribute name="clazz" required="false" %>
<%@ attribute name="id" required="false" %>
<%@ attribute name="dataPath" required="false" %>
<%@ attribute name="type" required="false" %>
<%@ attribute name="defaultValue" required="false" %>
<%@ attribute name="emptyValue" required="false" %>
<%@ attribute name="emptyText" required="false" %>
<%@ attribute name="style" required="false" %>

<%
    if (StringUtils.isEmpty(type)) {
        type = "select";
    }

    StringBuilder builder = new StringBuilder();
   

    
    List<CalendarListEntry> calendarEntry = GoogleCalendarService.getCalendarListEntry();

    switch (type) {
        case "select":
            builder.append("<select class=\""+ clazz +" \"");

            if (StringUtils.isEmpty(emptyValue)) {
                emptyValue = "";
            }

            if (StringUtils.isNotEmpty(id)) {
                builder.append("id=\"" + id + "\"");
            }

            if (StringUtils.isNotEmpty(name)) {
                builder.append("name=\"" + name + "\"");
            }

            if (StringUtils.isNotEmpty(dataPath)) {
                builder.append("data-ax-path=\"" + dataPath + "\"");
            }

            if (StringUtils.isNotEmpty(style)) {
                builder.append("style=\"" + style + "\"");
            }
            
            builder.append(">");


            if (StringUtils.isEmpty(defaultValue) && StringUtils.isNotEmpty(emptyText)) {
                builder.append(String.format("<option value=\"%s\">%s</option>", emptyValue, emptyText));
            }

            for (CalendarListEntry entry : calendarEntry) {
                if (StringUtils.isNotEmpty(defaultValue) && defaultValue.equals(entry.getId())) {
                    builder.append(String.format("<option value=\"%s\" selected>%s</option>", entry.getId(), entry.getSummary()));
                } else {
                    builder.append(String.format("<option value=\"%s\">%s</option>", entry.getId(), entry.getSummary()));
                }
            }
            builder.append("</select>");
            break;

        case "checkbox":
        	for (CalendarListEntry entry : calendarEntry) {
                if (StringUtils.isNotEmpty(defaultValue) && defaultValue.equals(entry.getId())) {
                    builder.append(String.format("<label class=\"checkbox-inline\"><input type=\"checkbox\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\" checked> %s </label>", name, dataPath, entry.getId(), entry.getSummary()));
                } else {
                    builder.append(String.format("<label class=\"checkbox-inline\"><input type=\"checkbox\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\"> %s </label>", name, dataPath, entry.getId(), entry.getSummary()));
                }
            }
            break;

        case "radio":
        	for (CalendarListEntry entry : calendarEntry) {
                if (StringUtils.isNotEmpty(defaultValue) && defaultValue.equals(entry.getId())) {
                    builder.append(String.format(" <input type=\"radio\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\" checked> %s &nbsp;", name, dataPath, entry.getId(), entry.getSummary()));
                } else {
                    builder.append(String.format(" <input type=\"radio\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\"> %s &nbsp;", name, dataPath, entry.getId(), entry.getSummary()));
                }
            }
            break;
    }
%>

<%=builder.toString()%>