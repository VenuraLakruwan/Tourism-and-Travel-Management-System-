<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%@ page import="com.travel.model.CustomerSupportOfficer" %>
<%@ page import="java.util.List" %>
<%
  // Check if system admin is logged in
  SystemAdmin admin = (SystemAdmin) session.getAttribute("admin");
  if (admin == null) {
    response.sendRedirect(request.getContextPath() + "/tour-login");
    return;
  }

  List<CustomerSupportOfficer> customerSupportOfficers = (List<CustomerSupportOfficer>) request.getAttribute("customerSupportOfficers");
%>
<%@ include file="../../common/header-system-admin.jsp" %>
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/users.css">

<h2>Support Officers</h2>

<%-- Display success or error messages --%>
<% if (request.getParameter("success") != null) { %>
<div class="success"><%= request.getParameter("success") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>

<h3>Add New Support Officer</h3>
<form action="<%= request.getContextPath() %>/tour-system-admin-users" method="post">
  <input type="hidden" name="action" value="add-support-officer">
  <table>
    <tr>
      <td>Name:</td>
      <td><input type="text" name="name" required></td>
    </tr>
    <tr>
      <td>Job Title:</td>
      <td><input type="text" name="jobTitle" required></td>
    </tr>
    <tr>
      <td>Department:</td><td>
      <input type="text" name="department" required></td>
    </tr>
    <tr>
      <td>Contact Number:</td>
      <td><input type="text" name="contactNumber" required></td>
    </tr>
    <tr>
      <td>Email:</td>
      <td><input type="email" name="email" required></td>
    </tr>
    <tr>
      <td>Password:</td>
      <td><input type="password" name="password" required></td>
    </tr>
    <tr>
      <td >
      <input type="submit" value="Add Support Officer">
      <input type="reset" value="Reset">
    </td></tr>
  </table>
</form>

<h3>Current Support Officers</h3>
<% if (customerSupportOfficers != null && !customerSupportOfficers.isEmpty()) { %>
<table >
  <tr>
    <th>Employee ID</th>
    <th>Name</th>
    <th>Email</th>
    <th>Job Title</th>
    <th>Department</th>
    <th>Contact Number</th>
    <th>Actions</th>
  </tr>
  <% for (CustomerSupportOfficer manager : customerSupportOfficers) { %>
  <tr>
    <td><%= manager.getEmployeeId() %></td>
    <td><%= manager.getName() %></td>
    <td><%= manager.getEmail() %></td>
    <td><%= manager.getJobTitle() %></td>
    <td><%= manager.getDepartment() %></td>
    <td><%= manager.getContactNumber() %></td>
    <td class="actions">
      <a href="<%= request.getContextPath() %>/tour-system-admin-users?action=edit-support-officer&id=<%= manager.getEmployeeId() %>" class="btn-edit">Edit</a>
      <form action="<%= request.getContextPath() %>/tour-system-admin-users" method="post" style="display:inline;">
        <input type="hidden" name="action" value="delete-support-officer">
        <input type="hidden" name="employeeId" value="<%= manager.getEmployeeId() %>">
        <input type="submit" value="Delete" class="btn-delete"
               onclick="return confirm('Are you sure you want to delete this support officer? This action cannot be undone.');">
      </form>
    </td>
  </tr>
  <% } %>
</table>
<% } else { %>
<div class="no-data">
  <p>No support officers found.</p>
</div>
<% } %>

<p><a href="<%= request.getContextPath() %>/tour-system-admin-dashboard">Back to Dashboard</a></p>

<%@ include file="../../common/footer.jsp" %>