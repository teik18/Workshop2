/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name="MainController", urlPatterns={"/MainController"})
public class MainController extends HttpServlet {
   
    private static final String LOGIN = "Login";
    private static final String LOGIN_CONTROLLER = "LoginController";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "error.jsp";
        try {
            String action = request.getParameter("action");
            if (LOGIN.equals(action)) {
                url = LOGIN_CONTROLLER;
            
            } else {
                url = "login.jsp";
            }
        } catch (Exception e) {
            log("Error at MainController: " + e.toString());
        } finally {
            request.getRequestDispatcher(url).forward(request, response);
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // POST cũng xử lý giống GET
        doGet(request, response);
    }
}
