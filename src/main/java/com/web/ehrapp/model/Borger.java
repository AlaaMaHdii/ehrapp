package com.web.ehrapp.model;

public class Borger {

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
}
