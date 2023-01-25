package com.web.ehrapp.apiBorger;

import com.web.ehrapp.model.*;
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
import java.util.Objects;

@Path("borgerConsultations")
@AuthenticationRequired
public class Consultations extends Application {

    @Context
    private SecurityContext securityContext;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String getConsultations(@Context HttpServletRequest req) throws SQLException {
       Borger borger = (Borger) securityContext.getUserPrincipal();
       return borger.getConsultationsJSON().toString();
    }

    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String deleteConsultations(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        Borger borger = (Borger) securityContext.getUserPrincipal();
        String[] ids = getIds(req);
        MultivaluedMap<String, String> formParams = form.asMap();
        ConsultationDAO dao = new ConsultationDAO(null);


        // Ikke det bedste, men virker for nu.
        for (String id : ids) {
            dao.deleteConsultation(Integer.parseInt(id));
        }

        return borger.getConsultationsJSON().toString();
    }

    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String addConsultations(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        Borger borger = (Borger) securityContext.getUserPrincipal();
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");

        // error handling
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();

        // Opret consultation
        if(Objects.equals(action, "create")) {
            int idOfDoctor = Integer.parseInt(formParams.getFirst("data[0][idOfDoctor]"));
            String startDate = formParams.getFirst("data[0][startDate]");
            String duration = "900";
            String note = formParams.getFirst("data[0][note]");

            boolean errorOccured = false;

            UserDAO uDao = new UserDAO();
            User user = uDao.getUser(idOfDoctor);
            if(user.isDisabled()) {
                errors.add("Du skal vælge en læge, der stadig arbejder der.");
                fieldNames.add("idOfDoctor");
                errorOccured = true;
            }

            ConsultationDAO dao = new ConsultationDAO(user);

            // Startdato
            Timestamp timestamp = null;
            if(startDate != null) {
                try {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                    Date parsedDate = dateFormat.parse(startDate);
                    timestamp = new Timestamp(parsedDate.getTime());
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

            Consultation consultation = dao.createConsultation(borger.getCpr().replace("-", ""), timestamp, Integer.parseInt(duration), note, 0);
            return dao.getConsultationJSON(consultation.getId()).toString();
        }
        return null;
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String modifyConsultations(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        Borger borger = (Borger) securityContext.getUserPrincipal();
        String[] ids = getIds(req);
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();
        boolean errorOccured = false;

        if(Objects.equals(action, "edit")) {
            for (String id : ids) {
                String idOfDoctor = formParams.getFirst("data[" + id + "][idOfDoctor]");
                User user = null;


                if(!idOfDoctor.isEmpty()) {
                    UserDAO uDao = new UserDAO();
                    user = uDao.getUser(Integer.parseInt(idOfDoctor));
                }

                ConsultationDAO dao = new ConsultationDAO(user);
                Consultation consultation = dao.getConsultation(Integer.parseInt(id));

                // update user
                consultation.setCreatedBy(user);

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
                        Timestamp timestamp = new Timestamp(parsedDate.getTime());
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
                    consultation.setNote(note);
                }

                if(errorOccured){
                    response.setStatus(400);
                    response.flushBuffer();
                    return addErrors(errors.toArray(new String[0]), fieldNames.toArray(new String[0])).toString();
                }

                consultation.updateData();
            }
        }


        return borger.getConsultationsJSON().toString();

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

