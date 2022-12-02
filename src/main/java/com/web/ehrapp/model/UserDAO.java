package com.web.ehrapp.model;

import at.favre.lib.crypto.bcrypt.BCrypt;
import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

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
            String phoneNumber = result.getString(6);
            boolean disabled = result.getBoolean(7);
            return new User(id, name, role, email, password, phoneNumber, disabled, this);
        }
        return null;
    }

    public User getUser(String email) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM users WHERE email = ? LIMIT 1");
        pstmt.setString(1, email);
        ResultSet result = pstmt.executeQuery();
        if(result.next()){   // Move the cursor to the next row
            int id = result.getInt(1);
            String name = result.getString(2);
            String role = result.getString(3);
            String password = result.getString(5);
            String phoneNumber = result.getString(6);
            boolean disabled = result.getBoolean(7);
            return new User(id, name, role, email, password, phoneNumber,disabled,this);
        }
        return null;
    }



    public JSONObject getUserJSON(String email) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT users.*, count(c.createdBy) as antal_konsultationer from users left join consults c on users.id = c.createdBy WHERE email = ? LIMIT 1");
        pstmt.setString(1, email);
        ResultSet result = pstmt.executeQuery();
        return parseResultUser(result);
    }

    public JSONObject getUsersJSON() throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT users.*, count(c.createdBy) as antal_konsultationer from users left join consults c on users.id = c.createdBy group by users.id");
        ResultSet result = pstmt.executeQuery();
        return parseResultUser(result);
    }

    private JSONObject parseResultUser(ResultSet result) throws SQLException {
        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();


        while (result.next()){   // Move the cursor to the next row
            JSONObject record = new JSONObject();
            int id = result.getInt(1);
            String name = result.getString(2);
            String role = result.getString(3);
            String email = result.getString(4);
            String password = result.getString(5);
            String phoneNumber = result.getString(6);
            boolean disabled = result.getBoolean(7);
            int antalKonsultationer = result.getInt(8);
            User user =  new User(id, name, role, email, password, phoneNumber,disabled, this);

            record.put("id", user.getId());
            record.put("name", user.getName());
            record.put("phoneNumber", user.getPhoneNumber());
            record.put("roles", user.getRole());
            record.put("email", user.getEmail());
            record.put("password", randomPasswordBlur(5, 10));
            record.put("isDisabled", disabled);
            record.put("antalKonsultationer", antalKonsultationer);
            array.add(record);
        }
        jsonObject.put("data", array);
        return jsonObject;
    }



    public String randomPasswordBlur(int minLength, int maxLength){
        int randomTal = (int) ((Math.random() * (maxLength - minLength)) + minLength);
        String passwordChar = "●";
        String password = ""; // Det er vigtigt at denne string er initaliseret ellers kan vi ikke append til den.
        for (int i = 0; i < randomTal; i++) {
            password = password + passwordChar;
        }
        return password;
    }

    public User createUser(String name, String role, String email, String password, String phoneNumber, boolean disabled) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("INSERT INTO users (name, role, email, password, phoneNumber, disabled) VALUES (?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS);
        pstmt.setString(1, name);
        pstmt.setString(2, role);
        pstmt.setString(3, email.toLowerCase());
        pstmt.setString(4, encryptPassword(password));
        pstmt.setString(5, phoneNumber);
        pstmt.setBoolean(6, disabled);
        pstmt.execute();
        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        generatedKeys.next();
        int id = generatedKeys.getInt(1);
        return new User(id, name, role, email, password, phoneNumber, disabled,this);
    }

    public void deleteUser(User user) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM users WHERE id = ?");
        pstmt.setInt(1, user.getId());
        pstmt.execute();
    }
    public void deleteUser(int id) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM users WHERE id = ?");
        pstmt.setInt(1, id);
        pstmt.execute();
    }

    public void updateUser(User user) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("UPDATE users SET name = ?, role = ?, email = ?, password = ?, disabled = ? WHERE id = ?");
        pstmt.setString(1, user.getName());
        pstmt.setString(2, user.getRole());
        pstmt.setString(3, user.getEmail().toLowerCase());
        pstmt.setString(4, user.getPassword());
        pstmt.setBoolean(5, user.isDisabled());
        pstmt.setInt(6, user.getId());
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
