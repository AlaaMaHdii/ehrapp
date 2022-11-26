package com.web.ehrapp.frontendapi;

import com.web.ehrapp.model.User;
import com.web.ehrapp.model.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.ws.rs.ext.Provider;

import java.io.IOException;
import java.sql.SQLException;

@WebFilter({"/personale/*", "/otp.jsp"})
public class AuthenticationFrontendFilter implements Filter {


    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;



        HttpSession session = ((HttpServletRequest) request).getSession();
        User user = (User) session.getAttribute("user");


        // hent de nyeste opdateringer fra user objektet
        if(user != null){
            try {
                UserDAO dao = new UserDAO();
                user = dao.getUser(user.getId());
            } catch (SQLException ignored) {
            }
        }

        boolean otpVerified = false;
        try {
            otpVerified = (boolean) session.getAttribute("otpVerified");
        }catch (Exception e){

        }


        if(user == null && (!req.getRequestURI().endsWith("login.jsp") || req.getRequestURI().endsWith("otp.jsp")) ){
            req.setAttribute("message", "Du skal logge ind først.");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
        } else if ( !req.getRequestURI().endsWith("otp.jsp") && !otpVerified) {
            req.setAttribute("message", "Du skal logge ind med 2FA først.");
            res.sendRedirect(req.getContextPath() + "/otp.jsp");
        } else if (user != null && user.isDisabled()) {
            // konto blokeret.
            request.setAttribute("message", "Din konto er blevet blokeret.");
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            session.invalidate();
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

