<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Payment" %>
<%@ page import="java.util.List" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    String statusFilter = (String) request.getAttribute("statusFilter");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Management</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Payment-Manager/list.css">
</head>
<body>
<jsp:include page="/views/common/header-paymentmanager.jsp"/>

<h2>Payment Management</h2>

<% if (request.getParameter("success") != null) { %>
<div class="success"><%= request.getParameter("success") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>

<h3>Filter Options</h3>
<table>
    <tr>
        <td>
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=All">All Payments</a> |
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Pending">Pending Only</a> |
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Approved">Approved Only</a> |
            <a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Rejected">Rejected Only</a>
        </td>
    </tr>
</table>

<h3>Payment List</h3>
<table>
    <tr>
        <th>Payment ID</th>
        <th>Customer ID</th>
        <th>Booking ID</th>
        <th>Amount</th>
        <th>Method</th>
        <th>Status</th>
        <th>Payment Date</th>
        <th>Actions</th>
    </tr>
    <% if (payments != null && !payments.isEmpty()) {
        for (Payment payment : payments) { %>
    <tr>
        <td><%= payment.getPaymentId() %></td>
        <td><%= payment.getCustomerId() %></td>
        <td><%= payment.getBookingId() %></td>
        <td>$<%= payment.getAmount() %></td>
        <td><%= payment.getMethod() %></td>
        <td>
            <% if ("Pending".equalsIgnoreCase(payment.getStatus())) { %>
            <span class="status-pending"><%= payment.getStatus() %></span>
            <% } else if ("Approved".equalsIgnoreCase(payment.getStatus())) { %>
            <span class="status-approved"><%= payment.getStatus() %></span>
            <% } else if ("Rejected".equalsIgnoreCase(payment.getStatus())) { %>
            <span class="status-rejected"><%= payment.getStatus() %></span>
            <% } else { %>
            <%= payment.getStatus() %>
            <% } %>
        </td>
        <td><%= payment.getPaymentDate() %></td>
        <td>
            <% if ("Pending".equalsIgnoreCase(payment.getStatus())) { %>
            <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post" style="display: inline;">
                <input type="hidden" name="action" value="approve">
                <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                <input type="submit" value="Approve" class="btn-approve">
            </form>
            <form action="<%= request.getContextPath() %>/tour-payment-manager-payments" method="post" style="display: inline;">
                <input type="hidden" name="action" value="reject">
                <input type="hidden" name="paymentId" value="<%= payment.getPaymentId() %>">
                <input type="submit" value="Reject" class="btn-reject">
            </form>
            <% } else { %>
            No actions available
            <% } %>
        </td>
    </tr>
    <% }
    } else { %>
    <tr>
        <td>No payments found</td>
    </tr>
    <% } %>
</table>

<p><a href="<%= request.getContextPath() %>/tour-payment-manager-dashboard">Back to Dashboard</a></p>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>