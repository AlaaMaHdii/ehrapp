package com.web.ehrapp;

import com.web.ehrapp.model.User;
import com.web.ehrapp.model.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class UserLoginServlet extends HttpServlet {

    UserDAO dao;

    public void init() {
        try {
            dao = new UserDAO();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Tjek om brugeren allerede er logget ind?
        User user = (User) request.getSession().getAttribute("user");
        if(user != null){
            response.sendRedirect(request.getContextPath() + "/personale/dashboard.html");
        }else{
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }


    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tjek om brugeren allerede er logget ind?
        User user = (User) request.getSession().getAttribute("user");
        if(user != null){
            response.sendRedirect(request.getContextPath() + "/personale/dashboard.html");
            return;
        }

        String email = request.getParameter("email").toLowerCase(); // case insensitive
        String password = request.getParameter("password");
        String destination = "/login.jsp";
        try {
            user = dao.getUser(email); // hent brugeren
            String message;
            if(user == null){
                //String message = "Ugyldig e-mail. Prøv igen.";
                message = "Ugyldig email/kodeord. Prøv igen."; // email enumeration er en sikkerhedsrisiko ifølge OWASP
            }else if(!user.checkPassword(password)){
                //String message = "Ugyldig kodeord. Prøv igen.";
                message = "Ugyldig email/kodeord. Prøv igen."; // email enumeration er en sikkerhedsrisiko ifølge OWASP
            }else{
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                response.sendRedirect(request.getContextPath() + "/personale/dashboard.html");
                return;
            }
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher( destination);
            dispatcher.forward(request, response);

        } catch (IOException | SQLException ex) {
            String message = "Kommunikation med intern server fejlet.";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
            dispatcher.forward(request, response);
        }
    }
    public void destroy() {
    }

}