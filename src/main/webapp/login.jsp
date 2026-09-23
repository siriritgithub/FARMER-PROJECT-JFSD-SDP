<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Login - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<div class="fg-auth-wrap">
    <div class="fg-auth-card">
        <div class="icon-badge">&#128101;</div>
        <h2>Farmer Login</h2>
        <p class="sub">Sign in to manage your produce and orders.</p>

        <c:if test="${not empty message}">
            <div class="fg-alert err"><c:out value="${message}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/loginAction" method="post">
            <div class="fg-field">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required autofocus>
            </div>
            <div class="fg-field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>
            <button type="submit" class="btn block">Log In</button>
        </form>

        <p class="fg-foot-link">
            <a href="${pageContext.request.contextPath}/forgetpassword">Forgot password?</a>
        </p>
        <p class="fg-foot-link">
            New farmer? <a href="${pageContext.request.contextPath}/register">Create an account</a>
        </p>
    </div>
</div>
</body>
</html>
