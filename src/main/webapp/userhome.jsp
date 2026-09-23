<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="usernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">Welcome back, <c:out value="${username}" /></h1>
    <p style="color:var(--muted); margin-top:-6px;">Browse fresh produce and manage your orders.</p>

    <div class="fg-grid">
        <a class="fg-card" href="${pageContext.request.contextPath}/userbuyproducts">
            <div class="icon">&#128722;</div><h3>Browse Products</h3>
            <p>Shop by category and specification.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/userviewallfarmers">
            <div class="icon">&#128101;</div><h3>View Farmers</h3>
            <p>See who's growing what.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/myorders">
            <div class="icon">&#128230;</div><h3>My Orders</h3>
            <p>Track everything you've ordered.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/userupdateprofile">
            <div class="icon">&#128100;</div><h3>Profile</h3>
            <p>Update your contact and account details.</p>
        </a>
    </div>
</div>
</body>
</html>
