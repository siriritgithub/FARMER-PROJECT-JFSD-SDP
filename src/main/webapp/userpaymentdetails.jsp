<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Details - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="usernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">Payment Details</h1>
    <p style="color:var(--muted); margin-top:-6px;">
        FarmGo does not process real payments yet &mdash; orders are confirmed directly.
        This page shows your order history and total spend.
    </p>

    <div class="fg-stats" style="max-width:320px;">
        <div class="fg-stat">
            <div class="label">Total Spent</div>
            <div class="value">Rs. ${totalSpent}</div>
        </div>
    </div>

    <div class="fg-card" style="cursor:default; text-align:left;">
        <h3 style="margin-top:0;">Order History</h3>

        <c:choose>
            <c:when test="${empty orders}">
                <p style="color:var(--muted);">You have not placed any orders yet.</p>
                <a href="${pageContext.request.contextPath}/userbuyproducts" class="btn">Browse products</a>
            </c:when>
            <c:otherwise>
                <table style="width:100%; border-collapse:collapse; margin-top:12px;">
                    <thead>
                        <tr style="text-align:left; border-bottom:2px solid var(--border);">
                            <th style="padding:10px 8px;">Reference</th>
                            <th style="padding:10px 8px;">Product</th>
                            <th style="padding:10px 8px;">Qty</th>
                            <th style="padding:10px 8px;">Total</th>
                            <th style="padding:10px 8px;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr style="border-bottom:1px solid var(--border);">
                                <td style="padding:10px 8px;"><b>${order.reference}</b></td>
                                <td style="padding:10px 8px;">${order.productName}</td>
                                <td style="padding:10px 8px;">${order.quantity} ${order.unit}</td>
                                <td style="padding:10px 8px;">Rs. ${order.totalAmount}</td>
                                <td style="padding:10px 8px;">
                                    <span class="badge done" style="padding:4px 10px; border-radius:999px;
                                          background:#e8f5e9; color:#1b5e20; font-size:.78rem; font-weight:600;">
                                        ${order.status}
                                    </span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
