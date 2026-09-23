<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Products - FarmGo Admin</title>
    <%@ include file="_theme.jsp" %>
    <%@ include file="_productcard.jsp" %>
</head>
<body>
<%@ include file="adminnavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">All Products</h1>
    <p style="color:var(--muted); margin-top:-6px;">Every product listed across the platform.</p>

    <c:if test="${not empty message}">
        <div class="fg-alert ok">${message}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty productslist}">
            <div class="pc-empty">
                <div class="icon">&#127807;</div>
                <h3>No products listed yet</h3>
            </div>
        </c:when>
        <c:otherwise>
            <div class="pc-toolbar" style="margin-top:20px;">
                <input type="text" id="pc-search" oninput="pcFilter()" placeholder="Search by name, type, location or farmer contact...">
            </div>
            <div id="pc-no-results" class="pc-empty" style="display:none;">No products match your search.</div>

            <div class="pc-grid">
                <c:forEach var="product" items="${productslist}">
                    <div class="pc-card"
                         data-search="${product.name} ${product.type} ${product.specification} ${product.location} ${product.contact}">
                        <c:choose>
                            <c:when test="${not empty product.image}">
                                <img class="pc-image" src="${product.image}" alt="${product.name}">
                            </c:when>
                            <c:otherwise>
                                <div class="pc-image placeholder">&#127807;</div>
                            </c:otherwise>
                        </c:choose>
                        <div class="pc-body">
                            <div class="pc-top">
                                <h3 class="pc-name">${product.name}</h3>
                                <c:choose>
                                    <c:when test="${product.request == 1}">
                                        <span class="pc-badge in-stock">Listed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="pc-badge pending">Pending</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="pc-tagline">${product.type} &middot; ${product.specification}</p>
                            <div class="pc-meta">
                                <div class="pc-meta-item"><span class="k">Price</span><span class="v">${product.displayPrice}</span></div>
                                <div class="pc-meta-item"><span class="k">Quantity</span><span class="v">${product.displayQuantity}</span></div>
                                <div class="pc-meta-item"><span class="k">Location</span><span class="v">${product.location}</span></div>
                                <div class="pc-meta-item"><span class="k">Contact</span><span class="v">${product.contact}</span></div>
                                <div class="pc-meta-item"><span class="k">Date</span><span class="v">${product.date}</span></div>
                                <div class="pc-meta-item"><span class="k">Farmer ID</span><span class="v">#${product.farmerId}</span></div>
                            </div>
                            <div class="pc-actions">
                                <form action="${pageContext.request.contextPath}/admindeleteproduct" method="post">
                                    <input type="hidden" name="id" value="${product.id}">
                                    <button type="submit" class="pc-btn danger"
                                            onclick="return confirm('Remove this listing from the platform?')">Remove Listing</button>
                                </form>
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
