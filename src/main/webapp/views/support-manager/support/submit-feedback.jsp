<%--
  Created by IntelliJ IDEA.
  User: LENOVO
  Date: 9/24/2025
  Time: 10:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../common/header-support-officer.jsp" %>
<head>
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Support-Officer/style.css">

</head>
<h2>Submit Feedback</h2>

<% if (request.getParameter("error") != null) { %>
<div class="error">Failed to submit feedback. Please try again.</div>
<% } %>

<form action="<%= request.getContextPath() %>/customer/support/submit-feedback" method="post">
    <table >
        <tr>
            <td>Feedback:</td>
            <td><textarea name="description" rows="5" cols="50" required></textarea></td>
        </tr>
        <tr>
            <td >
                <input type="submit" value="Submit Feedback">
                <input type="reset" value="Reset">
            </td>
        </tr>
    </table>
</form>

<p><a href="<%= request.getContextPath() %>/customer/dashboard">Back to Dashboard</a></p>

