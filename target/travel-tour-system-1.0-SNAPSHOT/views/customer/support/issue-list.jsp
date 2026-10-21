<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.ReportIssue" %>
<%@ page import="java.util.List" %>

<jsp:include page="../../common/header-customer.jsp" />
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Feedback - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/support.css">
</head>
<h2>My Reported Issues</h2>

<table>
    <tr>
        <th>Report ID</th>
        <th>Details</th>
        <th>Date</th>
    </tr>
    <%
        List<ReportIssue> issues = (List<ReportIssue>) request.getAttribute("issues");
        if (issues != null && !issues.isEmpty()) {
            for (ReportIssue i : issues) {
    %>
    <tr>
        <td><%= i.getReportId() %></td>
        <td><%= i.getIssueDetails() %></td>
        <td><%= i.getReportDate() %></td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td >No issues reported yet</td>
    </tr>
    <%
        }
    %>
</table>

<p><a href="<%= request.getContextPath() %>/tour-customer-dashboard">Back to Dashboard</a></p>

<jsp:include page="../../common/footer.jsp" />