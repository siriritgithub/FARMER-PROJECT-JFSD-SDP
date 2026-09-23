<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Status - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<div class="fg-auth-wrap">
    <div class="fg-auth-card" style="text-align:center;">
        <div class="icon-badge">&#9989;</div>
        <h2>Registration Status</h2>
        <p style="color:var(--ink); font-size:1rem;"><c:out value="${message}" /></p>
        <p class="sub">Thank you for registering with FarmGo.</p>
        <a href="${pageContext.request.contextPath}/login" class="btn block">Go to Login</a>
    </div>
</div>
</body>
</html>
