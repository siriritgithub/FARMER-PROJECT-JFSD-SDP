<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Insights - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <style>
        .bar-row { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
        .bar-label { width: 190px; font-size: .85rem; flex-shrink: 0; }
        .bar-track { flex: 1; background: #eef2ec; border-radius: 999px; height: 18px; overflow: hidden; }
        .bar-fill { background: var(--accent); height: 100%; border-radius: 999px; }
        .bar-value { width: 70px; text-align: right; font-size: .82rem; font-weight: 700; flex-shrink: 0; }
        .insight-box { background: linear-gradient(135deg, #eef7ee, #e3f0e3); border: 1px solid #cfe4cf;
                       border-radius: var(--radius); padding: 18px 20px; margin-bottom: 24px; }
    </style>
</head>
<body>
<%@ include file="usernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">My Insights</h1>
    <p style="color:var(--muted); margin-top:-6px;">A look at your buying activity on FarmGo.</p>

    <div class="fg-stats">
        <div class="fg-stat"><div class="label">Total Orders</div><div class="value">${analytics.totalOrders}</div></div>
        <div class="fg-stat"><div class="label">Total Spent</div><div class="value">Rs. ${analytics.totalSpent}</div></div>
        <div class="fg-stat"><div class="label">Avg Order Value</div><div class="value">Rs. ${analytics.averageOrderValue}</div></div>
    </div>

    <c:choose>
    <c:when test="${analytics.totalOrders == 0}">
        <div class="fg-card" style="text-align:center; cursor:default;">
            <div style="font-size:2.4rem;">&#128722;</div>
            <h3>No orders yet</h3>
            <p style="color:var(--muted);">Once you place a few orders, this page shows your favorite
               products, farmers and spending patterns.</p>
            <a href="${pageContext.request.contextPath}/userbuyproducts" class="btn">Browse products</a>
        </div>
    </c:when>
    <c:otherwise>

        <div class="insight-box">
            <b>&#128161; Buying Insight:</b>
            Your most-purchased product is <b>${analytics.topProducts[0].label}</b>.
            You buy most often from <b>${analytics.favoriteFarmerName}</b>
            (${analytics.favoriteFarmerOrders} order<c:if test="${analytics.favoriteFarmerOrders != 1}">s</c:if>).
        </div>

        <div class="fg-card" style="cursor:default; margin-bottom:24px;">
            <h2 style="font-size:1.1rem;">Top Products You've Bought</h2>
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                    <tr style="text-align:left; border-bottom:2px solid var(--border);">
                        <th style="padding:8px;">Product</th><th style="padding:8px;">Quantity Purchased</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${analytics.topProducts}">
                    <tr style="border-bottom:1px solid var(--border);">
                        <td style="padding:8px;"><b>${p.label}</b></td>
                        <td style="padding:8px;">${p.quantity}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="fg-card" style="cursor:default; margin-bottom:24px;">
            <h2 style="font-size:1.1rem;">Where Your Money Goes</h2>
            <c:forEach var="c" items="${analytics.spendingByCategory}">
                <div class="bar-row">
                    <div class="bar-label">${c.label}</div>
                    <div class="bar-track"><div class="bar-fill" style="width:${c.percent}%;"></div></div>
                    <div class="bar-value">${c.percent}%</div>
                </div>
            </c:forEach>
        </div>

        <div class="fg-card" style="cursor:default;">
            <h2 style="font-size:1.1rem;">Monthly Spending</h2>
            <c:choose>
                <c:when test="${empty analytics.monthlySpend}">
                    <p style="color:var(--muted);">Not enough order history yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="m" items="${analytics.monthlySpend}">
                        <div class="bar-row">
                            <div class="bar-label">${m.month}</div>
                            <div style="font-weight:700;">Rs. ${m.amount}</div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

    </c:otherwise>
    </c:choose>
</div>
</body>
</html>
