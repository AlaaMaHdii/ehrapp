package com.web.ehrapp.frontendapi;

import com.twilio.Twilio;
import com.twilio.rest.verify.v2.service.Verification;
import com.web.ehrapp.TwilioApiKeys;
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
        Twilio.init(TwilioApiKeys.SID, TwilioApiKeys.PASSWORD);
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

    public Verification sendSms(User user){
        return Verification.creator(
                        TwilioApiKeys.VERIFY_SERVICE,
                        user.getPhoneNumber(),
                        "sms")
                .create();
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
            // Bug serveren mister forbindelse til MySQL efter noget tid.
            if(dao.db.conn.isClosed()){
                dao.db.connectToDb();
            }

            user = dao.getUser(email); // hent brugeren
            String message;
            if(user == null){
                //String message = "Ugyldig e-mail. Prøv igen.";
                message = "Ugyldig email/kodeord. Prøv igen."; // email enumeration er en sikkerhedsrisiko ifølge OWASP
            }else if(!user.checkPassword(password)){
                //String message = "Ugyldig kodeord. Prøv igen.";
                message = "Ugyldig email/kodeord. Prøv igen."; // email enumeration er en sikkerhedsrisiko ifølge OWASP
            } else if (user.isDisabled()) {
                message = "Din konto er blevet blokeret.";
            } else{
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                if(user.isPhoneNumberRegistered() && TwilioApiKeys.OTP_ENABLED){
                    session.setAttribute("otpVerified", false);
                    session.setAttribute("otpTries", 0);
                    response.sendRedirect(request.getContextPath() + "/otp.jsp");
                    sendSms(user);
                }else{
                    session.setAttribute("otpVerified", true);
                    response.sendRedirect(request.getContextPath() + "/personale/dashboard.html");
                }
                return;
            }
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher( destination);
            dispatcher.forward(request, response);

        } catch (IOException | SQLException ex) {
            String message = "Kommunikation med intern server fejlet. Prøv igen.";
            request.setAttribute("message", message);
            RequestDispatcher dispatcher = request.getRequestDispatcher(destination);
            dispatcher.forward(request, response);

        }
    }
    public void destroy() {
    }

}