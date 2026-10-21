<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.Package" %>
<%@ page import="java.util.List" %>
<%
    List<Package> packages = (List<Package>) request.getAttribute("packages");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Packages - Customer</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Customer/package.css">
</head>
<body>
<jsp:include page="/views/common/header-customer.jsp"/>

<h2>Available Packages</h2>

<% if (packages != null && !packages.isEmpty()) { %>
<% for (Package pkg : packages) { %>
<div class="package-box">
    <h3><%= pkg.getPackageName() %></h3>
    <p class="price">$<%= pkg.getPrice() %></p>
    <p><%= pkg.getDuration() %></p>
    <div class="buttons">
        <!-- IMPORTANT: Fix the details link below -->
        <a href="<%= request.getContextPath() %>/tour-customer-packages/details?id=<%= pkg.getPackageId() %>" class="btn-details">Details</a>
    </div>
</div>
<% } %>
<% } else { %>
<p>No packages available at the moment.</p>
<% } %>

<jsp:include page="/views/common/footer.jsp"/>
</body>
</html>