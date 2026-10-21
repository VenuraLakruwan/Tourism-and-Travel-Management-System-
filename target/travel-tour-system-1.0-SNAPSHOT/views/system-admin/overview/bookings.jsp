<%-- File: src/main/webapp/views/system-admin/overview/bookings.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.service.BookingService" %>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="java.util.List" %>
<%
    // Check if system admin is logged in
    SystemAdmin admin = (SystemAdmin) request.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    BookingService bookingService = new BookingService();
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    String statusFilter = (String) request.getAttribute("statusFilter");

    if (bookings == null) {
        bookings = bookingService.getAllBookings();
    }
%>


<%@ include file="../../common/header-system-admin.jsp" %>
<!-- In header-packagemanager.jsp -->
<head>
    ...
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/overview.css">
</head>
<h2>View Bookings</h2>

<h3>Booking List</h3>
<% if (bookings != null && !bookings.isEmpty()) { %>
<table>
    <tr>
        <th>Booking ID</th>
        <th>Customer ID</th>
        <th>Package ID</th>
        <th>Booking Date</th>
        <th>Number of Travelers</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <% for (Booking booking : bookings) { %>
    <tr>
        <td><%= booking.getBookingId() %></td>
        <td><%= booking.getCustomerId() %></td>
        <td><%= booking.getPackageId() %></td>
        <td><%= booking.getBookingDate() %></td>
        <td><%= booking.getNumTravelers() %></td>
        <td>
            <% String status = booking.getConfirmationStatus(); %>
            <% if ("Pending".equals(status)) { %>
            <span class="status-pending"><%= status %></span>
            <% } else if ("Confirmed".equals(status)) { %>
            <span class="status-confirmed"><%= status %></span>
            <% } else if ("Cancelled".equals(status)) { %>
            <span class="status-cancelled"><%= status %></span>
            <% } else { %>
            <%= status %>
            <% } %>
        </td>
        <td>
            <% if ("Pending".equals(status)) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                <input type="hidden" name="action" value="confirm">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <input type="submit" value="Confirm" class="btn-confirm">
            </form>
            <% } %>
            <% if (!"Cancelled".equals(status)) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <input type="submit" value="Cancel" class="btn-cancel"
                       onclick="return confirm('Are you sure you want to cancel this booking?')">
            </form>
            <% } %>
        </td>
    </tr>
    <% } %> <!-- End for loop -->
</table>
<% } else { %>
<p>No bookings found.</p>
<% } %>
