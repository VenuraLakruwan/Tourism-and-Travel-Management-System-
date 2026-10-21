package com.travel.controller.customer;

import com.travel.dao.BookingDAO;
import com.travel.dao.PaymentDAO;
import com.travel.model.Booking;
import com.travel.model.Payment;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String pathInfo = request.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/history";
        }

        switch (pathInfo) {
            case "/history":
                viewPaymentHistory(request, response);
                break;
            case "/make":
                showMakePaymentForm(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"customer".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String pathInfo = request.getPathInfo();

        switch (pathInfo) {
            case "/make":
                makePayment(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void viewPaymentHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        List<Payment> payments = paymentDAO.getPaymentsByCustomerId(customerId);
        request.setAttribute("payments", payments);

        request.getRequestDispatcher("/views/customer/payments/history.jsp").forward(request, response);
    }

    private void showMakePaymentForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        String bookingIdParam = request.getParameter("bookingId");
        Booking booking = null;

        if (bookingIdParam != null) {
            try {
                int bookingId = Integer.parseInt(bookingIdParam);
                booking = bookingDAO.getBookingById(bookingId);
            } catch (NumberFormatException e) {
                // Invalid booking ID format
            }
        }

        // If no specific booking requested, get the latest booking for this customer
        if (booking == null) {
            List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
            if (!bookings.isEmpty()) {
                booking = bookings.get(0); // Get the most recent booking
            }
        }

        if (booking == null) {
            request.setAttribute("errorMessage", "No booking found. Please make a booking first.");
        } else {
            request.setAttribute("booking", booking);
        }

        request.getRequestDispatcher("/views/customer/payments/make.jsp").forward(request, response);
    }

    private void makePayment(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        com.travel.model.Customer customer = (com.travel.model.Customer) session.getAttribute("user");
        int customerId = customer.getCustomerId();

        // Get booking information
        String bookingIdParam = request.getParameter("bookingId");
        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Booking ID is required");
            showMakePaymentForm(request, response);
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid booking ID format");
            showMakePaymentForm(request, response);
            return;
        }

        Booking booking = bookingDAO.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("errorMessage", "Booking not found");
            showMakePaymentForm(request, response);
            return;
        }

        // Verify this booking belongs to the current customer
        if (booking.getCustomerId() != customerId) {
            request.setAttribute("errorMessage", "This booking does not belong to you");
            showMakePaymentForm(request, response);
            return;
        }

        // Get payment method
        String method = request.getParameter("method");
        if (method == null || method.isEmpty()) {
            request.setAttribute("errorMessage", "Payment method is required");
            request.setAttribute("booking", booking);
            showMakePaymentForm(request, response);
            return;
        }

        // Get card details
        String cardNumber = request.getParameter("cardNumber");
        String expiryDate = request.getParameter("expiryDate");
        String cvv = request.getParameter("cvv");

        if (cardNumber == null || cardNumber.isEmpty() ||
                expiryDate == null || expiryDate.isEmpty() ||
                cvv == null || cvv.isEmpty()) {
            request.setAttribute("errorMessage", "All card details are required");
            request.setAttribute("booking", booking);
            showMakePaymentForm(request, response);
            return;
        }

        try {
            // Create payment object
            Payment payment = new Payment();
            payment.setPaymentId((int) (System.currentTimeMillis() % 1000000));
            payment.setPaymentDate(new Date());
            payment.setAmount(booking.getTotalPrice() > 0 ? booking.getTotalPrice() : 0);
            payment.setMethod(method);
            payment.setStatus("Pending"); // Set initial status as Pending
            payment.setCustomerId(customerId);
            payment.setBookingId(bookingId);
            payment.setPackageId(booking.getPackageId());
            payment.setCardNumber(cardNumber);
            payment.setExpiryDate(expiryDate);
            payment.setCvv(cvv);

            // Add payment to database
            boolean success = paymentDAO.addPayment(payment);

            if (success) {
                request.setAttribute("successMessage",
                        "Payment submitted successfully. Your payment ID is: " + payment.getPaymentId() +
                                ". It is currently pending approval by our payment manager.");
            } else {
                request.setAttribute("errorMessage", "Failed to process payment");
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Error processing payment: " + e.getMessage());
        }

        // Forward back to the payment form with booking details
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/views/customer/payments/make.jsp").forward(request, response);
    }
}