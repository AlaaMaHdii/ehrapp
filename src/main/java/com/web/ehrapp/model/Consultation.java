package com.web.ehrapp.model;

import java.sql.SQLException;
import java.sql.Timestamp;

public class Consultation {

    private int id;
    private String cpr;
    private java.sql.Timestamp startDate;
    private int duration;
    private User createdBy;
    private int status;

    public String getNote() {
        return note;
    }

    public void setNote(String note) throws SQLException {
        this.note = note;
    }

    private String note;
    private ConsultationDAO dao;

    public int getId() {
        return id;
    }


    public String getCpr() {
        return cpr;
    }

    public void setCpr(String cpr) throws SQLException {
        this.cpr = cpr;
    }

    public Timestamp getStartDate() {
        return startDate;
    }

    public void setStartDate(Timestamp startDate) throws SQLException {
        this.startDate = startDate;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) throws SQLException {
        this.duration = duration;
    }

    public User getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(User createdBy) throws SQLException {
        this.createdBy = createdBy;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) throws SQLException {
        this.status = status;
    }

    public void updateData() throws SQLException {
        dao.updateConsultation(this);
    }

    public Consultation(int id, String cpr, Timestamp startDate, int duration, User createdBy, String note, int status, ConsultationDAO dao) {
        this.id = id;
        this.cpr = cpr;
        this.startDate = startDate;
        this.duration = duration;
        this.createdBy = createdBy;
        this.status = status;
        this.note = note;
        this.dao = dao;
    }
}
