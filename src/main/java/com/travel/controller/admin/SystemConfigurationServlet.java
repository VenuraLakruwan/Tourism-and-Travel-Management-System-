// File: src/main/java/com/travel/controller/admin/SystemConfigurationServlet.java
package com.travel.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.travel.model.SystemAdmin;
import com.travel.service.SystemAdminService;
import com.travel.model.PackageManager;
import com.travel.model.PaymentManager;
import com.travel.model.BookingManager;
import com.travel.model.CustomerSupportOfficer;

public class SystemConfigurationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SystemAdminService systemAdminService;

    public void init() {
        systemAdminService = new SystemAdminService();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = getActionParameter(request);

        switch (action) {
            case "system-messages":
                showSystemMessages(request, response);
                break;
            case "access-control":
                showAccessControl(request, response);
                break;
            case "role-assignment":
                showRoleAssignment(request, response);
                break;
            case "edit-manager":
                showEditManagerForm(request, response);
                break;
            default:
                showSystemMessages(request, response);
                break;
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = getActionParameter(request);

        switch (action) {
            case "add-package-manager":
                handleAddPackageManager(request, response);
                break;
            case "add-booking-manager":
                handleAddBookingManager(request, response);
                break;
            case "add-payment-manager":
                handleAddPaymentManager(request, response);
                break;
            case "add-support-officer":
                handleAddSupportOfficer(request, response);
                break;
            case "edit-package-manager":
                handleEditPackageManager(request, response);
                break;
            case "edit-booking-manager":
                handleEditBookingManager(request, response);
                break;
            case "edit-payment-manager":
                handleEditPaymentManager(request, response);
                break;
            case "edit-support-officer":
                handleEditSupportOfficer(request, response);
                break;
            case "delete-customer":
                handleDeleteCustomer(request, response);
                break;
            case "delete-package-manager":
                handleDeletePackageManager(request, response);
                break;
            case "delete-booking-manager":
                handleDeleteBookingManager(request, response);
                break;
            case "delete-payment-manager":
                handleDeletePaymentManager(request, response);
                break;
            case "delete-support-officer":
                handleDeleteSupportOfficer(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/tour-system-admin-configuration");
                break;
        }
    }

    // Helper Methods
    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("user") != null &&
                "systemAdmin".equals(session.getAttribute("userType"));
    }

    private String getActionParameter(HttpServletRequest request) {
        String action = request.getParameter("action");
        return action == null ? "system-messages" : action;
    }

    private void forwardToJsp(HttpServletRequest request, HttpServletResponse response, String jspPath)
            throws ServletException, IOException {
        request.getRequestDispatcher(jspPath).forward(request, response);
    }

    private void redirectToRoleAssignment(HttpServletRequest request, HttpServletResponse response,
                                          String result, String message) throws IOException {
        String redirectUrl = request.getContextPath() + "/tour-system-admin-configuration?action=role-assignment&" + result + "=" + message;
        response.sendRedirect(redirectUrl);
    }

    // GET Handlers
    private void showSystemMessages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forwardToJsp(request, response, "/views/system-admin/configuration/system-messages.jsp");
    }

    private void showAccessControl(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        forwardToJsp(request, response, "/views/system-admin/configuration/access-control.jsp");
    }

    private void showRoleAssignment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("customers", systemAdminService.getAllCustomers());
        request.setAttribute("packageManagers", systemAdminService.getAllPackageManagers());
        request.setAttribute("bookingManagers", systemAdminService.getAllBookingManagers());
        request.setAttribute("paymentManagers", systemAdminService.getAllPaymentManagers());
        request.setAttribute("supportOfficers", systemAdminService.getAllCustomerSupportOfficers());
        forwardToJsp(request, response, "/views/system-admin/configuration/role-assignment.jsp");
    }

    private void showEditManagerForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String managerType = request.getParameter("type");
        int employeeId = Integer.parseInt(request.getParameter("id"));

        switch (managerType) {
            case "package":
                request.setAttribute("manager", systemAdminService.getPackageManagerById(employeeId));
                break;
            case "booking":
                request.setAttribute("manager", systemAdminService.getBookingManagerById(employeeId));
                break;
            case "payment":
                request.setAttribute("manager", systemAdminService.getPaymentManagerById(employeeId));
                break;
            case "support":
                request.setAttribute("manager", systemAdminService.getCustomerSupportOfficerById(employeeId));
                break;
        }

        request.setAttribute("managerType", managerType);
        forwardToJsp(request, response, "/views/system-admin/configuration/edit-manager.jsp");
    }

    // POST Handlers - Add Operations
    private void handleAddPackageManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        PackageManager pm = createPackageManagerFromRequest(request);
        boolean success = systemAdminService.addPackageManager(pm);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Package manager added successfully" : "Failed to add package manager");
    }

    private void handleAddBookingManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        BookingManager bm = createBookingManagerFromRequest(request);
        boolean success = systemAdminService.addBookingManager(bm);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Booking manager added successfully" : "Failed to add booking manager");
    }

    private void handleAddPaymentManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        PaymentManager pym = createPaymentManagerFromRequest(request);
        boolean success = systemAdminService.addPaymentManager(pym);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Payment manager added successfully" : "Failed to add payment manager");
    }

    private void handleAddSupportOfficer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        CustomerSupportOfficer cso = createSupportOfficerFromRequest(request);
        boolean success = systemAdminService.addCustomerSupportOfficer(cso);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Support officer added successfully" : "Failed to add support officer");
    }

    private void handleEditPackageManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        PackageManager pm = createPackageManagerFromRequest(request);
        pm.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
        boolean success = systemAdminService.updatePackageManager(pm);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Package manager updated successfully" : "Failed to update package manager");
    }

    private void handleEditBookingManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        BookingManager bm = createBookingManagerFromRequest(request);
        bm.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
        boolean success = systemAdminService.updateBookingManager(bm);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Booking manager updated successfully" : "Failed to update booking manager");
    }

    private void handleEditPaymentManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        PaymentManager pym = createPaymentManagerFromRequest(request);
        pym.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
        boolean success = systemAdminService.updatePaymentManager(pym);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Payment manager updated successfully" : "Failed to update payment manager");
    }

    private void handleEditSupportOfficer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        CustomerSupportOfficer cso = createSupportOfficerFromRequest(request);
        cso.setEmployeeId(Integer.parseInt(request.getParameter("employeeId")));
        boolean success = systemAdminService.updateCustomerSupportOfficer(cso);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Support officer updated successfully" : "Failed to update support officer");
    }

    // POST Handlers - Delete Operations
    private void handleDeleteCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        boolean success = systemAdminService.deleteCustomer(customerId);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Customer deleted successfully" : "Failed to delete customer");
    }

    private void handleDeletePackageManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        boolean success = systemAdminService.deletePackageManager(employeeId);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Package manager deleted successfully" : "Failed to delete package manager");
    }

    private void handleDeleteBookingManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        boolean success = systemAdminService.deleteBookingManager(employeeId);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Booking manager deleted successfully" : "Failed to delete booking manager");
    }

    private void handleDeletePaymentManager(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        boolean success = systemAdminService.deletePaymentManager(employeeId);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Payment manager deleted successfully" : "Failed to delete payment manager");
    }

    private void handleDeleteSupportOfficer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int employeeId = Integer.parseInt(request.getParameter("employeeId"));
        boolean success = systemAdminService.deleteCustomerSupportOfficer(employeeId);
        redirectToRoleAssignment(request, response, success ? "success" : "error",
                success ? "Support officer deleted successfully" : "Failed to delete support officer");
    }

    // Factory Methods - Create objects from request parameters
    private PackageManager createPackageManagerFromRequest(HttpServletRequest request) {
        PackageManager pm = new PackageManager();
        pm.setName(request.getParameter("name"));
        pm.setJobTitle(request.getParameter("jobTitle"));
        pm.setDepartment(request.getParameter("department"));
        pm.setContactNumber(request.getParameter("contactNumber"));
        pm.setEmail(request.getParameter("email"));
        pm.setPassword(request.getParameter("password"));
        return pm;
    }

    private BookingManager createBookingManagerFromRequest(HttpServletRequest request) {
        BookingManager bm = new BookingManager();
        bm.setName(request.getParameter("name"));
        bm.setJobTitle(request.getParameter("jobTitle"));
        bm.setDepartment(request.getParameter("department"));
        bm.setContactNumber(request.getParameter("contactNumber"));
        bm.setEmail(request.getParameter("email"));
        bm.setPassword(request.getParameter("password"));
        return bm;
    }

    private PaymentManager createPaymentManagerFromRequest(HttpServletRequest request) {
        PaymentManager pym = new PaymentManager();
        pym.setName(request.getParameter("name"));
        pym.setJobTitle(request.getParameter("jobTitle"));
        pym.setDepartment(request.getParameter("department"));
        pym.setContactNumber(request.getParameter("contactNumber"));
        pym.setEmail(request.getParameter("email"));
        pym.setPassword(request.getParameter("password"));
        return pym;
    }

    private CustomerSupportOfficer createSupportOfficerFromRequest(HttpServletRequest request) {
        CustomerSupportOfficer cso = new CustomerSupportOfficer();
        cso.setName(request.getParameter("name"));
        cso.setJobTitle(request.getParameter("jobTitle"));
        cso.setDepartment(request.getParameter("department"));
        cso.setContactNumber(request.getParameter("contactNumber"));
        cso.setEmail(request.getParameter("email"));
        cso.setPassword(request.getParameter("password"));
        return cso;
    }
}