<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="com.travel.service.BookingService" %>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="java.util.List" %>

<%
    // Check if booking manager is logged in
    BookingManager manager = (BookingManager) session.getAttribute("user");
    if (manager == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    // Get booking statistics
    BookingService bookingService = new BookingService();
    int totalBookings = bookingService.getTotalBookings();
    int pendingBookings = bookingService.getPendingBookingsCount();
    int confirmedBookings = bookingService.getConfirmedBookingsCount();
    int cancelledBookings = bookingService.getCancelledBookingsCount();

    // Get recent bookings from request attribute set by servlet
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");
    if (recentBookings == null) {
        recentBookings = bookingService.getAllBookings();
    }

    // Get pending bookings specifically
    List<Booking> pendingBookingsList = bookingService.getBookingsByStatus("Pending");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Manager Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Booking-Manager/dashboard.css">

</head>
<body>
<jsp:include page="/views/common/header-bookingmanager.jsp"/>

<h2>Booking Manager Dashboard</h2>

<p>Welcome, <%= manager.getName() %>!</p>

<h3>Booking Statistics</h3>
<table>
    <tr>
        <th>Total Bookings</th>
        <th>Pending Bookings</th>
        <th>Confirmed Bookings</th>
        <th>Cancelled Bookings</th>
    </tr>
    <tr>
        <td><%= totalBookings %></td>
        <td><%= pendingBookings %></td>
        <td><%= confirmedBookings %></td>
        <td><%= cancelledBookings %></td>
    </tr>
</table>

<h3>Quick Actions</h3>
<div class="quick-actions">
    <div class="quick-action">
        <h4><a href="<%= request.getContextPath() %>/booking-manager/list?action=list">View All Bookings</a></h4>
        <p>View and manage all customer bookings</p>
    </div>
    <div class="quick-action">
        <h4><a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">View Pending Bookings</a></h4>
        <p>Review and confirm pending bookings</p>
    </div>
    <div class="quick-action">
        <h4><a href="<%= request.getContextPath() %>/booking-manager/list?action=view-confirmed">View Confirmed Bookings</a></h4>
        <p>View all confirmed bookings</p>
    </div>
    <div class="quick-action">
        <h4><a href="<%= request.getContextPath() %>/booking-manager/list?action=view-cancelled">View Cancelled Bookings</a></h4>
        <p>View all cancelled bookings</p>
    </div>
</div>

<h3>Recent Pending Bookings</h3>
<table>
    <tr>
        <th>Booking ID</th>
        <th>Customer ID</th>
        <th>Package ID</th>
        <th>Booking Date</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    <%
        if (pendingBookingsList != null && !pendingBookingsList.isEmpty()) {
            // Show 5 most recent pending bookings
            int maxBookings = Math.min(pendingBookingsList.size(), 5);
            for (int i = 0; i < maxBookings; i++) {
                Booking booking = pendingBookingsList.get(i);
    %>
    <tr>
        <td><%= booking.getBookingId() %></td>
        <td><%= booking.getCustomerId() %></td>
        <td><%= booking.getPackageId() %></td>
        <td><%= booking.getBookingDate() %></td>
        <td>
            <span class="status-pending"><%= booking.getConfirmationStatus() %></span>
        </td>
        <td>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                <input type="hidden" name="action" value="confirm">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <input type="submit" value="Confirm" class="btn-confirm">
            </form>
            <form action="<%= request.getContextPath() %>/booking-manager/list" method="post" style="display: inline;">
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="id" value="<%= booking.getBookingId() %>">
                <input type="submit" value="Cancel" class="btn-cancel">
            </form>
        </td>
    </tr>
    <%
        }
    } else {
    %>
    <tr>
        <td>No pending bookings found</td>
    </tr>
    <%
        }
    %>
</table>

<% if (pendingBookingsList != null && pendingBookingsList.size() > 5) { %>
<p><a href="<%= request.getContextPath() %>/booking-manager/list?action=view-pending">View All Pending Bookings</a></p>
<% } %>

<h3>Account Information</h3>
<table>
    <tr>
        <td>Employee ID:</td>
        <td><%= manager.getEmployeeId() %></td>
    </tr>
    <tr>
        <td>Name:</td>
        <td><%= manager.getName() %></td>
    </tr>
    <tr>
        <td>Job Title:</td>
        <td><%= manager.getJobTitle() %></td>
    </tr>
    <tr>
        <td>Department:</td>
        <td><%= manager.getDepartment() %></td>
    </tr>
    <tr>
        <td>Email:</td>
        <td><%= manager.getEmail() %></td>
    </tr>
    <tr>
        <td>Contact Number:</td>
        <td><%= manager.getContactNumber() %></td>
    </tr>
</table>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>