<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Wishlist - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <%@ include file="_productcard.jsp" %>
</head>
<body>
<%@ include file="usernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">My Wishlist</h1>

    <c:if test="${not empty message}">
        <div class="fg-alert ok">${message}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty lines}">
            <div class="fg-card" style="text-align:center; cursor:default;">
                <div style="font-size:2.4rem;">&#9825;</div>
                <h3>Your wishlist is empty</h3>
                <p style="color:var(--muted);">Save products here to buy them later.</p>
                <a href="${pageContext.request.contextPath}/userbuyproducts" class="btn">Browse products</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="pc-grid">
                <c:forEach var="line" items="${lines}">
                    <c:if test="${not empty line.product}">
                        <div class="pc-card">
                            <c:choose>
                                <c:when test="${not empty line.product.image}">
                                    <img class="pc-image" src="${line.product.image}" alt="${line.product.name}">
                                </c:when>
                                <c:otherwise>
                                    <div class="pc-image placeholder">&#127807;</div>
                                </c:otherwise>
                            </c:choose>
                            <div class="pc-body">
                                <h3 class="pc-name">${line.product.name}</h3>
                                <p class="pc-tagline">${line.product.type}</p>
                                <div class="pc-meta">
                                    <div class="pc-meta-item"><span class="k">Price</span><span class="v">${line.product.displayPrice}</span></div>
                                    <div class="pc-meta-item"><span class="k">Available</span><span class="v">${line.product.displayQuantity}</span></div>
                                </div>
                                <div class="pc-actions">
                                    <form action="${pageContext.request.contextPath}/wishlist/move-to-cart" method="post">
                                        <input type="hidden" name="productId" value="${line.product.id}">
                                        <button type="submit" class="pc-btn primary">Add to Cart</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/wishlist/remove" method="post">
                                        <input type="hidden" name="productId" value="${line.product.id}">
                                        <button type="submit" class="pc-btn danger">Remove</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
