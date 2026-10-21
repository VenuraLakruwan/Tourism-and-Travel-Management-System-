package com.travel.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {

    // Database URL, username and password
    private static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=JourneyX;encrypt=false;";
    private static final String USER = "sa";
    private static final String PASSWORD = "123";

    public static Connection getConnection() {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            // Ensure auto-commit is enabled
            conn.setAutoCommit(true);
            System.out.println("Database connected successfully: " + conn);
            return conn;
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("SQLServer JDBC Driver not found. Put the JAR in Tomcat/lib.", e);
        } catch (SQLException e) {
            throw new RuntimeException("Failed to connect to database. Check URL/username/password.", e);
        }
    }
}