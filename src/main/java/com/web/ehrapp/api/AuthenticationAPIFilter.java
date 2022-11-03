package com.web.ehrapp;

import com.web.ehrapp.model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.ext.Provider;

import java.io.IOException;

@Authentication
public class AuthenticationAPIFilter implements Filter {


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    // skal laves om så det passer bedre til API
    // dette er en klon af frontend filteret.
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = ((HttpServletRequest) request).getSession();
        User user = (User) session.getAttribute("user");
        if(user == null){
            req.setAttribute("message", "Du skal logge ind først.");
            res.sendRedirect("login.jsp");
        }else{
            // Go to next filter.
            doFilter(request, response, filterChain);
        }
    }


    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}

