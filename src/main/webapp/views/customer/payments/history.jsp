<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Payment" %>
<%@ page import="java.util.List" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment History - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/package.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<h2>My Payment History</h2>

<% if (request.getParameter("success") != null) { %>
<div class="success"><%= request.getParameter("success") %></div>
<% } %>
<% if (request.getAttribute("successMessage") != null) { %>
<div class="success"><%= request.getAttribute("successMessage") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>
<% if (request.getAttribute("errorMessage") != null) { %>
<div class="error"><%= request.getAttribute("errorMessage") %></div>
<% } %>

<h3>Payment Summary</h3>
<table>
    <tr>
        <th>Total Payments</th>
        <th>Approved Payments</th>
        <th>Pending Payments</th>
        <th>Rejected Payments</th>
    </tr>
    <tr>
        <td><%= payments != null ? payments.size() : 0 %></td>
        <td>
            <%
                int approvedCount = 0;
                if (payments != null) {
                    for (Payment payment : payments) {
                        if ("Approved".equals(payment.getStatus())) {
                            approvedCount++;
                        }
                    }
                }
            %>
            <%= approvedCount %>
        </td>
        <td>
            <%
                int pendingCount = 0;
                if (payments != null) {
                    for (Payment payment : payments) {
                        if ("Pending".equals(payment.getStatus())) {
                            pendingCount++;
                        }
                    }
                }
            %>
            <%= pendingCount %>
        </td>
        <td>
            <%
                int rejectedCount = 0;
                if (payments != null) {
                    for (Payment payment : payments) {
                        if ("Rejected".equals(payment.getStatus())) {
                            rejectedCount++;
                        }
                    }
                }
            %>
            <%= rejectedCount %>
        </td>
    </tr>
</table>

<h3>Payment History</h3>
<table>
    <tr>
        <th>Payment ID</th>
        <th>Booking ID</th>
        <th>Amount</th>
        <th>Method</th>
        <th>Status</th>
        <th>Payment Date</th>
    </tr>
    <% if (payments != null && !payments.isEmpty()) { %>
    <% for (Payment payment : payments) { %>
    <tr>
        <td><%= payment.getPaymentId() %></td>
        <td><%= payment.getBookingId() %></td>
        <td>$<%= payment.getAmount() %></td>
        <td><%= payment.getMethod() %></td>
        <td>
            <% if ("Pending".equals(payment.getStatus())) { %>
            <span class="status-pending"><%= payment.getStatus() %></span>
            <% } else if ("Approved".equals(payment.getStatus())) { %>
            <span class="status-approved"><%= payment.getStatus() %></span>
            <% } else if ("Rejected".equals(payment.getStatus())) { %>
            <span class="status-rejected"><%= payment.getStatus() %></span>
            <% } else { %>
            <%= payment.getStatus() %>
            <% } %>
        </td>
        <td><%= payment.getPaymentDate() %></td>
    </tr>
    <% }
    } else { %>
    <tr>
        <td>No payments found</td>
    </tr>
    <% } %>
</table>

<div class="info">
    <h4>Payment Status Guide:</h4>
    <ul>
        <li><span class="status-pending">Pending</span> - Your payment is being processed and awaiting approval by our payment manager</li>
        <li><span class="status-approved">Approved</span> - Your payment has been approved and your booking is confirmed</li>
        <li><span class="status-rejected">Rejected</span> - Your payment was rejected. Please contact support for assistance</li>
    </ul>
</div>

<p><a href="<%= request.getContextPath() %>/tour-customer-dashboard">Back to Dashboard</a></p>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>