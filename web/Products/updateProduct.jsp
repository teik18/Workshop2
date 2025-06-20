<%-- 
    Document   : updateProduct
    Created on : Jun 18, 2025, 6:51:56 PM
    Author     : ACER
--%>

<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page import="dto.Product"%>
<!DOCTYPE html>
<html>
    <head>
        <title>UPDATE PRODUCT</title>
        <link rel="stylesheet" type="text/css" href="css/updatePage.css">
    </head>
    <body>
        <%
            Product product = (Product) request.getAttribute("PRODUCT");
            if (product == null) {
                response.sendRedirect("productList.jsp");
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
            <h2>Update Product</h2>
            <form action="MainController" method="POST">
                <input type="hidden" name="id" value="<%= product.getProductID() %>">
                <label>Name </label>
                <input type="text" name="name" value="<%= product.getName() %>"><br>

                <label>Category </label><br>
                <select name="categoryID">
                    <option value="">Select Category</option>
                    <c:forEach var="category" items="${requestScope.categories}">
                        <option value="${category.categoryID}" ${product.getCategoryID() == category.categoryID ? 'selected' : ''}>
                            ${category.categoryName}
                        </option>
                    </c:forEach>
                </select><br>
                
                <label>Price </label>
                <input type="number" name="price" value="<%= product.getPrice() %>"><br>
                
                <label>Quantity </label>
                <input type="number" name="quantity" value="<%= product.getQuantity() %>"><br>   
                
                <label>Status </label>
                <select name="status" required>
                    <option value="Active" <%= "Active".equals(product.getStatus()) ? "selected" : "" %>>Active</option>
                    <option value="Inactive" <%= "Inactive".equals(product.getStatus()) ? "selected" : "" %>>Inactive</option>
                </select><br>
                
                <%
                    String MSG = (String) request.getAttribute("MSG");
                    if ((MSG != null && MSG.contains("successfully")) || (MSG != null && MSG.contains("Successfully"))) {
                %>
                <h3 id="msg" class="msg success"  style="color: #3c763d; background-color: #e0ffe0;"> <%= MSG%> </h3>
                <%
                    } else if (MSG != null) {
                %>
                <h3 id="msg" class="msg error" style="color: #a94442; background-color: #f2dede;"> <%= MSG%> </h3>
                <% } %>
                <button type="submit" name="action" value="UpdateProduct">Edit</button>
                <a href="MainController?action=ViewProducts">Back to Product List</a>
            </form>
        </div>
    </body>
</html>
