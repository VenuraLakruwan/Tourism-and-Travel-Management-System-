<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.travel.model.SystemAdmin" %>
<%@ page import="com.travel.model.PackageManager" %>
<%@ page import="com.travel.model.BookingManager" %>
<%@ page import="com.travel.model.PaymentManager" %>
<%@ page import="com.travel.model.CustomerSupportOfficer" %>
<%
  HttpSession sess = request.getSession(false);
  SystemAdmin admin = (SystemAdmin) sess.getAttribute("user");
  if (admin == null || !"systemAdmin".equals(sess.getAttribute("userType"))) {
    response.sendRedirect(request.getContextPath() + "/tour-login");
    return;
  }

  Object manager = request.getAttribute("manager");
  String managerType = (String) request.getAttribute("managerType");
%>
<jsp:include page="../../common/header-system-admin.jsp" />
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/System-Admin/configurations.css">

<h2>Edit <%= managerType.substring(0,1).toUpperCase() + managerType.substring(1) %> Manager</h2>

<%-- Display success or error messages --%>
<% if (request.getParameter("success") != null) { %>
<div class="success"><%= request.getParameter("success") %></div>
<% } %>
<% if (request.getParameter("error") != null) { %>
<div class="error"><%= request.getParameter("error") %></div>
<% } %>

<% if (manager != null) { %>
<form action="<%= request.getContextPath() %>/tour-system-admin-configuration" method="post">
  <input type="hidden" name="action" value="edit-<%= managerType %>-manager">

  <% if (manager instanceof PackageManager) { %>
  <% PackageManager pm = (PackageManager) manager; %>
  <input type="hidden" name="employeeId" value="<%= pm.getEmployeeId() %>">
  <table>
    <tr><td>Employee ID:</td><td><%= pm.getEmployeeId() %></td></tr>
    <tr><td>Name:</td><td><input type="text" name="name" value="<%= pm.getName() %>" required></td></tr>
    <tr><td>Job Title:</td><td><input type="text" name="jobTitle" value="<%= pm.getJobTitle() %>" required></td></tr>
    <tr><td>Department:</td><td><input type="text" name="department" value="<%= pm.getDepartment() %>" required></td></tr>
    <tr><td>Contact Number:</td><td><input type="text" name="contactNumber" value="<%= pm.getContactNumber() %>" required></td></tr>
    <tr><td>Email:</td><td><input type="email" name="email" value="<%= pm.getEmail() %>" required></td></tr>
    <tr><td>
      <input type="submit" value="Update Package Manager">
      <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=role-assignment">Cancel</a>
    </td></tr>
  </table>
  <% } else if (manager instanceof BookingManager) { %>
  <% BookingManager bm = (BookingManager) manager; %>
  <input type="hidden" name="employeeId" value="<%= bm.getEmployeeId() %>">
  <table>
    <tr>
      <td>Employee ID:</td>
      <td><%= bm.getEmployeeId() %></td>
    </tr>
    <tr>
      <td>Name:</td>
      <td><input type="text" name="name" value="<%= bm.getName() %>" required></td>
    </tr>
    <tr>
      <td>Job Title:</td>
      <td><input type="text" name="jobTitle" value="<%= bm.getJobTitle() %>" required></td>
    </tr>
    <tr>
      <td>Department:</td>
      <td><input type="text" name="department" value="<%= bm.getDepartment() %>" required></td>
    </tr>
    <tr>
      <td>Contact Number:</td>
      <td><input type="text" name="contactNumber" value="<%= bm.getContactNumber() %>" required></td>
    </tr>
    <tr>
      <td>Email:</td>
      <td><input type="email" name="email" value="<%= bm.getEmail() %>" required></td>
    </tr>
    <tr>
      <td>
      <input type="submit" value="Update Booking Manager">
      <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=role-assignment">Cancel</a>
    </td></tr>
  </table>
  <% } else if (manager instanceof PaymentManager) { %>
  <% PaymentManager pym = (PaymentManager) manager; %>
  <input type="hidden" name="employeeId" value="<%= pym.getEmployeeId() %>">
  <table>
    <tr><td>Employee ID:</td><td><%= pym.getEmployeeId() %></td></tr>
    <tr><td>Name:</td><td><input type="text" name="name" value="<%= pym.getName() %>" required></td></tr>
    <tr><td>Job Title:</td><td><input type="text" name="jobTitle" value="<%= pym.getJobTitle() %>" required></td></tr>
    <tr><td>Department:</td><td><input type="text" name="department" value="<%= pym.getDepartment() %>" required></td></tr>
    <tr><td>Contact Number:</td><td><input type="text" name="contactNumber" value="<%= pym.getContactNumber() %>" required></td></tr>
    <tr><td>Email:</td><td><input type="email" name="email" value="<%= pym.getEmail() %>" required></td></tr>
    <tr><td>
      <input type="submit" value="Update Payment Manager">
      <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=role-assignment">Cancel</a>
    </td></tr>
  </table>
  <% } else if (manager instanceof CustomerSupportOfficer) { %>
  <% CustomerSupportOfficer cso = (CustomerSupportOfficer) manager; %>
  <input type="hidden" name="employeeId" value="<%= cso.getEmployeeId() %>">
  <table>
    <tr><td>Employee ID:</td><td><%= cso.getEmployeeId() %></td></tr>
    <tr><td>Name:</td><td><input type="text" name="name" value="<%= cso.getName() %>" required></td></tr>
    <tr><td>Job Title:</td><td><input type="text" name="jobTitle" value="<%= cso.getJobTitle() %>" required></td></tr>
    <tr><td>Department:</td><td><input type="text" name="department" value="<%= cso.getDepartment() %>" required></td></tr>
    <tr><td>Contact Number:</td><td><input type="text" name="contactNumber" value="<%= cso.getContactNumber() %>" required></td></tr>
    <tr><td>Email:</td><td><input type="email" name="email" value="<%= cso.getEmail() %>" required></td></tr>
    <tr><td>
      <input type="submit" value="Update Support Officer">
      <a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=role-assignment">Cancel</a>
    </td></tr>
  </table>
  <% } %>
</form>
<% } else { %>
<div class="error">
  <p>Manager not found.</p>
  <p><a href="<%= request.getContextPath() %>/tour-system-admin-configuration?action=role-assignment">Back to Role Assignment</a></p>
</div>
<% } %>

<jsp:include page="../../common/footer.jsp" />