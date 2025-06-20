/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package controller.CategoriesControllers;

import dto.User;
import dto.Category;
import dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 *
 * @author ACER
 */
@WebServlet(name = "UpdateCategoryController", urlPatterns = {"/UpdateCategoryController"})
public class UpdateCategoryController extends HttpServlet {
    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    private static final String CATEGORY_LIST_PAGE = "SearchCategoryController";
    private static final String UPDATE_CATEGORY_PAGE = "Categories/updateCategory.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String url = CATEGORY_LIST_PAGE;

        try {
            User loginUser = (User) request.getSession().getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            int id = Integer.parseInt(request.getParameter("id"));
            CategoryDAO dao = new CategoryDAO();
            Category category = dao.getCategoryById(id);

            if (category == null) {
                request.setAttribute("MSG", "Cannot find the category!!");
                request.getRequestDispatcher(url).forward(request, response);
                return;
            }
           
            String categoryName = request.getParameter("categoryName");
            String description = request.getParameter("description");
            if (categoryName == null && description == null) {
                request.setAttribute("MSG", "The input cannot be blank!!");
                request.setAttribute("CATEGORY", category);
                request.getRequestDispatcher(UPDATE_CATEGORY_PAGE).forward(request, response);
                return;
            }
            
            category.setCategoryName(categoryName);
            category.setDescription(description);
            boolean updated = dao.updateCategory(id, categoryName, description);
            if (updated) {
                request.setAttribute("MSG", "Update Successfully!!");
                url = CATEGORY_LIST_PAGE;
            } else {
                request.setAttribute("MSG", "Update Failed!!");
                request.setAttribute("CATEGORY", category);
                url = UPDATE_CATEGORY_PAGE;
            }
            request.getRequestDispatcher(url).forward(request, response);
        } catch (SQLException e) {
            request.setAttribute("MSG", "Database error!!");
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        } catch (Exception e) {
            log("Error at UpdateCategoryController: " + e.toString());
            request.setAttribute("MSG", "System error: " + e.getMessage());
            request.getRequestDispatcher(CATEGORY_LIST_PAGE).forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}