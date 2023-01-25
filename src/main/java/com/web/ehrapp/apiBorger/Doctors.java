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

@Path("getDoctors")
public class Doctors extends Application {

    @Context
    private SecurityContext securityContext;

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String getConsultations(@Context HttpServletRequest req) throws SQLException {
       UserDAO dao = new UserDAO();
       return dao.getUsersDataTableSelectJSON().toString();
    }


}

