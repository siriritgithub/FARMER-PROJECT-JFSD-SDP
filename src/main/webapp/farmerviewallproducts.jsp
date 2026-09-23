<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse All Products - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <%@ include file="_productcard.jsp" %>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">Browse All Products</h1>
    <p style="color:var(--muted); margin-top:-6px;">See what other farmers are listing on FarmGo.</p>

    <c:choose>
        <c:when test="${empty productslist}">
            <div class="pc-empty">
                <div class="icon">&#127807;</div>
                <h3>No products listed yet</h3>
            </div>
        </c:when>
        <c:otherwise>
            <div class="pc-toolbar" style="margin-top:20px;">
                <input type="text" id="pc-search" oninput="pcFilter()" placeholder="Search by name, type or location...">
            </div>
            <div id="pc-no-results" class="pc-empty" style="display:none;">No products match your search.</div>

            <div class="pc-grid">
                <c:forEach var="product" items="${productslist}">
                    <div class="pc-card"
                         data-search="${product.name} ${product.type} ${product.specification} ${product.location}">
                        <c:choose>
                            <c:when test="${not empty product.image}">
                                <img class="pc-image" src="${product.image}" alt="${product.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="pc-image placeholder">&#127807;</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="pc-body">
                            <h3 class="pc-name">${product.name}</h3>
                            <p class="pc-tagline">${product.description}</p>
                            <div class="pc-meta">
                                <div class="pc-meta-item"><span class="k">Type</span><span class="v">${product.type}</span></div>
                                <div class="pc-meta-item"><span class="k">Price</span><span class="v">${product.displayPrice}</span></div>
                                <div class="pc-meta-item"><span class="k">Location</span><span class="v">${product.location}</span></div>
                                <div class="pc-meta-item"><span class="k">Available</span><span class="v">${product.displayQuantity}</span></div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
