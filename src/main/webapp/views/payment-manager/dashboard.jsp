<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.PaymentManager" %>
<%@ page import="com.travel.service.PaymentService" %>
<%@ page import="com.travel.model.Payment" %>
<%@ page import="java.util.List" %>
<%
    PaymentManager manager = (PaymentManager) session.getAttribute("user");
    PaymentService paymentService = new PaymentService();

    List<Payment> pendingPayments = paymentService.getPendingPayments();
    List<Payment> approvedPayments = paymentService.getPaymentsByStatus("Approved");
    List<Payment> rejectedPayments = paymentService.getPaymentsByStatus("Rejected");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Payment Manager Dashboard</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Payment-Manager/dashboard.css">
</head>
<body>
<jsp:include page="/views/common/header-paymentmanager.jsp"/>

<h2>Welcome, <%= manager.getName() %>!</h2>

<h3>Payment Statistics</h3>
<table>
    <tr>
        <th>Pending Payments</th>
        <th>Approved Payments</th>
        <th>Rejected Payments</th>
        <th>Total Revenue</th>
    </tr>
    <tr>
        <td><%= pendingPayments.size() %></td>
        <td><%= approvedPayments.size() %></td>
        <td><%= rejectedPayments.size() %></td>
        <td>$<%= paymentService.getTotalRevenue() %></td>
    </tr>
</table>

<h3>Quick Actions</h3>
<div class="quick-actions">
    <div class="quick-action">
        <h3><a href="<%= request.getContextPath() %>/tour-payment-manager-payments">View All Payments</a></h3>
        <p>Review and manage all customer payments</p>
    </div>
    <div class="quick-action">
        <h3><a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Pending">Pending Payments</a></h3>
        <p>Review payments awaiting approval</p>
    </div>
    <div class="quick-action">
        <h3><a href="<%= request.getContextPath() %>/tour-payment-manager-payments?status=Approved">Approved Payments</a></h3>
        <p>View all approved payments</p>
    </div>
</div>

<h3>Recent Pending Payments</h3>
<table >
    <tr>
        <th>Payment ID</th>
        <th>Customer ID</th>
        <th>Amount</th>
        <th>Actions</th>
    </tr>
    <% for (int i = 0; i < Math.min(pendingPayments.size(), 5); i++) {
        Payment payment = pendingPayments.get(i); %>
    <tr>
        <td><%= payment.getPaymentId() %></td>
        <td><%= payment.getCustomerId() %></td>
        <td>$<%= payment.getAmount() %></td>
        <td>
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
        </td>
    </tr>
    <% } %>
</table>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>