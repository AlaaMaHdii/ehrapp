package com.web.ehrapp.frontendapi;

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

@WebServlet("/personale/logout")
public class UserLogoutServlet extends HttpServlet {



    public void init() {
    }


    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        // Tjek om brugeren er overhovedet logget ind?
        if(user != null){
            // Slet sessionen
            request.getSession().invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");

    }
    public void destroy() {
    }

}