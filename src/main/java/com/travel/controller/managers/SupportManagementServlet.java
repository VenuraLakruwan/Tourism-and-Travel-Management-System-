// File: src/main/java/com/travel/controller/support/SupportManagementServlet.java
package com.travel.controller.managers;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.travel.model.CustomerSupportOfficer;
import com.travel.model.Feedback;
import com.travel.model.ReportIssue;
import com.travel.service.FeedbackService;
import com.travel.service.ReportIssueService;

public class SupportManagementServlet extends HttpServlet {
    private FeedbackService feedbackService;
    private ReportIssueService reportIssueService;

    @Override
    public void init() {
        feedbackService = new FeedbackService();
        reportIssueService = new ReportIssueService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"supportOfficer".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "feedback-list";

        switch (action) {
            case "feedback-list":
                viewAllFeedback(request, response);
                break;
            case "issue-list":
                viewAllIssues(request, response);
                break;
            case "reply-issue":
                showReplyForm(request, response);
                break;
            case "update-status":
                showUpdateStatusForm(request, response);
                break;
            default:
                viewAllFeedback(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null ||
                !"supportOfficer".equals(session.getAttribute("userType"))) {
            response.sendRedirect(request.getContextPath() + "/tour-login");
            return;
        }

        String action = request.getParameter("action");

        switch (action) {
            case "delete-feedback":
                deleteFeedback(request, response);
                break;
            case "reply-issue":
                replyToIssue(request, response);
                break;
            case "update-status":
                updateIssueStatus(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel");
        }
    }

    private void viewAllFeedback(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Feedback> feedbacks = feedbackService.getAllFeedbacks();
        request.setAttribute("feedbacks", feedbacks);
        request.getRequestDispatcher("/views/support-manager/support/feedback-list.jsp").forward(request, response);
    }

    private void viewAllIssues(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<ReportIssue> issues = reportIssueService.getAllReportIssues();
        request.setAttribute("issues", issues);
        request.getRequestDispatcher("/views/support-manager/support/issue-list.jsp").forward(request, response);
    }

    private void showReplyForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String issueIdParam = request.getParameter("id");
        if (issueIdParam != null) {
            int issueId = Integer.parseInt(issueIdParam);
            ReportIssue issue = reportIssueService.getReportIssueById(issueId);
            request.setAttribute("issue", issue);
        }
        request.getRequestDispatcher("/views/support-manager/support/reply-issue.jsp").forward(request, response);
    }

    private void showUpdateStatusForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String issueIdParam = request.getParameter("id");
        if (issueIdParam != null) {
            int issueId = Integer.parseInt(issueIdParam);
            ReportIssue issue = reportIssueService.getReportIssueById(issueId);
            request.setAttribute("issue", issue);
        }
        request.getRequestDispatcher("/views/support-manager/support/update-status.jsp").forward(request, response);
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int feedbackId = Integer.parseInt(request.getParameter("id"));
            boolean success = feedbackService.deleteFeedback(feedbackId);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=feedback-list&success=Feedback deleted successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=feedback-list&error=Failed to delete feedback");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=feedback-list&error=Invalid feedback ID");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=feedback-list&error=An error occurred while deleting feedback");
        }
    }

    private void replyToIssue(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int issueId = Integer.parseInt(request.getParameter("issueId"));
        String reply = request.getParameter("reply");

        response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=issues-list&success=Reply sent successfully");
    }

    private void updateIssueStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int issueId = Integer.parseInt(request.getParameter("issueId"));
        String status = request.getParameter("status");

        ReportIssue issue = reportIssueService.getReportIssueById(issueId);
        if (issue != null) {
            String updatedDetails = issue.getIssueDetails() + "\n\nStatus: " + status;
            issue.setIssueDetails(updatedDetails);
            boolean success = reportIssueService.updateReportIssue(issue);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=issues-list&success=Status updated successfully");
            } else {
                response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=issues-list&error=Failed to update status");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/tour-support-officer-panel?action=issues-list&error=Issue not found");
        }
    }
}