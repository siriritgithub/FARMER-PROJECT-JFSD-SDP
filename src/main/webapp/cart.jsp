<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Cart - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="usernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">My Cart</h1>

    <c:if test="${not empty message}">
        <div class="fg-alert ok">${message}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty lines}">
            <div class="fg-card" style="text-align:center; cursor:default;">
                <div style="font-size:2.4rem;">&#128722;</div>
                <h3>Your cart is empty</h3>
                <p style="color:var(--muted);">Browse the marketplace and add something fresh.</p>
                <a href="${pageContext.request.contextPath}/userbuyproducts" class="btn">Browse products</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="fg-card" style="cursor:default;">
                <table style="width:100%; border-collapse:collapse;">
                    <thead>
                        <tr style="text-align:left; border-bottom:2px solid var(--border);">
                            <th style="padding:10px 8px;">Product</th>
                            <th style="padding:10px 8px;">Unit Price</th>
                            <th style="padding:10px 8px;">Quantity</th>
                            <th style="padding:10px 8px;">Line Total</th>
                            <th style="padding:10px 8px;"></th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="line" items="${lines}">
                            <c:if test="${not empty line.product}">
                                <tr style="border-bottom:1px solid var(--border);">
                                    <td style="padding:10px 8px;"><b>${line.product.name}</b></td>
                                    <td style="padding:10px 8px;">${line.product.displayPrice}</td>
                                    <td style="padding:10px 8px;">
                                        <form action="${pageContext.request.contextPath}/cart/update"
                                              method="post" style="display:flex; gap:6px; align-items:center;">
                                            <input type="hidden" name="productId" value="${line.product.id}">
                                            <input type="number" name="quantity" value="${line.quantity}" min="1"
                                                   style="width:70px; padding:6px 8px; border:1px solid var(--border); border-radius:6px;">
                                            <button type="submit" class="pc-btn" style="width:auto; padding:6px 10px;">Update</button>
                                        </form>
                                    </td>
                                    <td style="padding:10px 8px;"><b>Rs. ${line.lineTotal}</b></td>
                                    <td style="padding:10px 8px;">
                                        <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                            <input type="hidden" name="productId" value="${line.product.id}">
                                            <button type="submit" class="pc-btn danger" style="width:auto; padding:6px 10px;">Remove</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:if>
                        </c:forEach>
                    </tbody>
                </table>

                <div style="display:flex; justify-content:flex-end; align-items:center; gap:20px; margin-top:20px;">
                    <div style="font-size:1.2rem;"><b>Total: Rs. ${cartTotal}</b></div>
                    <form action="${pageContext.request.contextPath}/cart/checkout" method="post">
                        <button type="submit" class="btn">Place Order for All Items</button>
                    </form>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
