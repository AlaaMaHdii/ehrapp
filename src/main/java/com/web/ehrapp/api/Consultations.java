package com.web.ehrapp.api;

import com.web.ehrapp.model.Consultation;
import com.web.ehrapp.model.ConsultationDAO;
import com.web.ehrapp.model.User;
import jakarta.annotation.security.RolesAllowed;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Application;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.SecurityContext;
import org.jooq.tools.json.JSONObject;

import java.sql.SQLException;
import java.util.ArrayList;

@Path("consultations")
@AuthenticationRequired
public class Consultations extends Application {

    @Context
    private SecurityContext securityContext;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @RolesAllowed("Læge")
    public String  getConsultations(@Context HttpServletRequest req) throws SQLException {
        User user = (User) securityContext.getUserPrincipal();
        ConsultationDAO dao = new ConsultationDAO(user);
        return dao.getConsultationsJSON().toString();
    }
}