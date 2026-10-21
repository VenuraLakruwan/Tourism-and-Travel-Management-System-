<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Booking" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    Integer bookingId = (Integer) request.getAttribute("bookingId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Booking Confirmation</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/booking-confirmation.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<h2>Booking Confirmation</h2>

<% if (request.getAttribute("successMessage") != null) { %>
<div class="success"><%= request.getAttribute("successMessage") %></div>
<% } %>
<% if (request.getAttribute("errorMessage") != null) { %>
<div class="error"><%= request.getAttribute("errorMessage") %></div>
<% } %>

<div >
    <h4>What happens next?</h4>
    <ul>
        <li>Your booking has been submitted and is currently pending confirmation.</li>
        <li>You can check your booking status anytime from your dashboard.</li>
        <li>Keep your booking ID for future reference.</li>
    </ul>
</div>

<% if (booking != null) { %>
<h3>Booking Details</h3>
<table >
    <tr>
        <td>Booking ID:</td>
        <td><%= booking.getBookingId() %></td>
    </tr>
    <tr>
        <td>Package ID:</td>
        <td><%= booking.getPackageId() %></td>
    </tr>
    <tr>
        <td>Number of Travelers:</td>
        <td><%= booking.getNumTravelers() %></td>
    </tr>
    <tr>
        <td>Total Price:</td>
        <td>$<%= booking.getTotalPrice() %></td>
    </tr>
    <tr>
        <td>Status:</td>
        <td><%= booking.getConfirmationStatus() %></td>
    </tr>
</table>

<div>
    <a href="<%= request.getContextPath() %>/customer/payments/make?bookingId=<%= booking.getBookingId() %>"
       class="btn-primary">Proceed to Payment</a>
    <a href="<%= request.getContextPath() %>/tour-customer-dashboard" class="btn-secondary">Back to Dashboard</a>
    <a href="<%= request.getContextPath() %>/customer/packages/list" class="btn-default">Browse More Packages</a>
</div>
<% } else if (bookingId != null) { %>
<div class="action-buttons">
    <a href="<%= request.getContextPath() %>/customer/payments/make?bookingId=<%= bookingId %>"
       class="btn-primary">Proceed to Payment</a>
    <a href="<%= request.getContextPath() %>/tour-customer-dashboard" class="btn-secondary">Back to Dashboard</a>
    <a href="<%= request.getContextPath() %>/customer/packages/list" class="btn-default">Browse More Packages</a>
</div>
<% } else { %>
<div class="action-buttons">
    <a href="<%= request.getContextPath() %>/tour-customer-dashboard" class="btn-secondary">Back to Dashboard</a>
    <a href="<%= request.getContextPath() %>/customer/packages/list" class="btn-default">Browse More Packages</a>
</div>
<% } %>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>