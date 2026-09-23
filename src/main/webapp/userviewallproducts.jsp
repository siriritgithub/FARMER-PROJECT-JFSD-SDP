<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Products - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <%@ include file="_productcard.jsp" %>
</head>
<body>
<%@ include file="usernavbar.jsp" %>
<div class="fg-main">
    <h1 style="margin-top:0;">All Products</h1>
    <p style="color:var(--muted); margin-top:-6px;">Everything currently available on FarmGo.</p>
    <c:if test="${not empty message}"><div class="fg-alert ok">${message}</div></c:if>
    <%@ include file="_userproductgrid.jsp" %>
</div>
</body>
</html>
