<%@tag import="com.boot.ksolution.core.utils.SessionUtils"%>
<%@tag import="com.ksolution.common.domain.spbasket.SpBasket"%>
<%@tag import="com.ksolution.common.domain.spbasket.SpBasketUtil"%>
<%@ tag import="org.apache.commons.lang3.StringUtils" %>
<%@ tag import="java.util.List" %>
<%@ tag language="java" pageEncoding="UTF-8" body-content="empty" %>
<%@ attribute name="groupCd" required="false" %>
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
   
    String userId = SessionUtils.getCurrentLoginUserCd();
    
    List<SpBasket> folders = SpBasketUtil.get(userId);

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

            for (SpBasket folder : folders) {
                if (StringUtils.isNotEmpty(defaultValue) && defaultValue.equals(folder.getOid())) {
                    builder.append(String.format("<option value=\"%s\" selected>%s</option>", folder.getOid(), folder.getFolderNm()));
                } else {
                    builder.append(String.format("<option value=\"%s\">%s</option>", folder.getOid(), folder.getFolderNm()));
                }
            }
            builder.append("</select>");
            break;

        case "checkbox":
            for (SpBasket folder : folders) {
                if (StringUtils.isNotEmpty(defaultValue) && defaultValue.equals(folder.getOid())) {
                    builder.append(String.format("<label class=\"checkbox-inline\"><input type=\"checkbox\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\" checked> %s </label>", name, dataPath, folder.getOid(), folder.getFolderNm()));
                } else {
                    builder.append(String.format("<label class=\"checkbox-inline\"><input type=\"checkbox\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\"> %s </label>", name, dataPath, folder.getOid(), folder.getFolderNm()));
                }
            }
            break;

        case "radio":
            for (SpBasket folder : folders) {
                if (StringUtils.isNotEmpty(defaultValue) && defaultValue.equals(folder.getOid())) {
                    builder.append(String.format(" <input type=\"radio\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\" checked> %s &nbsp;", name, dataPath, folder.getOid(), folder.getFolderNm()));
                } else {
                    builder.append(String.format(" <input type=\"radio\" name=\"%s\" data-ax-path=\"%s\" value=\"%s\"> %s &nbsp;", name, dataPath, folder.getOid(), folder.getFolderNm()));
                }
            }
            break;
    }
%>

<%=builder.toString()%>