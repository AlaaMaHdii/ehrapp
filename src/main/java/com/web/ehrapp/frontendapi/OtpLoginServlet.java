package com.web.ehrapp.frontendapi;

import com.twilio.rest.verify.v2.service.VerificationCheck;
import com.web.ehrapp.TwilioApiKeys;
import com.web.ehrapp.model.User;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.twilio.Twilio;

@WebServlet("/otp")
public class OtpLoginServlet extends HttpServlet {



    public void init() {
        Twilio.init(TwilioApiKeys.SID, TwilioApiKeys.PASSWORD);
    }


    public boolean checkOtp(User user, String otpCode){
        VerificationCheck vc =  VerificationCheck.creator(
                        TwilioApiKeys.VERIFY_SERVICE)
                .setTo(user.getPhoneNumber())
                .setCode(otpCode)
                .create();
        return vc.getValid();
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Tjek om brugeren allerede er logget ind?
        User user = (User) request.getSession().getAttribute("user");
        boolean otpVerified = false;
        try {
            otpVerified = (boolean) request.getSession().getAttribute("otpVerified");
        }catch (Exception e){

        }
        if(user != null & otpVerified){
            response.sendRedirect(request.getContextPath() + "/personale/dashboard.html");
        } else if (!otpVerified) {
            response.sendRedirect(request.getContextPath() + "/otp.jsp");
        } else{
            response.sendRedirect(request.getContextPath() + "/login.jsp");
        }


    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Tjek om brugeren allerede er logget ind?
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        String otp = request.getParameter("otp").toLowerCase(); // case insensitive
        int otpTries = (int) session.getAttribute("otpTries");

        if(checkOtp(user, otp)){
            session.setAttribute("otpVerified", true);
            response.sendRedirect(request.getContextPath() + "/personale/dashboard.html");
        }else{
            if(otpTries >= 2){ // Tre forsøg
                request.getSession().invalidate();
                request.setAttribute("message", "Du har indtastet 2FA-koden forkert flere gange, prøv igen senere.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
                dispatcher.forward(request, response);
            }else {
                session.setAttribute("otpTries", otpTries + 1);
                request.setAttribute("message", "Den indtastede 2FA-kode er forkert.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/otp.jsp");
                dispatcher.forward(request, response);
            }
        }

    }
    public void destroy() {
    }

}