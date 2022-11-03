package com.web.ehrapp.model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

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
    public void connectToDb() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        }
        conn = DriverManager.getConnection(
                    "jdbc:mysql://130.225.170.165:3306/" + schema, "alaa", "SOLsol99");
    }

    public void closeConnection() throws SQLException {
        if(conn != null){
            conn.close();
        }
    }

}
