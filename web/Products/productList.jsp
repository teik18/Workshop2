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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Product List Page</title>
        <link rel="stylesheet" type="text/css" href="css/pageStyle.css"> 
    </head>
    <body>
        <c:if test="${empty sessionScope.LOGIN_USER}">
            <c:redirect url="login.jsp"/>
        </c:if>
        <div class="container">
            <div class="sidebar">
                <h2>Menu</h2>
                <a href="MainController?action=SearchStock">Stock List</a>
                <a href="MainController?action=SearchTransaction">Transaction List</a>
                <a href="MainController?action=ViewAlerts">Alert List</a>
                <a class="active" href="MainController?action=ViewProducts">Product List</a>
                <c:if test="${sessionScope.LOGIN_USER.roleID == 'AD'}">
                    <a href="MainController?action=SearchUser">User List</a>
                    <a href="MainController?action=ViewCategories">Category List</a>
                </c:if>
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
                        <c:if test="${sessionScope.LOGIN_USER.roleID == 'SE'}">
                        <button id="showCreateForm" class="button-green" onclick="toggleCreateForm()">Create</button>
                        </c:if>
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
                        <c:if test="${not empty requestScope.MSG}">
                            <c:choose>
                                <c:when test="${fn:contains(requestScope.MSG, 'successfully') || fn:contains(requestScope.MSG, 'Successfully')}">
                                    <h3 id="msg" class="msg success" style="color: #3c763d; background-color: #e0ffe0;">
                                        <c:out value="${requestScope.MSG}"/>
                                    </h3>
                                </c:when>
                                <c:otherwise>
                                    <h3 id="msg" class="msg error" style="color: #a94442; background-color: #f2dede;">
                                        <c:out value="${requestScope.MSG}"/>
                                    </h3>
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </div>
                </div>
                    
                <c:if test="${empty list}">
                   <p style="margin:10px 0;" >No matching products found!</p>
                </c:if>

                <c:if test="${not empty requestScope.list}">
                    <table>
                        <tr>
                            <th>No</th>
                            <th>Name</th>
                            <th>Category</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Status</th>
                            <c:if test="${sessionScope.LOGIN_USER.roleID == 'AD'}">
                                <th>Seller</th>
                            </c:if>
                            <c:if test="${sessionScope.LOGIN_USER.roleID == 'SE'}">
                                <th>Function</th>
                            </c:if>
                        </tr>
                        <c:forEach var="product" items="${requestScope.list}" varStatus="loop">
                            <tr>
                                <td>${loop.count}</td>
                                <td><c:out value="${product.name}"/></td>
                                <td><c:out value="${product.cateName}"/></td>
                                <td><c:out value="${product.price}"/></td>
                                <td><c:out value="${product.quantity}"/></td>
                                <td><c:out value="${product.status}"/></td>
                                <c:if test="${sessionScope.LOGIN_USER.roleID == 'AD'}">
                                    <td><c:out value="${not empty product.sellerFullName ? product.sellerFullName : 'Unknown'}"/></td>
                                </c:if>
                                <c:if test="${sessionScope.LOGIN_USER.roleID == 'SE'}">
                                    <td>
                                        <div class="function-buttons">
                                            <form action="MainController" method="GET">
                                                <input type="hidden" name="id" value="${product.productID}">
                                                <button type="submit" name="action" value="UpdateProduct">Update</button>
                                            </form>
                                            <form action="MainController" method="POST">
                                                <input type="hidden" name="id" value="${product.productID}">
                                                <button class="butDelete" type="submit" name="action" value="DeleteProduct" onclick="return confirm('Are you sure to delete this alert?')">Delete</button>
                                            </form>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>
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
