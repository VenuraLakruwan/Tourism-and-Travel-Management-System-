package com.travel.controller.customer;

import com.travel.dao.BookingDAO;
import com.travel.dao.PackageDAO;
import com.travel.dao.PaymentDAO;
import com.travel.model.Booking;
import com.travel.model.Package;
import java.io.IOException;
import java.util.Date;
import java.util.List;
import com.travel.model.Payment;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO;
    private PackageDAO packageDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingDAO = new BookingDAO();
        packageDAO = new PackageDAO();
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
        System.out.println("BookingServlet doGet - PathInfo: " + pathInfo); // Debug line

        if (pathInfo == null || pathInfo.equals("/")) {
            pathInfo = "/list";
        }

        switch (pathInfo) {
            case "/create":
                System.out.println("Showing create booking form"); // Debug line
                showCreateBookingForm(request, response);
                break;
            case "/history":
                viewBookingHistory(request, response);
                break;
            case "/status":
                viewBookingStatus(request, response);
                break;
            case "/cancel":
                showCancelBookingForm(request, response);
                break;
            default:
                System.out.println("Unknown path: " + pathInfo); // Debug line
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
        System.out.println("BookingServlet doPost - PathInfo: " + pathInfo); // Debug line

        switch (pathInfo) {
            case "/create":
                System.out.println("Creating booking"); // Debug line
                createBooking(request, response);
                break;
            case "/cancel":
                cancelBooking(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showCreateBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String packageIdParam = request.getParameter("packageId");
        System.out.println("Package ID param: " + packageIdParam); // Debug line

        if (packageIdParam != null && !packageIdParam.isEmpty()) {
            try {
                int packageId = Integer.parseInt(packageIdParam);
                Package tourPackage = packageDAO.getPackageById(packageId);
                if (tourPackage != null) {
                    request.setAttribute("package", tourPackage);
                    System.out.println("Package found: " + tourPackage.getPackageName()); // Debug line
                } else {
                    request.setAttribute("errorMessage", "Package not found");
                    System.out.println("Package not found for ID: " + packageId); // Debug line
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid package ID");
                System.out.println("Invalid package ID format: " + packageIdParam); // Debug line
            }
        } else {
            request.setAttribute("errorMessage", "Package ID is required");
            System.out.println("Package ID is missing"); // Debug line
        }

        System.out.println("Forwarding to create.jsp"); // Debug line
        request.getRequestDispatcher("/views/customer/bookings/create.jsp").forward(request, response);
    }

    private void createBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        String packageIdParam = request.getParameter("packageId");
        System.out.println("Creating booking for package ID: " + packageIdParam); // Debug line

        if (packageIdParam == null || packageIdParam.isEmpty()) {
            request.setAttribute("errorMessage", "Package ID is required");
            showCreateBookingForm(request, response);
            return;
        }

        try {
            int packageId = Integer.parseInt(packageIdParam);
            Package tourPackage = packageDAO.getPackageById(packageId);

            if (tourPackage == null) {
                request.setAttribute("errorMessage", "Package not found");
                showCreateBookingForm(request, response);
                return;
            }

            // Get booking details from form
            String bookingDateStr = request.getParameter("bookingDate");
            String numTravelersStr = request.getParameter("numTravelers");

            if (bookingDateStr == null || bookingDateStr.isEmpty() ||
                    numTravelersStr == null || numTravelersStr.isEmpty()) {
                request.setAttribute("errorMessage", "All booking details are required");
                request.setAttribute("package", tourPackage);
                showCreateBookingForm(request, response);
                return;
            }

            // Parse number of travelers
            int numTravelers;
            try {
                numTravelers = Integer.parseInt(numTravelersStr);
                if (numTravelers <= 0) {
                    request.setAttribute("errorMessage", "Number of travelers must be greater than 0");
                    request.setAttribute("package", tourPackage);
                    showCreateBookingForm(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Invalid number of travelers");
                request.setAttribute("package", tourPackage);
                showCreateBookingForm(request, response);
                return;
            }

            // Calculate total price
            double totalPrice = tourPackage.getPrice() * numTravelers;

            // Create booking object
            Booking booking = new Booking();
            booking.setBookingDate(new Date()); // Using current date as booking date
            booking.setConfirmationStatus("Pending");
            booking.setCustomerId(customerId);
            booking.setPackageId(packageId);
            booking.setNumTravelers(numTravelers);
            booking.setTotalPrice(totalPrice);

            // Add booking to database
            boolean success = bookingDAO.addBooking(booking);
            System.out.println("Booking creation result: " + success); // Debug line

            if (success) {
                int bookingId = booking.getBookingId();
                System.out.println("Booking created with ID: " + bookingId); // Debug line

                // Set attributes for confirmation page
                request.setAttribute("booking", booking);
                request.setAttribute("bookingId", bookingId);
                request.setAttribute("successMessage", "Booking created successfully. Your booking ID is: " + bookingId);

                // Forward to confirmation page
                request.getRequestDispatcher("/views/customer/bookings/confirmation.jsp").forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Failed to create booking");
                request.setAttribute("package", tourPackage);
                showCreateBookingForm(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid package ID format");
            showCreateBookingForm(request, response);
        }
    }

    private void viewBookingHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);

        // Create a map to store payment status for each booking
        java.util.Map<Integer, String> paymentStatusMap = new java.util.HashMap<>();
        PaymentDAO paymentDAO = new PaymentDAO();

        if (bookings != null) {
            for (Booking booking : bookings) {
                Payment payment = paymentDAO.getPaymentByBookingId(booking.getBookingId());
                if (payment != null) {
                    paymentStatusMap.put(booking.getBookingId(), payment.getStatus());
                } else {
                    paymentStatusMap.put(booking.getBookingId(), "No Payment");
                }
            }
        }

        request.setAttribute("bookings", bookings);
        request.setAttribute("paymentStatusMap", paymentStatusMap);

        request.getRequestDispatcher("/views/customer/bookings/history.jsp").forward(request, response);
    }

    private void viewBookingStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
        request.setAttribute("bookings", bookings);

        request.getRequestDispatcher("/views/customer/bookings/status.jsp").forward(request, response);
    }

    private void showCancelBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        int customerId = ((com.travel.model.Customer) session.getAttribute("user")).getCustomerId();

        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
        request.setAttribute("bookings", bookings);

        request.getRequestDispatcher("/views/customer/bookings/cancel.jsp").forward(request, response);
    }

    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        boolean success = bookingDAO.updateBookingStatus(bookingId, "Cancelled");

        if (success) {
            request.setAttribute("successMessage", "Booking cancelled successfully");
        } else {
            request.setAttribute("errorMessage", "Failed to cancel booking");
        }

        showCancelBookingForm(request, response);
    }
}