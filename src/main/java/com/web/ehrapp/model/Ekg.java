package com.web.ehrapp.model;
import java.sql.*;
import java.util.ArrayList;

public class Ekg {
    ArrayList<Float> millivolt;
    ArrayList<Float> time;

    public Ekg(ArrayList<Float> millivolt, ArrayList<Float> time) {
        this.millivolt = millivolt;
        this.time = time;
    }


    public ArrayList<Float> getMillivolt() {
        return millivolt;
    }

    public void setMillivolt(ArrayList<Float> millivolt) {
        this.millivolt = millivolt;
    }

    public ArrayList<Float> getTime() {
        return time;
    }

    public void setTime(ArrayList<Float> time) {
        this.time = time;
    }
}
