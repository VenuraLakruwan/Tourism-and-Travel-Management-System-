// File: src/main/java/com/travel/service/SystemAdminService.java
package com.travel.service;

import com.travel.dao.*;
import com.travel.model.*;
import java.util.List;

public class SystemAdminService {
    private SystemAdminDAO systemAdminDAO;
    private CustomerDAO customerDAO;
    private PackageManagerDAO packageManagerDAO;
    private BookingManagerDAO bookingManagerDAO;
    private PaymentManagerDAO paymentManagerDAO;
    private CustomerSupportOfficerDAO customerSupportOfficerDAO;

    public SystemAdminService() {
        systemAdminDAO = new SystemAdminDAO();
        customerDAO = new CustomerDAO();
        packageManagerDAO = new PackageManagerDAO();
        bookingManagerDAO = new BookingManagerDAO();
        paymentManagerDAO = new PaymentManagerDAO();
        customerSupportOfficerDAO = new CustomerSupportOfficerDAO();
    }

    // System Admin methods
    public SystemAdmin authenticateSystemAdmin(String email, String password) {
        return systemAdminDAO.validateSystemAdmin(email, password);
    }

    public SystemAdmin getSystemAdminById(int employeeId) {
        return systemAdminDAO.getSystemAdminById(employeeId);
    }

    public SystemAdmin getSystemAdminByEmail(String email) {
        return systemAdminDAO.getSystemAdminByEmail(email);
    }

    public List<SystemAdmin> getAllSystemAdmins() {
        return systemAdminDAO.getAllSystemAdmins();
    }

    // Customer methods
    public Customer getCustomerByEmail(String email) {
        return customerDAO.getCustomerByEmail(email);
    }

    public List<Customer> getAllCustomers() {
        return customerDAO.getAllCustomers();
    }

    public boolean deleteCustomer(int customerId) {
        return customerDAO.deleteCustomer(customerId);
    }

    // Package Manager methods
    public PackageManager getPackageManagerByEmail(String email) {
        return packageManagerDAO.getPackageManagerByEmail(email);
    }

    public boolean addPackageManager(PackageManager manager) {
        PackageManager existingManager = packageManagerDAO.getPackageManagerByEmail(manager.getEmail());
        if (existingManager != null) {
            return false;
        }
        return packageManagerDAO.addPackageManager(manager);
    }

    public boolean deletePackageManager(int employeeId) {
        return packageManagerDAO.deletePackageManager(employeeId);
    }

    public List<PackageManager> getAllPackageManagers() {
        return packageManagerDAO.getAllPackageManagers();
    }

    public PackageManager getPackageManagerById(int employeeId) {
        return packageManagerDAO.getPackageManagerById(employeeId);
    }

    public boolean updatePackageManager(PackageManager manager) {
        return packageManagerDAO.updatePackageManager(manager);
    }

    // Booking Manager methods
    public BookingManager getBookingManagerByEmail(String email) {
        return bookingManagerDAO.getBookingManagerByEmail(email);
    }

    public boolean addBookingManager(BookingManager manager) {
        BookingManager existingManager = bookingManagerDAO.getBookingManagerByEmail(manager.getEmail());
        if (existingManager != null) {
            return false;
        }
        return bookingManagerDAO.addBookingManager(manager);
    }

    public boolean deleteBookingManager(int employeeId) {
        return bookingManagerDAO.deleteBookingManager(employeeId);
    }

    public List<BookingManager> getAllBookingManagers() {
        return bookingManagerDAO.getAllBookingManagers();
    }

    public BookingManager getBookingManagerById(int employeeId) {
        return bookingManagerDAO.getBookingManagerById(employeeId);
    }

    public boolean updateBookingManager(BookingManager manager) {
        return bookingManagerDAO.updateBookingManager(manager);
    }

    // Payment Manager methods
    public PaymentManager getPaymentManagerByEmail(String email) {
        return paymentManagerDAO.getPaymentManagerByEmail(email);
    }

    public boolean addPaymentManager(PaymentManager manager) {
        PaymentManager existingManager = paymentManagerDAO.getPaymentManagerByEmail(manager.getEmail());
        if (existingManager != null) {
            return false;
        }
        return paymentManagerDAO.addPaymentManager(manager);
    }

    public boolean deletePaymentManager(int employeeId) {
        return paymentManagerDAO.deletePaymentManager(employeeId);
    }

    public List<PaymentManager> getAllPaymentManagers() {
        return paymentManagerDAO.getAllPaymentManagers();
    }

    public PaymentManager getPaymentManagerById(int employeeId) {
        return paymentManagerDAO.getPaymentManagerById(employeeId);
    }

    public boolean updatePaymentManager(PaymentManager manager) {
        return paymentManagerDAO.updatePaymentManager(manager);
    }

    // Customer Support Officer methods
    public CustomerSupportOfficer getCustomerSupportOfficerByEmail(String email) {
        return customerSupportOfficerDAO.getCustomerSupportOfficerByEmail(email);
    }

    public boolean addCustomerSupportOfficer(CustomerSupportOfficer officer) {
        CustomerSupportOfficer existingOfficer = customerSupportOfficerDAO.getCustomerSupportOfficerByEmail(officer.getEmail());
        if (existingOfficer != null) {
            return false;
        }
        return customerSupportOfficerDAO.addCustomerSupportOfficer(officer);
    }

    public boolean deleteCustomerSupportOfficer(int employeeId) {
        return customerSupportOfficerDAO.deleteCustomerSupportOfficer(employeeId);
    }

    public List<CustomerSupportOfficer> getAllCustomerSupportOfficers() {
        return customerSupportOfficerDAO.getAllCustomerSupportOfficers();
    }

    public CustomerSupportOfficer getCustomerSupportOfficerById(int employeeId) {
        return customerSupportOfficerDAO.getCustomerSupportOfficerById(employeeId);
    }

    public boolean updateCustomerSupportOfficer(CustomerSupportOfficer officer) {
        return customerSupportOfficerDAO.updateCustomerSupportOfficer(officer);
    }
}