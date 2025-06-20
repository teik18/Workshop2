<%-- 
    Document   : categoryList
    Created on : Jun 18, 2025, 3:15:13 PM
    Author     : ACER
--%>

<%@page import="dto.Category"%>
<%@page import="java.util.ArrayList"%>
<%@page import="dto.User"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Category List Page</title>
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
                <% if ("AD".equals(loginUser.getRoleID())) { %>
                <a href="MainController?action=SearchUser">User List</a>
                <a class="active" href="MainController?action=ViewCategories">Category List</a>
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
                            <input type="text" name="cateSearch" placeholder="Search" value="${requestScope.keyword}"> 
                            <button type="submit" name="action" value="ViewCategories">Search</button>
                        </form>

                        <!--create form-->
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        <div id="createForm" style="display: none;">
                            <h3>Create New Category</h3> <hr>
                            <form action="MainController" method="POST">
                                <input type="hidden" name="action" value="CreateCategory"/>
                                <div class="form-group">
                                    <label for="categoryName">Category: </label>
                                    <input type="text" id="categoryName" name="categoryName" required/>
                                </div>

                                <div class="form-group">
                                    <label for="description">Description:</label>
                                    <input type="text" id="description" name="description" required/>
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
                   <p style="margin:10px 0;" >No matching categories found!</p>
                </c:if>

                <%
                    ArrayList<Category> list = (ArrayList<Category>) request.getAttribute("list");
                    if (list != null) {
                %>
                <table>
                    <tr>
                        <th>No</th>
                        <th>Category</th>
                        <th>Description</th>
                        <th>Function</th>
                    </tr>
                    <%
                        int count = 0;
                        for (Category category : list) {
                            count++;
                    %>
                    <tr>
                        <td><%= count%></td>
                        <td><%= category.getCategoryName()%></td>
                        <td><input type="text" name="type" value="<%= category.getDescription()%>" readonly></td>
                        <td> 
                            <div class="function-buttons">
                                
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="id" value="<%= category.getCategoryID() %>">
                                    <button type="submit" name="action" value="UpdateCategory">Update</button>
                                </form>
                                
                                
                                <form action="MainController" method="POST">
                                    <input type="hidden" name="id" value="<%= category.getCategoryID() %>">
                                    <button class="butDelete" type="submit" name="action" value="DeleteCategory" onclick="return confirm('Are you sure to delete this alert?')">Delete</button>
                                </form>
                                
                            </div>
                        </td>
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
