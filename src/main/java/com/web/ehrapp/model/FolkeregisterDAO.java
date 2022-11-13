package com.web.ehrapp.model;

import at.favre.lib.crypto.bcrypt.BCrypt;
import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import java.sql.*;

public class FolkeregisterDAO {
    public DBConnection db;

    public FolkeregisterDAO() throws SQLException {
        db = new DBConnection();
        db.connectToDb();
    }

    public JSONObject getBorgerJson() throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT folkeregister.*, count(c.cpr) as antal_konsultationer from folkeregister left join consults c on folkeregister.cpr = c.cpr group by folkeregister.cpr ");
        ResultSet result = pstmt.executeQuery();

        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();

        while (result.next()) {   // Move the cursor to the next row
            JSONObject record = new JSONObject();
            String cpr = result.getString(1);
            String name = result.getString(2);
            int antalKonsultationer = result.getInt(3);
            record.put("cpr", formatCpr(cpr));
            record.put("name", name);
            record.put("antalKonsultationer", antalKonsultationer);
            array.add(record);
        }
        jsonObject.put("data", array);
        return jsonObject;
    }


    public JSONObject getBorgerJson(String cpr) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT folkeregister.*, count(c.cpr) as antal_konsultationer from folkeregister left join consults c on folkeregister.cpr = c.cpr WHERE folkeregister.cpr = ? group by folkeregister.cpr");
        pstmt.setString(1, cpr);
        ResultSet result = pstmt.executeQuery();

        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();

        while (result.next()) {   // Move the cursor to the next row
            JSONObject record = new JSONObject();
            String name = result.getString(2);
            int antalKonsultationer = result.getInt(3);
            record.put("cpr", formatCpr(cpr));
            record.put("name", name);
            record.put("antalKonsultationer", antalKonsultationer);
            array.add(record);
        }
        jsonObject.put("data", array);
        return jsonObject;
    }


    public int getNumberOfConsultations(String cpr) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("select count(*) from consults WHERE cpr = ?");
        pstmt.setString(1, cpr.replace("-", ""));
        ResultSet result = pstmt.executeQuery();
        int counts = 0;
        try {
            while (result.next()) {
                counts = result.getInt(1);
            }
        }
        catch (Exception e) {

        }
        return counts;
    }
    public Borger getBorger(String cpr) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM folkeregister WHERE cpr = ? LIMIT 1");
        pstmt.setString(1, cpr);
        ResultSet result = pstmt.executeQuery();
        if(result.next()){   // Move the cursor to the next row
            String name = result.getString(2);
            return new Borger(cpr, name,this);
        }
        return null;
    }


    public Borger createBorger(String cpr, String name) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("INSERT INTO folkeregister (cpr, name) VALUES (?, ?);");
        pstmt.setString(1, cpr);
        pstmt.setString(2, name);
        pstmt.execute();
        return new Borger(cpr, name,this);
    }

    public void deleteBorger(Borger borger) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM folkeregister WHERE cpr = ?");
        pstmt.setString(1, borger.getCpr());
        pstmt.execute();
    }

    public void deleteBorger(String cpr) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM folkeregister WHERE cpr = ?");
        pstmt.setString(1, cpr);
        pstmt.execute();
    }

    public void updateBorger(Borger borger) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("UPDATE folkeregister SET name = ?, cpr = ? WHERE cpr = ?");
        pstmt.setString(1, borger.getName());
        pstmt.setString(2, borger.getCpr());
        pstmt.setString(3, borger.getCpr()); // Den originale cpr nummer -> skal være det samme medmindre de andre foreign tabller bliver opdateret.
        pstmt.execute();
    }

    public String formatCpr(String inputCpr) {
        return inputCpr.substring(0, 6) + "-" + inputCpr.substring(6, 10);
    }

}
