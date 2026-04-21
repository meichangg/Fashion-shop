package com.myshop.util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DB {

    private final String url = "jdbc:sqlserver://localhost:1433;databaseName=fashionshop4;encrypt=false;trustServerCertificate=true;";
    private final String user = "webuser";
    private final String password = "123456";

    public Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(url, user, password);
    }
}
