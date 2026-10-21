<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Booking" %>
<%@ page import="com.travel.model.Package" %>
<%@ page import="com.travel.dao.PackageDAO" %>
<%
    Booking booking = (Booking) request.getAttribute("booking");
    String errorMessage = (String) request.getAttribute("errorMessage");
    String successMessage = (String) request.getAttribute("successMessage");

    // Get package details if booking exists
    Package tourPackage = null;
    if (booking != null) {
        PackageDAO packageDAO = new PackageDAO();
        tourPackage = packageDAO.getPackageById(booking.getPackageId());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Make Payment - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/package.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<h2>Make Payment</h2>

<% if (errorMessage != null) { %>
<div class="error"><%= errorMessage %></div>
<% } %>
<% if (successMessage != null) { %>
<div class="success"><%= successMessage %></div>
<% } %>

<% if (booking != null && tourPackage != null) { %>
<h3>Booking Details</h3>
<table>
    <tr>
        <td>Booking ID:</td>
        <td><%= booking.getBookingId() %></td>
    </tr>
    <tr>
        <td>Package:</td>
        <td><%= tourPackage.getPackageName() %></td>
    </tr>
    <tr>
        <td>Number of Travelers:</td>
        <td><%= booking.getNumTravelers() %></td>
    </tr>
    <tr>
        <td>Total Amount:</td>
        <td>$<%= booking.getTotalPrice() %></td>
    </tr>
</table>

<h3>Payment Information</h3>
<form action="<%= request.getContextPath() %>/customer/payments/make" method="post">
    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">

    <table>
        <tr>
            <td>Payment Method:</td>
            <td>
                <select name="method" required>
                    <option value="">-- Select Payment Method --</option>
                    <option value="Credit Card">Credit Card</option>
                    <option value="Debit Card">Debit Card</option>
                    <option value="PayPal">PayPal</option>
                    <option value="Bank Transfer">Bank Transfer</option>
                </select>
            </td>
        </tr>
        <tr>
            <td>Card Number:</td>
            <td><input type="text" name="cardNumber"></td>
        </tr>
        <tr>
            <td>Expiry Date:</td>
            <td><input type="text" name="expiryDate" required placeholder="MM/YY"></td>
        </tr>
        <tr>
            <td>CVV:</td>
            <td><input type="text" name="cvv" ></td>
        </tr>
        <tr>
            <td>
                <input type="submit" value="Submit Payment">
                <input type="reset" value="Reset">
            </td>
        </tr>
    </table>
</form>

<div >
    <h4>Payment Information:</h4>
    <ul>
        <li>Your payment will be processed and set to "Pending" status.</li>
        <li>Our payment manager will review and approve your payment shortly.</li>
        <li>You will receive a confirmation email once your payment is approved.</li>
        <li>Keep your payment ID for future reference.</li>
    </ul>
</div>

<% } else { %>
<p>No booking information available. Please select a valid booking.</p>
<a href="<%= request.getContextPath() %>/customer/bookings/history">View Your Bookings</a>
<% } %>

<p><a href="<%= request.getContextPath() %>/tour-customer-dashboard">Back to Dashboard</a></p>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>