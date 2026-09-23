<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Registration - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<div class="fg-auth-wrap">
    <div class="fg-auth-card" style="max-width:560px;">
        <div class="icon-badge">&#128722;</div>
        <h2>User Registration</h2>
        <p class="sub">Your account needs admin approval before you can log in.</p>

        <c:if test="${not empty message}">
            <div class="fg-alert err"><c:out value="${message}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/checkuserregister" method="post">
            <div class="fg-field">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required minlength="3" maxlength="50">
            </div>
            <div class="fg-field">
                <label for="phone">Phone Number</label>
                <input type="text" id="phone" name="phone" required pattern="[0-9]{10}"
                       placeholder="10-digit phone number">
            </div>
            <div class="fg-field">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required minlength="5" maxlength="15">
            </div>
            <div class="fg-field">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="fg-field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required minlength="8">
            </div>
            <div class="fg-field">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" required minlength="5" maxlength="100">
            </div>
            <div class="fg-field">
                <label for="state">State</label>
                <select id="state" name="state" required>
                    <%@ include file="_states.jsp" %>
                </select>
            </div>
            <div class="fg-field">
                <label for="imageUrl">Profile Image URL (optional)</label>
                <input type="url" id="imageUrl" name="imageUrl" placeholder="https://...">
            </div>
            <button type="submit" class="btn block">Create Account</button>
        </form>

        <p class="fg-foot-link">
            Already registered? <a href="${pageContext.request.contextPath}/userlogin">Log in</a>
        </p>
    </div>
</div>
</body>
</html>
