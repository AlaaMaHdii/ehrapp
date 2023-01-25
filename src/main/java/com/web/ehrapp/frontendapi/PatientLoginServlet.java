package com.web.ehrapp.frontendapi;

import com.twilio.Twilio;
import com.twilio.rest.verify.v2.service.Verification;
import com.web.ehrapp.TwilioApiKeys;
import com.web.ehrapp.model.Borger;
import com.web.ehrapp.model.FolkeregisterDAO;
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

@WebServlet("/patient-login")
public class PatientLoginServlet extends HttpServlet {

    FolkeregisterDAO dao;


    public void init() {
        try {
            dao = new FolkeregisterDAO();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Tjek om brugeren allerede er logget ind?
        Borger borger = (Borger) request.getSession().getAttribute("borger");
        if(borger != null){
            response.sendRedirect(request.getContextPath() + "/borger/dashboard.html");
        }else{
            response.sendRedirect(request.getContextPath() + "/patient-login.jsp");
        }


    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tjek om brugeren allerede er logget ind?
        Borger borger = (Borger) request.getSession().getAttribute("borger");
        if(borger != null){
            response.sendRedirect(request.getContextPath() + "/borger/dashboard.html");
            return;
        }

        String cpr = request.getParameter("CPR").replace("-", "");
        try {
            // Bug serveren mister forbindelse til MySQL efter noget tid.
            dao.db.connectToDb();

            borger = dao.getBorger(cpr); // hent brugeren

            String message;
            if(borger == null){
                message = "Ugyldig CPR-nummer. Prøv igen.";
                request.setAttribute("message", message);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/patient-login.jsp");
                dispatcher.forward(request, response);
            }else{
                request.getSession().setAttribute("borger", borger);
                response.sendRedirect(request.getContextPath() + "/borger/dashboard.html");
            }

        } catch (IOException | SQLException ex) {
            String message = "Kommunikation med intern server fejlet. Prøv igen.";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/patient-login.jsp");
            dispatcher.forward(request, response);

        }
    }
    public void destroy() {
    }

}