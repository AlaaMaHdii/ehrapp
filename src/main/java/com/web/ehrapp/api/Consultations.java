package com.web.ehrapp.frontendapi.consultations;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.Produces;
import jakarta.ws.rs.core.Application;

@Path("/personale/api/consultations")
public class Consultations extends Application {

    @GET
    @Produces("application/json")
    public String getConsultations() {
        return "Hello";
    }
}