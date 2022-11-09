package com.web.ehrapp.api;

import com.web.ehrapp.model.Consultation;
import com.web.ehrapp.model.ConsultationDAO;
import com.web.ehrapp.model.User;
import jakarta.annotation.security.RolesAllowed;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Objects;

@Path("consultations")
@AuthenticationRequired
public class Consultations extends Application {

    @Context
    private SecurityContext securityContext;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @RolesAllowed("Læge")
    public String getConsultations(@Context HttpServletRequest req) throws SQLException {
       User user = (User) securityContext.getUserPrincipal();
       ConsultationDAO dao = new ConsultationDAO(user);
       return dao.getConsultationsJSON().toString();
    }

    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String deleteConsultations(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        User user = (User) securityContext.getUserPrincipal();
        String[] ids = getIds(req);
        MultivaluedMap<String, String> formParams = form.asMap();
        ConsultationDAO dao = new ConsultationDAO(user);

        for (String id : ids) {
            dao.deleteConsultation(Integer.parseInt(id));
        }

        return dao.getConsultationsJSON().toString();
    }

    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String addConsultations(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        User user = (User) securityContext.getUserPrincipal();
        MultivaluedMap<String, String> formParams = form.asMap();
        ConsultationDAO dao = new ConsultationDAO(user);
        String action = formParams.getFirst("action");

        // error handling
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();

        // Opret consultation
        if(Objects.equals(action, "create")) {
            String cpr = formParams.getFirst("data[0][cpr]");
            String startDate = formParams.getFirst("data[0][startDate]");
            String duration = formParams.getFirst("data[0][duration]");
            String note = formParams.getFirst("data[0][note]");

            boolean errorOccured = false;

            // Validate


            // CPR
            if(cpr != null) {
                if (!dao.patientExists(cpr.replace("-", ""))) {
                    errors.add("CPR-nummeret findes ikke");
                    fieldNames.add("cpr");
                    errorOccured = true;
                }
            }else{
                errors.add("CPR-nummeret må ikke være tomt");
                fieldNames.add("cpr");
                errorOccured = true;
            }

            // Startdato
            Timestamp timestamp = null;
            if(startDate != null) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    Date parsedDate = dateFormat.parse(startDate);
                    timestamp = new java.sql.Timestamp(parsedDate.getTime());
                } catch (Exception e) { // Hvis startdato ikke passer
                    errors.add("Dato formattet kunne ikke genkendes");
                    fieldNames.add("startDate");
                    errorOccured = true;
                }
            }else{
                errors.add("Dato formattet må ikke være tomt.");
                fieldNames.add("startDate");
                errorOccured = true;
            }

            // Varighed
            if(duration != null) {
                try {
                    Integer.parseInt(duration);
                } catch (Exception E) {
                    errors.add("Varighed skal skrives i tal som sekunder.");
                    fieldNames.add("duration");
                    errorOccured = true;
                }
            }else{
                errors.add("Varighed må ikke være tomt.");
                fieldNames.add("duration");
                errorOccured = true;
            }

            if(errorOccured){
                return addErrors(errors.toArray(new String[0]), fieldNames.toArray(new String[0])).toString();
            }

            Consultation consultation = dao.createConsultation(cpr.replace("-", ""), timestamp, Integer.parseInt(duration), note, 0);
            return dao.getConsultationJSON(consultation.getId()).toString();
        }
        return null;
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String modifyConsultations(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        User user = (User) securityContext.getUserPrincipal();
        String[] ids = getIds(req);
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");
        ConsultationDAO dao = new ConsultationDAO(user);
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();
        boolean errorOccured = false;

        if(Objects.equals(action, "edit")) {
            for (String id : ids) {
                Consultation consultation = dao.getConsultation(Integer.parseInt(id));


                // CPR
                String cpr = formParams.getFirst("data[" + id + "][cpr]");
                if(cpr != null) {
                    if (!dao.patientExists(cpr.replace("-", ""))) {
                        errors.add("CPR-nummeret findes ikke");
                        fieldNames.add("cpr");
                        errorOccured = true;
                    }
                    consultation.setCpr(cpr);
                }


                // Starts datoen
                String startDate = formParams.getFirst("data[" + id + "][startDate]");
                if(startDate != null) {
                    try {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        Date parsedDate = dateFormat.parse(startDate);
                        Timestamp timestamp = new java.sql.Timestamp(parsedDate.getTime());
                        consultation.setStartDate(timestamp);
                    } catch (Exception e) { // Hvis startdato ikke passer
                        errors.add("Dato formattet kunne ikke genkendes");
                        fieldNames.add("startDate");
                        errorOccured = true;
                    }
                }

                // Varighed
                String duration = formParams.getFirst("data[" + id + "][duration]");
                if(duration != null) {
                    try {
                        consultation.setDuration(Integer.parseInt(duration));
                    } catch (Exception E) {
                        errors.add("Varighed skal skrives i tal som sekunder.");
                        fieldNames.add("duration");
                        errorOccured = true;
                    }
                }


                // Note
                String note = formParams.getFirst("data[" + id + "][note]");
                if(note != null) {
                    response.setStatus(400);
                    response.flushBuffer();
                    consultation.setNote(note);
                }

                if(errorOccured){
                    return addErrors(errors.toArray(new String[0]), fieldNames.toArray(new String[0])).toString();
                }

                consultation.updateData();
            }
        }


        return dao.getConsultationsJSON().toString();

    }

    public JSONObject addError(String error){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("error", error);
        return jsonObject;
    }

    public JSONObject addErrors(String[] error, String[] fieldName){
        JSONObject jsonObject = new JSONObject();
        JSONArray array = new JSONArray();
        jsonObject.put("fieldErrors", array);
        for(int i=0;i< error.length;i++){
            JSONObject fieldError = new JSONObject();
            fieldError.put("name", fieldName[i]);
            fieldError.put("status", error[i]);
            array.add(fieldError);
        }
        jsonObject.put("fieldErrors", array);
        return jsonObject;
    }
    public JSONObject addError(String error, String fieldName){
        return addErrors(new String[] {error}, new String[] {fieldName});
    }


    public String[] getIds(HttpServletRequest req){
        String paramId = req.getParameter("id");
        return paramId.split(",");
    }

}

