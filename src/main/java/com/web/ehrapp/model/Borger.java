package com.web.ehrapp.model;

import org.jooq.tools.json.JSONObject;

import javax.security.auth.Subject;
import java.security.Principal;
import java.sql.SQLException;
import java.util.ArrayList;

public class Borger implements Principal {

    private String cpr;
    private String name;
    public FolkeregisterDAO dao;

    public Borger(String cpr, String name, FolkeregisterDAO dao) {
        this.cpr = cpr;
        this.name = name;
        this.dao = dao;
    }

    public String getCpr() {
        return cpr;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public ArrayList<Consultation> getConsultations() throws SQLException {
        ConsultationDAO cDao = new ConsultationDAO(null);
        return cDao.getConsultations(cpr);
    }

    public JSONObject getConsultationsJSON() throws SQLException {
        ConsultationDAO cDao = new ConsultationDAO(null);
        return cDao.getConsultationJSON(cpr);
    }
}
