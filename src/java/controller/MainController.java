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
    private static final String SEARCH_CATEGORY = "ViewCategories";
    private static final String SEARCH_CATEGORY_CONTROLLER = "SearchCategoryController";
    private static final String CREATE_CATEGORY = "CreateCategory";
    private static final String CREATE_CATEGORY_CONTROLLER = "CreateCategoryController";
    private static final String DELETE_CATEGORY = "DeleteCategory";
    private static final String DELETE_CATEGORY_CONTROLLER = "DeleteCategoryController";
    private static final String UPDATE_CATEGORY = "UpdateCategory";
    private static final String UPDATE_CATEGORY_CONTROLLER = "UpdateCategoryController";
    private static final String SEARCH_PRODUCT = "ViewProducts";
    private static final String SEARCH_PRODUCT_CONTROLLER = "SearchProductController";
    private static final String CREATE_PRODUCT = "CreateProduct";
    private static final String CREATE_PRODUCT_CONTROLLER = "CreateProductController";
    private static final String DELETE_PRODUCT = "DeleteProduct";
    private static final String DELETE_PRODUCT_CONTROLLER = "DeleteProductController";
    private static final String UPDATE_PRODUCT = "UpdateProduct";
    private static final String UPDATE_PRODUCT_CONTROLLER = "UpdateProductController";
    
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "error.jsp";
        try {
            String action = request.getParameter("action");
            if (LOGIN.equals(action)) {
                url = LOGIN_CONTROLLER;
            } else if (SEARCH_CATEGORY.equals(action)) {
                url = SEARCH_CATEGORY_CONTROLLER;
            } else if (CREATE_CATEGORY.equals(action)) {
                url = CREATE_CATEGORY_CONTROLLER;
            } else if (DELETE_CATEGORY.equals(action)) {
                url = DELETE_CATEGORY_CONTROLLER;
            } else if (UPDATE_CATEGORY.equals(action)) {
                url = UPDATE_CATEGORY_CONTROLLER;
            } else if (SEARCH_PRODUCT.equals(action)) {
                url = SEARCH_PRODUCT_CONTROLLER;
            } else if (CREATE_PRODUCT.equals(action)) {
                url = CREATE_PRODUCT_CONTROLLER;
            } else if (DELETE_PRODUCT.equals(action)) {
                url = DELETE_PRODUCT_CONTROLLER;
            } else if (UPDATE_PRODUCT.equals(action)) {
                url = UPDATE_PRODUCT_CONTROLLER;
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
