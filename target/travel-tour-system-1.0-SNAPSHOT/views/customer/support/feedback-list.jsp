<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Feedback" %>
<%@ page import="java.util.List" %>

<jsp:include page="../../common/header-customer.jsp" />
<html>
<head>
    <meta charset="UTF-8">
    <title>Submit Feedback - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/support.css">
</head>
<h2>My Feedback</h2>

<table>
    <tr>
        <th>Feedback ID</th>
        <th>Description</th>
        <th>Date</th>
    </tr>
    <%
        List<Feedback> feedbacks = (List<Feedback>) request.getAttribute("feedbacks");
        if (feedbacks != null && !feedbacks.isEmpty()) {
            for (Feedback f : feedbacks) {
    %>
    <tr>
        <td><%= f.getFeedbackId() %></td>
        <td><%= f.getDescription() %></td>
        <td><%= f.getDescription() != null ? new java.util.Date().toString() : "N/A" %></td>  <!-- Add date field to model if needed -->
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td >No feedback submitted yet</td>
    </tr>
    <%
        }
    %>
</table>

<p><a href="<%= request.getContextPath() %>/tour-customer-dashboard">Back to Dashboard</a></p>

<jsp:include page="../../common/footer.jsp" />