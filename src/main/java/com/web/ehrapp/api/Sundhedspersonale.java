package com.web.ehrapp.api;

import com.web.ehrapp.model.*;
import jakarta.annotation.security.RolesAllowed;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.*;
import org.jooq.tools.json.JSONArray;
import org.jooq.tools.json.JSONObject;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

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
    public String getPersonnel(@Context HttpServletRequest req) throws SQLException {
        UserDAO dao = new UserDAO();
        return dao.getUsersJSON().toString();
    }
    @POST
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String modifyPersonnel(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        UserDAO dao = new UserDAO();
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");

        String[] ids  = getIds(req);
        // tjek om det var edit
        if(!Objects.equals(action, "edit")){
            return "Denne method er ikke tilladt.";
        }
        for (String id : ids) {
            User user = dao.getUser(Integer.parseInt(id));

            String name = formParams.getFirst("data[" + id + "][name]");
            String email = formParams.getFirst("data[" + id + "][email]");
            String roles = formParams.getFirst("data[" + id + "][roles]");
            String phoneNumber = formParams.getFirst("data[" + id + "][phoneNumber]");
            String isDisabled = formParams.getFirst("data[" + id + "][isDisabled]");
            String password = formParams.getFirst("data[" + id + "][password]").replace("●", "");

            // check if password has been changed
            if(!password.isEmpty()){
                user.setPassword(dao.encryptPassword(password));
            }

            // set disabled status
            if(!isDisabled.isEmpty()){
                user.setDisabled(Boolean.parseBoolean(isDisabled));
            }

            if(!phoneNumber.isEmpty()){
                user.setPhoneNumber(phoneNumber);
            }

            if(!roles.isEmpty()){
                user.setRole(roles);
            }

            if(!email.isEmpty()){
                user.setEmail(email);
            }

            if(!name.isEmpty()){
                user.setName(name);
            }

            dao.updateUser(user);

        }

        return dao.getUsersJSON().toString();
    }


    @DELETE
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String deletePersonnel(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        UserDAO dao = new UserDAO();
        MultivaluedMap<String, String> formParams = form.asMap();
        String action = formParams.getFirst("action");

        String[] ids  = getIds(req);
        // tjek om det var edit
        for (String id : ids) {
            dao.deleteUser(Integer.parseInt(id));
        }

        return dao.getUsersJSON().toString();
    }

    @PUT
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    @RolesAllowed("Læge")
    public String addPersonnel(@Context HttpServletRequest req, @Context final HttpServletResponse response, Form form) throws SQLException, IOException {
        MultivaluedMap<String, String> formParams = form.asMap();
        UserDAO dao = new UserDAO();
        String action = formParams.getFirst("action");

        // error handling
        ArrayList<String> errors = new ArrayList<String>();
        ArrayList<String> fieldNames = new ArrayList<String>();

        // Opret consultation
        if(Objects.equals(action, "create")) {
            String name = formParams.getFirst("data[0][name]");
            String email = formParams.getFirst("data[0][email]");
            String roles = formParams.getFirst("data[0][roles]");
            String phoneNumber = formParams.getFirst("data[0][phoneNumber]");
            boolean isDisabled = Boolean.parseBoolean(formParams.getFirst("data[0][isDisabled]"));
            String password = formParams.getFirst("data[0][password]");


            // check if password has been changed
            if(password.isEmpty()){
                errors.add("Password feltet må ikke være tomt.");
                fieldNames.add("password");
            }


            if(!phoneNumber.startsWith("+")){
                errors.add("Telefonnummeret er ugyldigt. Skal start med \"+\"");
                fieldNames.add("phoneNumber");
            }

            if(roles.isEmpty()){
                errors.add("Der skal være en stilling tilknyttet.");
                fieldNames.add("roles");
            }

            if(email.isEmpty()){
                errors.add("E-mail er ugyldigt.");
                fieldNames.add("email");
            }

            if(name.isEmpty()){
                errors.add("Navn er ugyldigt.");
                fieldNames.add("name");
            }


            if(!errors.isEmpty()){
                response.setStatus(400);
                response.flushBuffer();
                return addErrors(errors.toArray(new String[0]), fieldNames.toArray(new String[0])).toString();
            }

            User newUser = dao.createUser(name, roles, email, password, phoneNumber, isDisabled);
            return dao.getUserJSON(newUser.getEmail()).toString();

        }
        return "Der er opstået en fejl.";
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

    public static String sanitizeXSS(String unsafeInput){
        // deaktiveret for nu
        //PolicyFactory policy = Sanitizers.FORMATTING.and(Sanitizers.LINKS);
        //return policy.sanitize(unsafeInput);
        return unsafeInput;
    }

}

