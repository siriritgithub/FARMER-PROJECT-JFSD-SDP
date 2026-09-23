<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buy by Category - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <%@ include file="_productcard.jsp" %>
</head>
<body>
<%@ include file="usernavbar.jsp" %>
<div class="fg-main">
    <h1 style="margin-top:0;">Buy by Category</h1>

    <form action="${pageContext.request.contextPath}/filterproducts" method="get"
          style="margin-bottom:20px; display:flex; gap:10px; flex-wrap:wrap;">
        <select name="specification" style="padding:11px 14px; border:1.5px solid var(--border); border-radius:9px;">
            <option value="">All categories</option>
            <option value="Vegetables" ${selectedSpecification == 'Vegetables' ? 'selected' : ''}>Vegetables</option>
            <option value="Dairy Products" ${selectedSpecification == 'Dairy Products' ? 'selected' : ''}>Dairy Products</option>
            <option value="Value Added Products" ${selectedSpecification == 'Value Added Products' ? 'selected' : ''}>Value Added Products</option>
            <option value="Hand loom Products" ${selectedSpecification == 'Hand loom Products' ? 'selected' : ''}>Hand loom Products</option>
            <option value="Organic Waste" ${selectedSpecification == 'Organic Waste' ? 'selected' : ''}>Organic Waste</option>
        </select>
        <button type="submit" class="btn">Filter</button>
    </form>

    <c:if test="${not empty message}"><div class="fg-alert ok">${message}</div></c:if>
    <%@ include file="_userproductgrid.jsp" %>
</div>
</body>
</html>
