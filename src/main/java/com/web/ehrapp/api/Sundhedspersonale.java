package com.web.ehrapp.api;

import com.web.ehrapp.model.Borger;
import com.web.ehrapp.model.FolkeregisterDAO;
import com.web.ehrapp.model.User;
import com.web.ehrapp.model.UserDAO;
import jakarta.annotation.security.RolesAllowed;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Objects;

@Path("sundhedspersonale")
@AuthenticationRequired
public class Sundhedspersonale extends Application {

    @Context
    private SecurityContext securityContext;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @RolesAllowed("Læge")
    public String getCitizens(@Context HttpServletRequest req) throws SQLException {
        UserDAO dao = new UserDAO();
        return dao.getUsersJSON().toString();
    }

    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String deleteCitizen(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        return "";
    }

    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String addCitizen(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        return "";
    }

    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String modifyCitizen(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        return "";
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

