package com.travel.controller.managers;

import com.travel.model.BookingManager;
import com.travel.model.Booking;
import com.travel.service.BookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/booking-manager/*")
public class BookingManagerServlet extends HttpServlet {
    private BookingService bookingService;

    @Override
    public void init() {
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"bookingManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        BookingManager manager = (BookingManager) session.getAttribute("user");
        request.setAttribute("manager", manager);

        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/dashboard";
        }

        // Handle action parameter
        String action = request.getParameter("action");
        List<Booking> bookings;
        String statusFilter = "All";

        if (action != null) {
            switch (action) {
                case "view-pending":
                    bookings = bookingService.getBookingsByStatus("Pending");
                    statusFilter = "Pending";
                    break;
                case "view-confirmed":
                    bookings = bookingService.getBookingsByStatus("Confirmed");
                    statusFilter = "Confirmed";
                    break;
                case "view-cancelled":
                    bookings = bookingService.getBookingsByStatus("Cancelled");
                    statusFilter = "Cancelled";
                    break;
                case "list":
                default:
                    bookings = bookingService.getAllBookings();
                    break;
            }
        } else {
            // If no action parameter, get all bookings
            bookings = bookingService.getAllBookings();
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("statusFilter", statusFilter);

        switch (pathInfo) {
            case "/dashboard":
                // For dashboard, get recent bookings and statistics
                List<Booking> recentBookings = bookingService.getAllBookings();
                request.setAttribute("recentBookings", recentBookings);
                request.getRequestDispatcher("/views/booking-manager/dashboard.jsp").forward(request, response);
                break;
            case "/list":
            default:
                request.getRequestDispatcher("/views/booking-manager/bookings/list.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"bookingManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = request.getParameter("action");
        String bookingIdParam = request.getParameter("id");

        if (bookingIdParam == null || bookingIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/booking-manager/list?error=Booking ID is required");
            return;
        }

        int bookingId;
        try {
            bookingId = Integer.parseInt(bookingIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/booking-manager/list?error=Invalid booking ID");
            return;
        }

        boolean success = false;
        String message = "";

        if ("confirm".equals(action)) {
            success = bookingService.updateBookingStatus(bookingId, "Confirmed");
            message = success ? "Booking confirmed successfully" : "Failed to confirm booking";
        } else if ("cancel".equals(action)) {
            success = bookingService.updateBookingStatus(bookingId, "Cancelled");
            message = success ? "Booking cancelled successfully" : "Failed to cancel booking";
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/booking-manager/list?success=" + message);
        } else {
            response.sendRedirect(request.getContextPath() + "/booking-manager/list?error=" + message);
        }
    }
}