package com.web.ehrapp.model;

import org.jooq.RecordMapper;
import org.jooq.impl.DSL;
import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import java.sql.*;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.List;

public class ConsultationDAO {
    public DBConnection db;
    public User user;

    public ConsultationDAO(User user) throws SQLException {
        this.db = user.getDao().db;
        this.user = user; // så vi ved hvem har oprettet hvilke konsultationer
    }

    public ArrayList<Consultation> getConsultations() throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM consults INNER JOIN folkeregister f on consults.cpr = f.cpr INNER JOIN users u on consults.createdBy = u.id");

        ResultSet result = pstmt.executeQuery();
        ArrayList<Consultation> consults = new ArrayList<Consultation>();
        while (result.next()) {   // Move the cursor to the next row
            int id = result.getInt(1);
            String cpr = result.getString(2);
            Timestamp startDate = result.getTimestamp(3);
            int duration = result.getInt(4);
            String note = result.getString(6);
            int status = result.getInt(7);
            //String patientName = result.getString(9);
            User createdBy = new User(result.getInt(10), result.getString(11), result.getString(12), result.getString(13), result.getString(14), user.getDao());

            consults.add(new Consultation(id, cpr, startDate, duration, createdBy, note, status, this));
        }
        return consults;
    }

    public Consultation getConsultation(int id) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM consults INNER JOIN folkeregister f on consults.cpr = f.cpr INNER JOIN users u on consults.createdBy = u.id WHERE consults.id = ?");
        pstmt.setInt(1, id);
        ResultSet result = pstmt.executeQuery();

        if (result.next()) {   // Move the cursor to the next row
            String cpr = result.getString(2);
            Timestamp startDate = result.getTimestamp(3);
            int duration = result.getInt(4);
            String note = result.getString(6);
            int status = result.getInt(7);
            //String patientName = result.getString(9);
            User createdBy = new User(result.getInt(10), result.getString(11), result.getString(12), result.getString(13), result.getString(14), user.getDao());

            return new Consultation(id, cpr, startDate, duration, createdBy, note, status, this);
        }
        return null;
    }

    public boolean patientExists(String cpr) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM folkeregister WHERE cpr = ?");
        pstmt.setString(1, cpr);
        ResultSet result = pstmt.executeQuery();
        return result.next();
    }

    public JSONObject getConsultationsJSON() throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM consults INNER JOIN folkeregister f on consults.cpr = f.cpr INNER JOIN users u on consults.createdBy = u.id");
        ResultSet result = pstmt.executeQuery();

        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();

        while (result.next()) {   // Move the cursor to the next row
            JSONObject record = new JSONObject();
            int id = result.getInt(1);
            String cpr = result.getString(2);
            Timestamp startDate = result.getTimestamp(3);
            int duration = result.getInt(4);
            String note = result.getString(6);
            int status = result.getInt(7);
            String patientName = result.getString(9);
            User createdBy = new User(result.getInt(10), result.getString(11), result.getString(12), result.getString(13), result.getString(14), user.getDao());

            record.put("id", id);
            record.put("patientName", patientName);
            record.put("cpr", formatCpr(cpr));
            record.put("startDate", startDate);
            record.put("duration", duration);
            record.put("createdBy", createdBy.getName());
            record.put("note", note);
            record.put("status", status);
            array.add(record);
        }
        jsonObject.put("data", array);
        return jsonObject;
    }
    public JSONObject getConsultationJSON(int id) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("SELECT * FROM consults INNER JOIN folkeregister f on consults.cpr = f.cpr INNER JOIN users u on consults.createdBy = u.id WHERE consults.id = ?");
        pstmt.setInt(1, id);
        ResultSet result = pstmt.executeQuery();

        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();

        while (result.next()) {   // Move the cursor to the next row
            JSONObject record = new JSONObject();
            String cpr = result.getString(2);
            Timestamp startDate = result.getTimestamp(3);
            int duration = result.getInt(4);
            String note = result.getString(6);
            int status = result.getInt(7);
            String patientName = result.getString(9);
            User createdBy = new User(result.getInt(10), result.getString(11), result.getString(12), result.getString(13), result.getString(14), user.getDao());

            record.put("id", id);
            record.put("patientName", patientName);
            record.put("cpr", formatCpr(cpr));
            record.put("startDate", startDate);
            record.put("duration", duration);
            record.put("createdBy", createdBy.getName());
            record.put("note", note);
            record.put("status", status);
            array.add(record);
        }
        jsonObject.put("data", array);
        return jsonObject;
    }

    public String formatCpr(String inputCpr) {
        return inputCpr.substring(0, 6) + "-" + inputCpr.substring(6, 10);
    }

    public void updateConsultation(Consultation consultation) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("UPDATE consults SET cpr = ?, startDate = ?, duration = ?, status = ?, note = ?, createdBy = ? WHERE id = ?");
        pstmt.setString(1, consultation.getCpr());
        pstmt.setTimestamp(2, consultation.getStartDate());
        pstmt.setInt(3, consultation.getDuration());
        pstmt.setInt(4, consultation.getStatus());
        pstmt.setString(5, consultation.getNote());
        pstmt.setInt(6, consultation.getCreatedBy().getId());
        pstmt.setInt(7, consultation.getId());
        pstmt.execute();
    }

    public void deleteConsultation(Consultation consultation) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM consults WHERE id = ?");
        pstmt.setInt(1, consultation.getId());
        pstmt.execute();
    }
    public void deleteConsultation(int id) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("DELETE FROM consults WHERE id = ?");
        pstmt.setInt(1, id);
        pstmt.execute();
    }

    public Consultation createConsultation(String cpr, Timestamp startDate, int duration, String note, int status) throws SQLException {
        PreparedStatement pstmt = db.conn.prepareStatement("INSERT INTO consults (cpr, startdate, duration, createdBy, status, note) VALUES (?, ?, ?, ?, ?, ?);", Statement.RETURN_GENERATED_KEYS);
        int createdBy = user.getId();
        pstmt.setString(1, cpr);
        pstmt.setTimestamp(2, startDate);
        pstmt.setInt(3, duration);
        pstmt.setInt(4, createdBy);
        pstmt.setInt(5, status);
        pstmt.setString(6, note);
        pstmt.execute();
        ResultSet generatedKeys = pstmt.getGeneratedKeys();
        generatedKeys.next();
        int id = generatedKeys.getInt(1);
        return new Consultation(id, cpr, startDate, duration, user, note, status, this);
    }

}