package com.web.ehrapp.api;

import com.web.ehrapp.model.User;
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
        containerRequestContext.setSecurityContext(new SecurityContext()
        {
            @Override
            public Principal getUserPrincipal()
            {
                return user;
            }

            @Override
            public boolean isUserInRole(String role)
            {
                String[] roles = user.getRole().split(", ");
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

