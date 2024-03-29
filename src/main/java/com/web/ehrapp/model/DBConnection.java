package com.web.ehrapp.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Objects;
import java.util.TimeZone;

public class DBConnection {
    public Connection conn;

    public String schema = "EHR"; // Database navn

    public String getSchema() throws SQLException {
        if(!conn.isClosed()){
            return conn.getSchema();
        }else{
            return schema;
        }
    }
    public void setSchema(String schema) throws SQLException {
        if(!conn.isClosed()){
            closeConnection();
            this.schema = schema;
            connectToDb();
        }else{
            this.schema = schema;
        }
    }
    public void reconnect() throws SQLException {
        if(!conn.isClosed()){
            connectToDb();
        }
    }

    public void connectToDb() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        TimeZone.setDefault(TimeZone.getTimeZone("Europe/Copenhagen"));

        conn = DriverManager.getConnection(
                    "jdbc:mysql://134.209.252.170:3306/" + schema, "root", "solsol99");
    }

    public void closeConnection() throws SQLException {
        if(!Objects.requireNonNull(conn).isClosed()){
            conn.close();
        }
    }

}
