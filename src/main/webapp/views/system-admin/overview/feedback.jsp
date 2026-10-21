<%-- File: src/main/webapp/views/system-admin/overview/feedback.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%@ page import="com.travel.model.Feedback" %>
<%@ page import="java.util.List" %>
<%
    SystemAdmin admin = (SystemAdmin) request.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<%@ include file="../../common/header-system-admin.jsp" %>
<head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/overview.css">
</head>
<h2>All Customer Feedback</h2>

<%
    String success = request.getParameter("success");
    String error = request.getParameter("error");
    if (success != null) {
%>
<div class="success-message"><%= success %></div>
<%
    }
    if (error != null) {
%>
<div class="error-message"><%= error %></div>
<%
    }
%>

<table >
    <tr>
        <th>Feedback ID</th>
        <th>Customer ID</th>
        <th>Description</th>
        <th>Actions</th>
    </tr>
    <%
        List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
        if (feedbacks != null && !feedbacks.isEmpty()) {
            for (Feedback feedback : feedbacks) {
    %>
    <tr>
        <td><%= feedback.getFeedbackId() %></td>
        <td><%= feedback.getCustomerId() %></td>
        <td><%= feedback.getDescription().length() > 50 ?
                feedback.getDescription().substring(0, 50) + "..." :
                feedback.getDescription() %></td>
        <td class="actions">
            <form action="<%= request.getContextPath() %>/tour-support-officer-management" method="post" style="display:inline;">
                <input type="hidden" name="action" value="delete-feedback">
                <input type="hidden" name="id" value="<%= feedback.getFeedbackId() %>">
                <input type="submit" value="Delete" class="btn-delete"
                       onclick="return confirm('Are you sure you want to delete this feedback?');">
            </form>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td ></td>
    </tr>
    <%
        }
    %>
</table>

<%@ include file="../../common/footer.jsp" %>