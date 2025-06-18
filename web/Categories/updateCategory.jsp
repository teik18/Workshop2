<%-- 
    Document   : updateCategory
    Created on : Jun 18, 2025, 5:29:25 PM
    Author     : ACER
--%>

<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dto.Category"%>
<!DOCTYPE html>
<html>
    <head>
        <title>UPDATE CATEGORY</title>
        <link rel="stylesheet" type="text/css" href="css/updatePage.css">
    </head>
    <body>
        <%
            Category category = (Category) request.getAttribute("CATEGORY");
            if (category == null) {
                response.sendRedirect("categoryList.jsp");
                return;
            }
        %>
        <%
                User loginUser = (User) session.getAttribute("LOGIN_USER");
                if (loginUser == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
        %>
        <div class="form-container">
            <h2>Update Category</h2>
            <form action="MainController" method="POST">
                <label>ID </label>
                <input type="text" name="id" value="<%= category.getCategoryID() %>" readonly><br>

                <label>Category </label>
                <input type="text" name="categoryName" value="<%= category.getCategoryName() %>"><br>


                <label>Description </label>
                <input type="text" name="description" value="<%= category.getDescription() %>"><br>

                <button type="submit" name="action" value="UpdateCategory">Edit</button>
                <a href="MainController?action=ViewCategories">Back to Category List</a>
            </form>
        </div>
    </body>
</html>
