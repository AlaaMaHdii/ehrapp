package com.web.ehrapp.api;

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

@Path("folkeregister")
@AuthenticationRequired
public class Folkeregister extends Application {

    @Context
    private SecurityContext securityContext;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @RolesAllowed("Læge")
    public String getCitizens(@Context HttpServletRequest req) throws SQLException {
       FolkeregisterDAO dao = new FolkeregisterDAO();

       return dao.getBorgerJson().toString();
    }

    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String deleteCitizen(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        User user = (User) securityContext.getUserPrincipal();
        String[] cprs = getIds(req);
        MultivaluedMap<String, String> formParams = form.asMap();
        FolkeregisterDAO dao = new FolkeregisterDAO();

        // Ikke det bedste, men virker for nu.
        for (String cpr : cprs) {
            cpr = cpr.replace("-", "");

            if(dao.getNumberOfConsultations(cpr) == 0){
                dao.deleteBorger(cpr);
            }else{
                response.setStatus(500);
                response.flushBuffer();
                return addError("Denne borger har konsultationer, fjern dem først.", "cpr").toString();
            }
            dao.deleteBorger(cpr);
        }

        return dao.getBorgerJson().toString();
    }

    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String addCitizen(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        User user = (User) securityContext.getUserPrincipal();
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");
        FolkeregisterDAO dao = new FolkeregisterDAO();

        // error handling
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();

        String cpr = formParams.getFirst("data[0][cpr]");
        // Fjern - mellem løbenummeret.
        if(cpr != null){
            cpr = cpr.replace("-", "");
        }

        if(cpr == null || !cpr.isEmpty() && cpr.length() != 10){
            errors.add("CPR-nummeret er ikke gyldigt");
            fieldNames.add("cpr");
        }

        if(dao.getBorger(cpr) != null){
            errors.add("CPR-nummeret er allerede registeret til en anden borger.");
            fieldNames.add("cpr");
        }

        String name = formParams.getFirst("data[0][name]");
        if(name == null || name.isEmpty()){
            errors.add("Du skal indtaste et navn til borgeren.");
            fieldNames.add("name");
        }

        // error handling
        if(!errors.isEmpty()){
            response.setStatus(400);
            response.flushBuffer();
            return addErrors(errors.toArray(new String[0]), fieldNames.toArray(new String[0])).toString();
        }

        // Opret consultation
        if(Objects.equals(action, "create")) {
            Borger borger = dao.createBorger(cpr, name);
        }
        return dao.getBorgerJson(cpr).toString();
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String modifyCitizen(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        User user = (User) securityContext.getUserPrincipal();
        String[] cprs = getIds(req);
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");
        FolkeregisterDAO dao = new FolkeregisterDAO();

        // error handling
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();

        for (String cpr : cprs) {
                if (Objects.equals(action, "edit")) {
                    Borger borger = null;
                    if (cpr == null || !cpr.isEmpty() && cpr.length() != 11) {
                        errors.add("CPR-nummeret er ikke gyldigt");
                        fieldNames.add("cpr");
                    }else {
                        borger = dao.getBorger(cpr.replace("-", ""));
                        if(borger == null) {
                            errors.add("CPR-nummeret findes ikke.");
                            fieldNames.add("cpr");
                        }
                    }

                    String name = formParams.getFirst("data[" + cpr + "][name]");
                    if (name == null || name.isEmpty()) {
                        errors.add("Du skal indtaste et navn til borgeren.");
                        fieldNames.add("name");
                    }


                    // error handling
                    if (!errors.isEmpty()) {
                        response.setStatus(400);
                        response.flushBuffer();
                        return addErrors(errors.toArray(new String[0]), fieldNames.toArray(new String[0])).toString();
                    }else {
                        // uploading
                        borger.setName(name);
                        dao.updateBorger(borger);
                    }
            }
        }

        return dao.getBorgerJson().toString();

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
        String paramId = req.getParameter("cpr");
        return paramId.split(",");
    }

}

