package com.web.ehrapp.api;

import com.web.ehrapp.model.User;
import com.web.ehrapp.model.UserDAO;
import jakarta.annotation.Priority;
import jakarta.servlet.http.HttpServletRequest;
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
        User user = (User) session.getAttribute("user");

        try {
            UserDAO dao = new UserDAO();
            user = dao.getUser(user.getId());
        } catch (SQLException e) {

        }

        // check if blocked
        if(user.isDisabled()){
            session.invalidate();
            throw new NotAuthorizedException("Kontoen er blokeret.");
        }

        boolean otpVerified = false;
        try {
            otpVerified = (boolean) session.getAttribute("otpVerified");
        }catch (Exception e){

        }
        if((!otpVerified || user == null) && !containerRequestContext.getUriInfo().getPath().endsWith("login.jsp")){
            throw new NotAuthorizedException("Ugyldig legitimationsoplysninger.");
        }

        // Hvis man er logget ind med JWT
        // blah blah


        SecurityContext securityContext = containerRequestContext.getSecurityContext();
        User finalUser = user;
        containerRequestContext.setSecurityContext(new SecurityContext()
        {
            @Override
            public Principal getUserPrincipal()
            {
                return finalUser;
            }

            @Override
            public boolean isUserInRole(String role)
            {
                String[] roles = finalUser.getRole().split(", ");
                for (String roleIteration: roles) {
                    if(roleIteration.equalsIgnoreCase(role)){
                        return true;
                    }
                }
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

