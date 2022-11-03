package com.web.ehrapp.model;

import at.favre.lib.crypto.bcrypt.BCrypt;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class UserDAO {
    public DBConnection db;

    public UserDAO() throws SQLException {
        db = new DBConnection();
        db.connectToDb();
    }

    public User getUser(int id) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM users WHERE id = ? LIMIT 1");
        pstmt.setInt(1, id);
        ResultSet result = pstmt.executeQuery();
        while(result.next()){   // Move the cursor to the next row
            String name = result.getString(2);
            String role = result.getString(3);
            String email = result.getString(4);
            String password = result.getString(5);
            return new User(id, name, role, email, password, this);
        }
        return null;
    }

    public User getUser(String email) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM users WHERE email = ? LIMIT 1");
        pstmt.setString(1, email);
        ResultSet result = pstmt.executeQuery();
        while(result.next()){   // Move the cursor to the next row
            int id = result.getInt(1);
            String name = result.getString(2);
            String role = result.getString(3);
            String password = result.getString(5);
            return new User(id, name, role, email, password, this);
        }
        return null;
    }

    public User createUser(String name, String role, String email, String password) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("INSERT INTO users (name, role, email, password) VALUES (?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, name);
        pstmt.setString(2, role);
        pstmt.setString(3, email.toLowerCase());
        pstmt.setString(4, encryptPassword(password));
        pstmt.execute();
        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        generatedKeys.next();
        int id = generatedKeys.getInt(1);
        return new User(id, name, role, email, password, this);
    }

    public void deleteUser(User user) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM users WHERE id = ?");
        pstmt.setInt(1, user.getId());
        pstmt.execute();
    }

    public void updateUser(User user) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("UPDATE users SET name = ?, role = ?, email = ?, password = ? WHERE id = ?");
        pstmt.setString(1, user.getName());
        pstmt.setString(2, user.getRole());
        pstmt.setString(3, user.getEmail().toLowerCase());
        pstmt.setString(4, user.getPassword());
        pstmt.setInt(5, user.getId());
        pstmt.execute();
    }

    public String encryptPassword(String password){
        return BCrypt.withDefaults().hashToString(12, password.toCharArray());
    }

    public User login(String email, String password) throws SQLException {
            User user = getUser(email);
            if(user != null && user.checkPassword(password)){
                return user;
            }else{
                // invalid password
                return null;
            }
    }

}
