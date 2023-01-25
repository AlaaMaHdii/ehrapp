package com.web.ehrapp.apiBorger;

import com.web.ehrapp.model.Borger;
import com.web.ehrapp.model.FolkeregisterDAO;
import com.web.ehrapp.model.User;
import com.web.ehrapp.model.UserDAO;
import jakarta.annotation.Priority;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.NotAuthorizedException;
import jakarta.ws.rs.Priorities;
import jakarta.ws.rs.container.ContainerRequestContext;
import jakarta.ws.rs.container.ContainerRequestFilter;
import jakarta.ws.rs.core.Context;
import jakarta.ws.rs.core.SecurityContext;
import jakarta.ws.rs.ext.Provider;

import java.io.IOException;
import java.security.Principal;
import java.sql.SQLException;

@Provider
@AuthenticationRequired
@Priority(Priorities.AUTHENTICATION)
public class AuthenticationAPIFilter implements ContainerRequestFilter {
    @Context
    HttpServletRequest webRequest;



    // Authenticate virker enten på
    // Session cookies
    // Authentication header
    @Override
    public void filter(ContainerRequestContext containerRequestContext) throws IOException {

        // Hvis man er logget ind med SESSION
        HttpSession session = webRequest.getSession();

        Borger borger = (Borger) session.getAttribute("borger");

        // hent de nyeste opdateringer fra user objektet
        if(borger != null){
            try {
                FolkeregisterDAO dao = new FolkeregisterDAO();
                borger = dao.getBorger(borger.getCpr());
            } catch (SQLException ignored) {
            }
        }

        if(borger == null){
            throw new NotAuthorizedException("Ugyldig legitimationsoplysninger.");
        }


        SecurityContext securityContext = containerRequestContext.getSecurityContext();
        Borger finalBorger = borger;
        containerRequestContext.setSecurityContext(new SecurityContext()
        {
            @Override
            public Principal getUserPrincipal()
            {
                return finalBorger;
            }

            @Override
            public boolean isUserInRole(String role)
            {
                return false;
            }

            @Override
            public boolean isSecure()
            {
                return securityContext.isSecure();
            }

            @Override
            public String getAuthenticationScheme()
            {
                return securityContext.FORM_AUTH;
            }
        });

    }
}

