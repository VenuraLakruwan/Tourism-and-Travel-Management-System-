<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Customer" %>
<%@ page import="com.travel.model.Package" %>
<%
    Customer customer = (Customer) session.getAttribute("user");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }

    Package tourPackage = (Package) request.getAttribute("package");
    if (tourPackage == null) {
        response.sendRedirect(request.getContextPath() + "/tour-customer-packages/list?error=Package+not+found");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Book a Package - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/booking-create.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<h2>Book a Package</h2>

<% if (request.getAttribute("errorMessage") != null) { %>
<div class="error"><%= request.getAttribute("errorMessage") %></div>
<% } %>

<h3>Package Details</h3>
<table >
    <tr>
        <td>Package Name:</td>
        <td><%= tourPackage.getPackageName() %></td>
    </tr>
    <tr>
        <td>Price:</td>
        <td>$<%= tourPackage.getPrice() %></td>
    </tr>
    <tr>
        <td>Duration:</td>
        <td><%= tourPackage.getDuration() %></td>
    </tr>
</table>

<h3>Booking Information</h3>
<form action="<%= request.getContextPath() %>/customer/bookings/create" method="post">
    <input type="hidden" name="packageId" value="<%= tourPackage.getPackageId() %>">

    <table>
        <tr>
            <td>Customer ID:</td>
            <td><%= customer.getCustomerId() %></td>
        </tr>
        <tr>
            <td>Customer Name:</td>
            <td><%= customer.getCustomerName() %></td>
        </tr>
        <tr>
            <td>Package ID:</td>
            <td><%= tourPackage.getPackageId() %></td>
        </tr>
        <tr>
            <td>Preferred Booking Date:</td>
            <td>
                <input type="date" name="bookingDate" required
                       min="<%= tourPackage.getStartDate() %>"
                       max="<%= tourPackage.getEndDate() %>">
                <small>(Must be between package start and end dates)</small>
            </td>
        </tr>
        <tr>
            <td>Number of Travelers:</td>
            <td>
                <input type="number" name="numTravelers" min="1" max="20" value="1" required>
                <small>(Maximum 20 travelers per booking)</small>
            </td>
        </tr>
        <tr>
            <td >
                <input type="submit" value="Book Now">
                <input type="reset" value="Reset">
            </td>
        </tr>
    </table>
</form>

<p><a href="<%= request.getContextPath() %>/tour-customer-packages/list">Back to Packages</a></p>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>