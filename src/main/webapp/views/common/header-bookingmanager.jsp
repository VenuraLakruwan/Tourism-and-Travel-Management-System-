<%-- File: src/main/webapp/views/common/header-booking-manager.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userType = (String) session.getAttribute("userType");
    if (!"bookingManager".equals(userType)) {
        response.sendRedirect(request.getContextPath() + "/tour-login");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Tour Package Booking System</title>
        <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/Booking-Manager/header.css">
    </head>
    <body>
    <header>
        <div>
            <h1>Tour Package Booking System - Booking Manager Portal</h1>
        </div>
    </header>

    <nav>
        <div >
            <ul>
                <li><a href="<%= request.getContextPath() %>/tour-booking-manager-dashboard">Dashboard</a></li>
                <li>
                    <a href="#">Booking Management</a>
                    <ul>
                        <li><a href="<%= request.getContextPath() %>/tour-booking-manager-bookings?action=list">View All Bookings</a></li>
                        <li><a href="<%= request.getContextPath() %>/tour-booking-manager-bookings?action=update">Update Booking Details</a></li>
                        <li><a href="<%= request.getContextPath() %>/tour-booking-manager-bookings?action=cancel">Cancel Booking</a></li>
                    </ul>
                </li>
                <li><a href="<%= request.getContextPath() %>/tour-logout">Logout</a></li>
            </ul>
        </div>
    </nav>

<html>

