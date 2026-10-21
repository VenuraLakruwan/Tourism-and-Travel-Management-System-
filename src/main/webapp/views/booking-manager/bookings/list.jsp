<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.service.BookingService" %>
<%@ page import="java.util.List" %>

<%
    BookingManager manager = (BookingManager) session.getAttribute("user");
    if (manager == null) {
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

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Bookings - Booking Manager</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Booking-Manager/list.css">
</head>
<body>
<jsp:include page="/views/common/header-bookingmanager.jsp"/>

<h2>All Bookings</h2>

<% if (request.getParameter("success") != null) { %>
<div class="success"><%= request.getParameter("success") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>

<p><a href="<%= request.getContextPath() %>/booking-manager/dashboard">Back to Dashboard</a></p>

<h3>Filter Options</h3>
<table>
    <tr>
        <td>
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=list">All Bookings</a> |
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">Pending Only</a> |
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">Confirmed Only</a> |
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-cancelled">Cancelled Only</a>
        </td>
    </tr>
</table>

<h3>Booking List</h3>
<% if (bookings != null && !bookings.isEmpty()) { %>
<table >
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
            <% if ("Pending".equals(booking.getConfirmationStatus())) { %>
            <span class="status-pending"><%= booking.getConfirmationStatus() %></span>
            <% } else if ("Confirmed".equals(booking.getConfirmationStatus())) { %>
            <span class="status-confirmed"><%= booking.getConfirmationStatus() %></span>
            <% } else if ("Cancelled".equals(booking.getConfirmationStatus())) { %>
            <span class="status-cancelled"><%= booking.getConfirmationStatus() %></span>
            <% } else { %>
            <%= booking.getConfirmationStatus() %>
            <% } %>
        </td>
        <td>
            <% if ("Pending".equals(booking.getConfirmationStatus())) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                <input type="hidden" name="action" value="confirm">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <input type="submit" value="Confirm" class="btn-confirm">
            </form>
            <% } %>
            <% if (!"Cancelled".equals(booking.getConfirmationStatus())) { %>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <input type="submit" value="Cancel" class="btn-cancel"
                       onclick="return confirm('Are you sure you want to cancel this booking?')">
            </form>
            <% } %>
        </td>
    </tr>
    <% } %>
</table>

<p>Total Bookings: <%= bookings.size() %></p>

<% } else { %>
<p>No bookings found.</p>
<% } %>

<h3>Quick Actions</h3>
<table>
    <tr>
        <td>
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">View Pending Bookings</a>
            <p>Review and confirm bookings awaiting approval</p>
        </td>
    </tr>
    <tr>
        <td>
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">View Confirmed Bookings</a>
            <p>View all confirmed bookings</p>
        </td>
    </tr>
    <tr>
        <td>
            <a href="<%= request.getContextPath() %>/booking-manager/list?action=view-cancelled">View Cancelled Bookings</a>
            <p>View all cancelled bookings</p>
        </td>
    </tr>
</table>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>