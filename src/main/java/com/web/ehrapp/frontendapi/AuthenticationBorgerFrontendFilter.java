package com.web.ehrapp.frontendapi;

import com.web.ehrapp.model.Borger;
import com.web.ehrapp.model.FolkeregisterDAO;
import com.web.ehrapp.model.User;
import com.web.ehrapp.model.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter({"/borger/*"})
public class AuthenticationBorgerFrontendFilter implements Filter {


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = ((HttpServletRequest) request).getSession();
        Borger borger = (Borger) session.getAttribute("borger");

        // hent de nyeste opdateringer fra user objektet
        if(borger != null){
            try {
                FolkeregisterDAO dao = new FolkeregisterDAO();
                borger = dao.getBorger(borger.getCpr());
            } catch (SQLException ignored) {
            }
        }


        if(borger == null && !req.getRequestURI().endsWith("login.jsp") ){
            req.setAttribute("message", "Du skal logge ind først.");
            res.sendRedirect(req.getContextPath() + "/patient-login.jsp");
        }else{
            // Go to next filter.
            filterChain.doFilter(request, response);
        }
    }


    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}

