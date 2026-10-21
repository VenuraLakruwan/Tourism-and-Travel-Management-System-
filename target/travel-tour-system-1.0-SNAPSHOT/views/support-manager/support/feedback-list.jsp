<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Feedback" %>
<%@ page import="java.util.List" %>
<%@ page import="com.travel.model.CustomerSupportOfficer" %>
<%
    // Check if support officer is logged in
    CustomerSupportOfficer officer = (CustomerSupportOfficer) session.getAttribute("user");
    if (officer == null || !"supportOfficer".equals(session.getAttribute("userType"))) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<%@ include file="/views/common/header-support-officer.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/style.css">

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

<table class="feedback-table">
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
            <!-- FIXED: Changed action URL to match servlet mapping -->
            <form action="<%= request.getContextPath() %>/tour-support-officer-panel" method="post" style="display:inline;">
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
        <td colspan="5" class="no-data">No feedback found.</td>
    </tr>
    <%
        }
    %>
</table>

<p><a href="<%= request.getContextPath() %>/tour-support-dashboard">Back to Dashboard</a></p>

<%@ include file="/views/common/footer.jsp" %>