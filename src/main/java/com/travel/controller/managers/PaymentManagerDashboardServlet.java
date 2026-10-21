// File: src/main/java/com/travel/controller/managers/PaymentManagerDashboardServlet.java
package com.travel.controller.managers;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.travel.model.PaymentManager;

public class PaymentManagerDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // In PaymentManagerDashboardServlet.java
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"paymentManager".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        PaymentManager manager = (PaymentManager) session.getAttribute("user");
        request.setAttribute("manager", manager);

        // Forward to dashboard page
        request.getRequestDispatcher("/views/payment-manager/dashboard.jsp").forward(request, response);
    }

}