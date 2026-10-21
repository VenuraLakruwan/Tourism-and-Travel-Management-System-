<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.CustomerSupportOfficer" %>
<%
    // Check if support officer is logged in
    CustomerSupportOfficer officer = (CustomerSupportOfficer) session.getAttribute("user");
    if (officer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Officer Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/dashboard.css">
</head>
<body>
<header>
    <div>
        <h1>Tour Package Booking System - Customer Support Portal</h1>
    </div>
</header>

<nav>
    <div >
        <ul>
            <li><a href="<%= request.getContextPath() %>/tour-support-dashboard">Dashboard</a></li>
            <li>
                <a href="#">Customer Support</a>
                <ul>
                    <li><a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=feedback-list">View All Feedback</a></li>
                    <li><a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=issue-list">View All Issues</a></li>
                    <li><a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=reply-issue">Reply to Issues</a></li>
                </ul>
            </li>
            <li><a href="<%= request.getContextPath() %>/tour-logout">Logout</a></li>
        </ul>
    </div>
</nav>

<div>
    <div>
        <h2>Welcome, <%= officer.getName() %>!</h2>

        <h3>Quick Actions</h3>
        <div class="quick-actions">
            <div class="quick-action">
                <h3><a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=feedback-list">View All Feedback</a></h3>
                <p>Review customer feedback and ratings</p>
            </div>
            <div class="quick-action">
                <h3><a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=issue-list">View All Issues</a></h3>
                <p>Check reported issues and concerns</p>
            </div>
            <div class="quick-action">
                <h3><a href="<%= request.getContextPath() %>/tour-support-officer-panel?action=reply-issue">Reply to Issues</a></h3>
                <p>Respond to customer issues</p>
            </div>
        </div>

        <h3>Account Information</h3>
        <table>
            <tr>
                <td>Employee ID:</td>
                <td><%= officer.getEmployeeId() %></td>
            </tr>
            <tr>
                <td>Name:</td>
                <td><%= officer.getName() %></td>
            </tr>
            <tr>
                <td>Job Title:</td>
                <td><%= officer.getJobTitle() %></td>
            </tr>
            <tr>
                <td>Department:</td>
                <td><%= officer.getDepartment() %></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><%= officer.getEmail() %></td>
            </tr>
            <tr>
                <td>Contact Number:</td>
                <td><%= officer.getContactNumber() %></td>
            </tr>
        </table>
    </div>
</div>

<footer>
    <div>
        <p> 2025 Tour Package Booking System. All rights reserved.</p>
    </div>
</footer>
</body>
</html>
