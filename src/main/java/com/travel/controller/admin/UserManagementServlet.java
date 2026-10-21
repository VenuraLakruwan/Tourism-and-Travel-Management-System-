// File: src/main/java/com/travel/controller/admin/UserManagementServlet.java
package com.travel.controller.admin;

import java.io.IOException;
import com.travel.model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.travel.service.*;

public class UserManagementServlet extends HttpServlet {
    private SystemAdminService systemAdminService;
    private PackageManagerService packageManagerService;
    private BookingManagerService bookingManagerService;
    private PaymentManagerService paymentManagerService;
    private CustomerSupportService customerSupportService;

    @Override
    public void init() {
        systemAdminService = new SystemAdminService();
        packageManagerService = new PackageManagerService();
        bookingManagerService = new BookingManagerService();
        paymentManagerService = new PaymentManagerService();
        customerSupportService = new CustomerSupportService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (!isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        request.setAttribute("admin", session.getAttribute("user"));
        String action = request.getParameter("action");
        if (action == null) action = "system-admins";

        switch (action) {
            case "customers":
                forward(request, response, "/views/system-admin/users/customers.jsp");
                break;
            case "package-managers":
                request.setAttribute("packageManagers", packageManagerService.getAllPackageManagers());
                forward(request, response, "/views/system-admin/users/package-managers.jsp");
                break;
            case "booking-managers":
                request.setAttribute("bookingManagers", bookingManagerService.getAllBookingManagers());
                forward(request, response, "/views/system-admin/users/booking-managers.jsp");
                break;
            case "payment-managers":
                request.setAttribute("paymentManagers", paymentManagerService.getAllPaymentManagers());
                forward(request, response, "/views/system-admin/users/payment-managers.jsp");
                break;
            case "support-officers":
                request.setAttribute("supportOfficers", customerSupportService.getAllCustomerSupportOfficers());
                forward(request, response, "/views/system-admin/users/support-officers.jsp");
                break;
            case "edit-package-manager":
                int pmEditId = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("manager", systemAdminService.getPackageManagerById(pmEditId));
                request.setAttribute("managerType", "package");
                forward(request, response, "/views/system-admin/users/edit.jsp");
                break;
            case "edit-booking-manager":
                int bmEditId = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("manager", systemAdminService.getBookingManagerById(bmEditId));
                request.setAttribute("managerType", "booking");
                forward(request, response, "/views/system-admin/users/edit.jsp");
                break;
            case "edit-payment-manager":
                int pymEditId = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("manager", systemAdminService.getPaymentManagerById(pymEditId));
                request.setAttribute("managerType", "payment");
                forward(request, response, "/views/system-admin/users/edit.jsp");
                break;
            case "edit-support-officer":
                int csoEditId = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("manager", systemAdminService.getCustomerSupportOfficerById(csoEditId));
                request.setAttribute("managerType", "support");
                forward(request, response, "/views/system-admin/users/edit.jsp");
                break;
            default: // system-admins
                request.setAttribute("admins", systemAdminService.getAllSystemAdmins());
                forward(request, response, "/views/system-admin/users/edit.jsp");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (!isAdminLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = request.getParameter("action");
        String redirectUrl = "/tour-system-admin-users?action=";
        String success = "&success=1";
        String error = "&error=";

        switch (action) {
            case "add-package-manager":
                if (handlePasswordValidation(request, response, redirectUrl + "package-managers")) return;
                redirectWithResult(request, response, redirectUrl + "package-managers",
                        systemAdminService.addPackageManager(createPackageManager(request)),
                        success, error + "Failed to add package manager");
                break;

            case "add-booking-manager":
                if (handlePasswordValidation(request, response, redirectUrl + "booking-managers")) return;
                redirectWithResult(request, response, redirectUrl + "booking-managers",
                        systemAdminService.addBookingManager(createBookingManager(request)),
                        success, error + "Failed to add booking manager");
                break;

            case "add-payment-manager":
                if (handlePasswordValidation(request, response, redirectUrl + "payment-managers")) return;
                redirectWithResult(request, response, redirectUrl + "payment-managers",
                        systemAdminService.addPaymentManager(createPaymentManager(request)),
                        success, error + "Failed to add payment manager");
                break;

            case "add-support-officer":
                if (handlePasswordValidation(request, response, redirectUrl + "support-officers")) return;
                redirectWithResult(request, response, redirectUrl + "support-officers",
                        customerSupportService.addCustomerSupportOfficer(createSupportOfficer(request)),
                        success, error + "Failed to add support officer");
                break;

            case "edit-package-manager":
                int pmEditId = Integer.parseInt(request.getParameter("employeeId"));
                PackageManager pmEdit = createPackageManager(request);
                pmEdit.setEmployeeId(pmEditId);
                // Only update password if provided
                String pmPassword = request.getParameter("password");
                if (pmPassword != null && !pmPassword.trim().isEmpty()) {
                    pmEdit.setPassword(pmPassword);
                } else {
                    // Keep existing password
                    PackageManager existingPm = systemAdminService.getPackageManagerById(pmEditId);
                    pmEdit.setPassword(existingPm.getPassword());
                }
                redirectWithResult(request, response, redirectUrl + "package-managers",
                        systemAdminService.updatePackageManager(pmEdit),
                        success, error + "Failed to update package manager");
                break;

            case "edit-booking-manager":
                int bmEditId = Integer.parseInt(request.getParameter("employeeId"));
                BookingManager bmEdit = createBookingManager(request);
                bmEdit.setEmployeeId(bmEditId);
                // Only update password if provided
                String bmPassword = request.getParameter("password");
                if (bmPassword != null && !bmPassword.trim().isEmpty()) {
                    bmEdit.setPassword(bmPassword);
                } else {
                    // Keep existing password
                    BookingManager existingBm = systemAdminService.getBookingManagerById(bmEditId);
                    bmEdit.setPassword(existingBm.getPassword());
                }
                redirectWithResult(request, response, redirectUrl + "booking-managers",
                        systemAdminService.updateBookingManager(bmEdit),
                        success, error + "Failed to update booking manager");
                break;

            case "edit-payment-manager":
                int pymEditId = Integer.parseInt(request.getParameter("employeeId"));
                PaymentManager pymEdit = createPaymentManager(request);
                pymEdit.setEmployeeId(pymEditId);
                String pymPassword = request.getParameter("password");
                if (pymPassword != null && !pymPassword.trim().isEmpty()) {
                    pymEdit.setPassword(pymPassword);
                } else {
                    // Keep existing password
                    PaymentManager existingPym = systemAdminService.getPaymentManagerById(pymEditId);
                    pymEdit.setPassword(existingPym.getPassword());
                }
                redirectWithResult(request, response, redirectUrl + "payment-managers",
                        systemAdminService.updatePaymentManager(pymEdit),
                        success, error + "Failed to update payment manager");
                break;

            case "edit-support-officer":
                int csoEditId = Integer.parseInt(request.getParameter("employeeId"));
                CustomerSupportOfficer csoEdit = createSupportOfficer(request);
                csoEdit.setEmployeeId(csoEditId);
                // Only update password if provided
                String csoPassword = request.getParameter("password");
                if (csoPassword != null && !csoPassword.trim().isEmpty()) {
                    csoEdit.setPassword(csoPassword);
                } else {
                    // Keep existing password
                    CustomerSupportOfficer existingCso = systemAdminService.getCustomerSupportOfficerById(csoEditId);
                    csoEdit.setPassword(existingCso.getPassword());
                }
                redirectWithResult(request, response, redirectUrl + "support-officers",
                        customerSupportService.updateCustomerSupportOfficer(csoEdit),
                        success, error + "Failed to update support officer");
                break;

            case "delete-package-manager":
                int pmDeleteId = Integer.parseInt(request.getParameter("employeeId"));
                redirectWithResult(request, response, redirectUrl + "package-managers",
                        systemAdminService.deletePackageManager(pmDeleteId),
                        success, error + "Failed to delete package manager");
                break;

            case "delete-booking-manager":
                int bmDeleteId = Integer.parseInt(request.getParameter("employeeId"));
                redirectWithResult(request, response, redirectUrl + "booking-managers",
                        systemAdminService.deleteBookingManager(bmDeleteId),
                        success, error + "Failed to delete booking manager");
                break;

            case "delete-payment-manager":
                int pymDeleteId = Integer.parseInt(request.getParameter("employeeId"));
                redirectWithResult(request, response, redirectUrl + "payment-managers",
                        systemAdminService.deletePaymentManager(pymDeleteId),
                        success, error + "Failed to delete payment manager");
                break;

            case "delete-support-officer":
                int csoDeleteId = Integer.parseInt(request.getParameter("employeeId"));
                redirectWithResult(request, response, redirectUrl + "support-officers",
                        customerSupportService.deleteCustomerSupportOfficer(csoDeleteId),
                        success, error + "Failed to delete support officer");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/tour-system-admin-users");
                break;
        }
    }

    private boolean isAdminLoggedIn(HttpSession session) {
        return session != null && session.getAttribute("user") != null && "systemAdmin".equals(session.getAttribute("userType"));
    }

    private void forward(HttpServletRequest req, HttpServletResponse resp, String path) throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }

    private boolean handlePasswordValidation(HttpServletRequest request, HttpServletResponse response, String redirectUrl) throws IOException {
        String password = request.getParameter("password");
        if (password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + redirectUrl + "&error=Password is required");
            return true;
        }
        return false;
    }

    private void redirectWithResult(HttpServletRequest request, HttpServletResponse response,
                                    String baseUrl, boolean success,
                                    String successParam, String error) throws IOException {
        String contextPath = request.getContextPath();
        response.sendRedirect(contextPath + baseUrl + (success ? successParam : error));
    }

    private SystemAdmin createSystemAdmin(HttpServletRequest req) {
        SystemAdmin admin = new SystemAdmin();
        admin.setName(req.getParameter("name"));
        admin.setJobTitle(req.getParameter("jobTitle"));
        admin.setDepartment(req.getParameter("department"));
        admin.setContactNumber(req.getParameter("contactNumber"));
        admin.setEmail(req.getParameter("email"));
        admin.setPassword(req.getParameter("password"));
        return admin;
    }

    private PackageManager createPackageManager(HttpServletRequest req) {
        PackageManager pm = new PackageManager();
        pm.setName(req.getParameter("name"));
        pm.setJobTitle(req.getParameter("jobTitle"));
        pm.setDepartment(req.getParameter("department"));
        pm.setContactNumber(req.getParameter("contactNumber"));
        pm.setEmail(req.getParameter("email"));
        pm.setPassword(req.getParameter("password"));
        return pm;
    }

    private BookingManager createBookingManager(HttpServletRequest req) {
        BookingManager bm = new BookingManager();
        bm.setName(req.getParameter("name"));
        bm.setJobTitle(req.getParameter("jobTitle"));
        bm.setDepartment(req.getParameter("department"));
        bm.setContactNumber(req.getParameter("contactNumber"));
        bm.setEmail(req.getParameter("email"));
        bm.setPassword(req.getParameter("password"));
        return bm;
    }

    private PaymentManager createPaymentManager(HttpServletRequest req) {
        PaymentManager pym = new PaymentManager();
        pym.setName(req.getParameter("name"));
        pym.setJobTitle(req.getParameter("jobTitle"));
        pym.setDepartment(req.getParameter("department"));
        pym.setContactNumber(req.getParameter("contactNumber"));
        pym.setEmail(req.getParameter("email"));
        pym.setPassword(req.getParameter("password"));
        return pym;
    }

    private CustomerSupportOfficer createSupportOfficer(HttpServletRequest req) {
        CustomerSupportOfficer officer = new CustomerSupportOfficer();
        officer.setName(req.getParameter("name"));
        officer.setJobTitle(req.getParameter("jobTitle"));
        officer.setDepartment(req.getParameter("department"));
        officer.setContactNumber(req.getParameter("contactNumber"));
        officer.setEmail(req.getParameter("email"));
        officer.setPassword(req.getParameter("password"));
        return officer;
    }
}