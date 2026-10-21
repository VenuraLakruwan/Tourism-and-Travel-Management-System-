<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Customer" %>

<%
    Customer customer = (Customer) session.getAttribute("user");
    if (customer == null) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>

<jsp:include page="../../common/header-customer.jsp" />

<div>
    <h2>Report an Issue</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
    <p><%= request.getAttribute("errorMessage") %></p>
    <% } %>
    <% if (request.getAttribute("successMessage") != null) { %>
    <p><%= request.getAttribute("successMessage") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/tour-customer-report-issue" method="post">
        <input type="hidden" name="action" value="report-issue"/>
        <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>"/>

        <label for="issueDetails">Issue Details:</label><br>
        <textarea id="issueDetails" name="issueDetails" rows="5" cols="40" placeholder="Describe the issue..." required></textarea><br><br>

        <input type="submit" value="Submit Issue"/>
    </form>

    <p><a href="<%= request.getContextPath() %>/tour-customer-dashboard">Back to Dashboard</a></p>
</div>

<jsp:include page="../../common/footer.jsp"/>
