<%-- 
    Document   : productList
    Created on : Jun 18, 2025, 5:38:16 PM
    Author     : ACER
--%>

<%@page import="dto.Product"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product List Page</title>
        <link rel="stylesheet" type="text/css" href="css/pageStyle.css"> 
    </head>
    <body>
        <%
            User loginUser = (User) session.getAttribute("LOGIN_USER");
            if (loginUser == null) {
                response.sendRedirect("login.jsp");
                return;
            }
        %>
        <div class="container">
            <div class="sidebar">
                <h2>Menu</h2>
                <a href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=ViewAlerts">Alert List</a>
                <a class="active" href="MainController?action=ViewProducts">Product List</a>
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=SearchUser">User List</a>
                <% } %>
            </div>

            <div class="main-content">
                <div class="header">
                    <h1>Welcome, <c:out value="${sessionScope.LOGIN_USER.fullName}"/></h1>
                    <p><a href="${pageContext.request.contextPath}/LogoutController">Logout</a></p>
                </div>

                <hr>

                <div class="function-header">
                    <div class="function">
                        <!--search form-->
                        <form action="MainController" method="POST">
                            Search
                            <input type="text" name="nameSearch" placeholder="Name" value="${requestScope.nameSearch}"> 
                            <select name="cateSearch">
                                <option value="">Any</option>
                                <c:forEach var="category" items="${requestScope.categories}">
                                    <option value="${category.categoryName}" ${requestScope.cateSearch == category.categoryName ? 'selected' : ''}>
                                        ${category.categoryName}
                                    </option>
                                </c:forEach>
                            </select> 
                            <input type="number" name="priceSearch" placeholder="Price" value="${requestScope.priceSearch}"> 
                            <select name="statusSearch">
                                <option value="" ${requestScope.statusSearch == '' ? 'selected' : ''}>Any</option>
                                <option value="active" ${requestScope.statusSearch == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${requestScope.statusSearch == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                            <button type="submit" name="action" value="ViewProducts">Search</button>
                        </form>

                        <!--create form-->
                        <% if ("SE".equals(loginUser.getRoleID())) { %>
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        <% } %>
                        <div id="createForm" style="display: none;">
                            <h3>Create New Product</h3> <hr>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="action" value="CreateProduct"/>
                                <div class="form-group">
                                    <label for="name">Name: </label>
                                    <input type="text" id="name" name="name" required/>
                                </div>

                                <div class="form-group">
                                    <label for="categoryID">Category: </label> 
                                    <select id="categoryID" name="categoryID" required>
                                        <option value="">Select Category</option>
                                        <c:forEach var="category" items="${requestScope.categories}">
                                            <option value="${category.categoryID}">${category.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                
                                <div class="form-group">
                                    <label for="price">Price: </label>
                                    <input type="number" id="price" name="price" required/>
                                </div>

                                <div class="form-group">
                                    <label for="quantity">Quantity: </label>
                                    <input type="number" id="quantity" name="quantity" required/>
                                </div>
                                
                                <div class="form-group">
                                    <label for="status">Status: </label>
                                    <select id="status" name="status" required>
                                        <option value="Active" >Active</option>
                                        <option value="Inactive" >Inactive</option>
                                    </select>
                                </div>
                                <button type="submit" class="button-green">Create</button>
                            </form>
                        </div>
                    </div>

                    <div class="message">
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
                    </div>
                </div>
                    
                <c:if test="${empty list}">
                   <p style="margin:10px 0;" >No matching products found!</p>
                </c:if>

                <%
                    ArrayList<Product> list = (ArrayList<Product>) request.getAttribute("list");
                    if (list != null) {
                %>
                <table>
                    <tr>
                        <th>No</th>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Status</th>
                        <% if ("SE".equals(loginUser.getRoleID())) { %>
                        <th>Function</th>
                        <% } %>
                    </tr>
                    <%
                        int count = 0;
                        for (Product product : list) {
                            count++;
                    %>
                    <tr>
                        <td><%= count%></td>
                        <td><input type="text" name="name" value="<%= product.getName()%>" readonly></td>
                        <td><input type="text" name="cateName" value="<%= product.getCateName()%>" readonly></td>
                        <td><input type="text" name="price" value="<%= product.getPrice()%>" readonly></td>
                        <td><input type="text" name="quantity" value="<%= product.getQuantity()%>" readonly></td>
                        <td><input type="text" name="status" value="<%= product.getStatus()%>" readonly></td>
                        <% if ("SE".equals(loginUser.getRoleID())) { %>
                        <td> 
                            <div class="function-buttons">
                                
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="id" value="<%= product.getProductID() %>">
                                    <button type="submit" name="action" value="UpdateProduct">Update</button>
                                </form>
                                
                                
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="id" value="<%= product.getProductID() %>">
                                    <button class="butDelete" type="submit" name="action" value="DeleteProduct" onclick="return confirm('Are you sure to delete this alert?')">Delete</button>
                                </form>
                                
                            </div>
                        </td>
                        <% } %>
                        
                    </tr>
                    <% }
                    %>
                </table>
                <%
                    }
                %>
            </div>
        </div>

        <script>
            function toggleCreateForm() {
                const formDiv = document.getElementById("createForm");
                const btn = document.getElementById("showCreateForm");
                if (formDiv.style.display === "none") {
                    formDiv.style.display = "block";
                    btn.classList.remove("button-green");
                    btn.classList.add("button-red");
                    btn.innerHTML = "Close";
                } else {
                    formDiv.style.display = "none";
                    btn.classList.remove("button-red");
                    btn.classList.add("button-green");
                    btn.innerHTML = "Create";
                }
            }

            window.addEventListener("DOMContentLoaded", () => {
                const msg = document.getElementById("msg");
                if (msg) {
                    setTimeout(() => {
                        msg.style.opacity = "0"; // mờ dần
                        setTimeout(() => {
                            msg.style.display = "none"; // ẩn hoàn toàn sau khi mờ
                        }, 500); // delay đúng bằng transition ở CSS (0.5s)
                    }, 3000); // 3 giây trước khi bắt đầu mờ
                }
            });
        </script>
    </body>
</html>
