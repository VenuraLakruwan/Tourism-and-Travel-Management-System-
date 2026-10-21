package com.travel.controller.managers;

import com.travel.model.PaymentManager;
import com.travel.model.Payment;
import com.travel.service.PaymentService;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class PaymentManagerServlet extends HttpServlet {
    private PaymentService paymentService;

    @Override
    public void init() {
        paymentService = new PaymentService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"paymentManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        PaymentManager manager = (PaymentManager) session.getAttribute("user");
        request.setAttribute("manager", manager);

        // Get filter parameter, default to "Pending" if not specified
        String statusFilter = request.getParameter("status");
        if (statusFilter == null || statusFilter.isEmpty()) {
            statusFilter = "Pending";
        }

        List<Payment> payments;
        if ("All".equalsIgnoreCase(statusFilter)) {
            payments = paymentService.getAllPayments();
        } else {
            payments = paymentService.getPaymentsByStatus(statusFilter);
        }

        request.setAttribute("payments", payments);
        request.setAttribute("statusFilter", statusFilter);

        request.getRequestDispatcher("/views/payment-manager/payments/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"paymentManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = request.getParameter("action");
        int paymentId = Integer.parseInt(request.getParameter("paymentId"));
        boolean success = false;

        if ("approve".equals(action)) {
            success = paymentService.updatePaymentStatus(paymentId, "Approved");

            // If payment is approved, also update the booking status to "Confirmed"
            if (success) {
                Payment payment = paymentService.getPaymentById(paymentId);
                if (payment != null) {
                    paymentService.updateBookingStatus(payment.getBookingId(), "Confirmed");
                }
            }
        } else if ("reject".equals(action)) {
            success = paymentService.updatePaymentStatus(paymentId, "Rejected");

            // If payment is rejected, update booking status to "Cancelled"
            if (success) {
                Payment payment = paymentService.getPaymentById(paymentId);
                if (payment != null) {
                    paymentService.updateBookingStatus(payment.getBookingId(), "Cancelled");
                }
            }
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/tour-payment-manager-payments?success=Payment status updated successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/tour-payment-manager-payments?error=Failed to update payment status");
        }
    }
}