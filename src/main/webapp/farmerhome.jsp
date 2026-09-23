<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Farmer Dashboard - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">Welcome back, <c:out value="${farmer.name}" /></h1>
    <p style="color:var(--muted); margin-top:-6px;">Manage your listings and orders.</p>

    <div class="fg-stats">
        <div class="fg-stat">
            <div class="label">Your Products</div>
            <div class="value">${productCount}</div>
        </div>
        <div class="fg-stat">
            <div class="label">Total Orders</div>
            <div class="value">${orderCount}</div>
        </div>
    </div>

    <h2 style="font-size:1.2rem;">Quick actions</h2>
    <div class="fg-grid">
        <a class="fg-card" href="${pageContext.request.contextPath}/farmeraddproduct">
            <div class="icon">&#127807;</div><h3>Add Product</h3>
            <p>List new produce for sale.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/farmerproducts">
            <div class="icon">&#128230;</div><h3>My Products</h3>
            <p>See everything you currently have listed.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/farmerupdateproduct">
            <div class="icon">&#9999;&#65039;</div><h3>Update Product</h3>
            <p>Change price, quantity or details.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/farmerupdateprofile">
            <div class="icon">&#128100;</div><h3>Profile</h3>
            <p>Update your contact and account details.</p>
        </a>
    </div>
</div>
</body>
</html>
