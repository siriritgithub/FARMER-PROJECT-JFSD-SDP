<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<div class="fg-auth-wrap">
    <div class="fg-auth-card">
        <div class="icon-badge">&#128272;</div>
        <h2>Admin Login</h2>
        <p class="sub">Restricted access for platform administrators.</p>

        <c:if test="${not empty message}">
            <div class="fg-alert err"><c:out value="${message}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkadminlogin" method="post">
            <div class="fg-field">
                <label for="admin-username">Username</label>
                <input type="text" id="admin-username" name="admin-username" required autofocus>
            </div>
            <div class="fg-field">
                <label for="admin-password">Password</label>
                <input type="password" id="admin-password" name="admin-password" required>
            </div>
            <button type="submit" class="btn block">Log In</button>
        </form>
    </div>
</div>
</body>
</html>
