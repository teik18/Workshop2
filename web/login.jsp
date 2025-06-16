<%-- 
    Document   : login.jsp
    Created on : Jun 13, 2025, 10:41:21 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
    </head>
    <body>
        <h1>Login</h1>
        <form action="MainController" method="POST">
            <label>User ID:</label>
            <input type="text" name="userID" required>
            <br>
            <label>Password:</label>
            <input type="password" name="password" required>
            <br>
            <input type="submit" name="action" value="Login">
            <br>
            <a href="register.jsp">Register</a>
        </form>
    </body>
</html>
