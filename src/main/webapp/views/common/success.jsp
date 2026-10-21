<%-- File: src/main/webapp/views/common/success.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Success - Tour Package Booking System</title>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/auth/sucess.css">
</head>
<body>
<header>
    <div>
        <h1>Tour Package Booking System</h1>
    </div>
</header>

<div>
    <div class="content">
        <div class="success">
            <h2>Success!</h2>
            <p><%= request.getAttribute("successMessage") != null ? request.getAttribute("successMessage") : "Operation completed successfully." %></p>
            <p><a href="<%= request.getAttribute("redirectUrl") != null ? request.getAttribute("redirectUrl") : request.getContextPath() %>">Continue</a></p>
        </div>
    </div>
</div>

<footer>
    <div>
        <p>&copy; 2023 Tour Package Booking System. All rights reserved.</p>
    </div>
</footer>
</body>
</html>