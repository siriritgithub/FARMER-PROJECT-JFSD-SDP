<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Products - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <%@ include file="_productcard.jsp" %>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>

<div class="fg-main">
    <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:12px;">
        <div>
            <h1 style="margin:0;">My Products</h1>
            <p style="color:var(--muted); margin:4px 0 0;">Manage and view all your listed products.</p>
        </div>
        <a href="${pageContext.request.contextPath}/farmeraddproduct" class="btn">+ Add New Product</a>
    </div>

    <c:if test="${not empty message}">
        <div class="fg-alert ok" style="margin-top:18px;">${message}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty products}">
            <div class="pc-empty">
                <div class="icon">&#127807;</div>
                <h3>You haven't listed any products yet</h3>
                <a href="${pageContext.request.contextPath}/farmeraddproduct" class="btn">Add your first product</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="pc-toolbar" style="margin-top:20px;">
                <input type="text" id="pc-search" oninput="pcFilter()" placeholder="Search your products by name or type...">
            </div>
            <div id="pc-no-results" class="pc-empty" style="display:none;">No products match your search.</div>

            <div class="pc-grid">
                <c:forEach var="product" items="${products}">
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
                            <div class="pc-top">
                                <h3 class="pc-name">${product.name}</h3>
                                <c:choose>
                                    <c:when test="${product.request == 1}">
                                        <span class="pc-badge in-stock">Listed</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="pc-badge pending">Pending Review</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <p class="pc-tagline">${product.description}</p>
                            <div class="pc-meta">
                                <div class="pc-meta-item"><span class="k">Type</span><span class="v">${product.type}</span></div>
                                <div class="pc-meta-item"><span class="k">Price</span><span class="v">${product.displayPrice}</span></div>
                                <div class="pc-meta-item"><span class="k">Location</span><span class="v">${product.location}</span></div>
                                <div class="pc-meta-item"><span class="k">Quantity</span><span class="v">${product.displayQuantity}</span></div>
                                <div class="pc-meta-item"><span class="k">Date Added</span><span class="v">${product.date}</span></div>
                                <div class="pc-meta-item"><span class="k">Category</span><span class="v">${product.specification}</span></div>
                            </div>
                            <div class="pc-actions">
                                <a href="${pageContext.request.contextPath}/farmerupdateproduct" class="pc-btn">Update</a>
                                <form action="${pageContext.request.contextPath}/deleteproduct" method="post">
                                    <input type="hidden" name="id" value="${product.id}">
                                    <button type="submit" class="pc-btn danger"
                                            onclick="return confirm('Delete this product?')">Delete</button>
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
