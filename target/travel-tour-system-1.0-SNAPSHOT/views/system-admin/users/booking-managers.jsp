<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="java.util.List" %>
<%
    // Check if system admin is logged in
    SystemAdmin admin = (SystemAdmin) request.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    // Get booking managers list
    List<BookingManager> bookingManagers = (List<BookingManager>) request.getAttribute("bookingManagers");
%>
<%@ include file="../../common/header-system-admin.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/users.css">

<h2>Booking Managers</h2>

<%-- Display success or error messages --%>
<% if (request.getParameter("success") != null) { %>
<div class="success">Booking manager added successfully!</div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>

<h3>Add New Booking Manager</h3>
<form action="<%= request.getContextPath() %>/tour-system-admin-users" method="post">
    <input type="hidden" name="action" value="add-booking-manager">
    <table>
        <tr><td>Name:</td><td><input type="text" name="name" required></td></tr>
        <tr><td>Job Title:</td><td><input type="text" name="jobTitle" required></td></tr>
        <tr><td>Department:</td><td><input type="text" name="department" required></td></tr>
        <tr><td>Contact Number:</td><td><input type="text" name="contactNumber" required></td></tr>
        <tr><td>Email:</td><td><input type="email" name="email" required></td></tr>
        <tr><td>Password:</td><td><input type="password" name="password" required></td></tr>
        <tr><td ><input type="submit" value="Add Booking Manager"></td></tr>
    </table>
</form>

<h3>Current Booking Managers</h3>
<table>
    <tr>
        <th>Employee ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Job Title</th>
        <th>Department</th>
        <th>Contact Number</th>
        <th>Actions</th>
    </tr>
    <% if (bookingManagers != null && !bookingManagers.isEmpty()) {
        for (BookingManager manager : bookingManagers) { %>
    <tr>
        <td><%= manager.getEmployeeId() %></td>
        <td><%= manager.getName() %></td>
        <td><%= manager.getEmail() %></td>
        <td><%= manager.getJobTitle() %></td>
        <td><%= manager.getDepartment() %></td>
        <td><%= manager.getContactNumber() %></td>
        <td>
            <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=edit-booking-manager&id=<%= manager.getEmployeeId() %>">Edit</a>
            <form action="<%= request.getContextPath() %>/tour-system-admin-users" method="post">
                <input type="hidden" name="action" value="delete-booking-manager">
                <input type="hidden" name="employeeId" value="<%= manager.getEmployeeId() %>">
                <input type="submit" value="Delete" onclick="return confirm('Are you sure you want to delete this booking manager? This action cannot be undone.');">
            </form>
        </td>
    </tr>
    <% }
    } else { %>
    <tr>
        <td>No booking managers found</td>
    </tr>
    <% } %>
</table>

<%@ include file="../../common/footer.jsp" %>