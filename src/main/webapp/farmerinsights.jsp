<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Farm Insights - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <style>
        .ins-section { margin-bottom: 32px; }
        .ins-section h2 { font-size: 1.15rem; margin-bottom: 14px; }
        .bar-row { display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
        .bar-label { width: 190px; font-size: .85rem; flex-shrink: 0; }
        .bar-track { flex: 1; background: #eef2ec; border-radius: 999px; height: 18px; overflow: hidden; }
        .bar-fill { background: var(--brand-light); height: 100%; border-radius: 999px; }
        .bar-value { width: 70px; text-align: right; font-size: .82rem; font-weight: 700; flex-shrink: 0; }
        .insight-box { background: linear-gradient(135deg, #eef7ee, #e3f0e3); border: 1px solid #cfe4cf;
                       border-radius: var(--radius); padding: 18px 20px; }
        .alert-row { padding: 10px 14px; background: #fff3e0; border-radius: 8px; font-size: .88rem; margin-bottom: 8px; }
    </style>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">My Farm Insights</h1>
    <p style="color:var(--muted); margin-top:-6px;">Real numbers from your listings and orders &mdash; nothing here is a sample.</p>

    <div class="fg-stats">
        <div class="fg-stat"><div class="label">Products Listed</div><div class="value">${analytics.totalProducts}</div></div>
        <div class="fg-stat"><div class="label">Total Orders</div><div class="value">${analytics.totalOrders}</div></div>
        <div class="fg-stat"><div class="label">Quantity Sold</div><div class="value">${analytics.totalQuantitySold}</div></div>
        <div class="fg-stat"><div class="label">Total Revenue</div><div class="value">Rs. ${analytics.totalRevenue}</div></div>
    </div>

    <c:choose>
    <c:when test="${analytics.totalOrders == 0}">
        <div class="fg-card" style="text-align:center; cursor:default;">
            <div style="font-size:2.4rem;">&#128202;</div>
            <h3>No sales yet</h3>
            <p style="color:var(--muted);">Once buyers start ordering your products, this page fills in with
               where you're selling, what's selling best, and when buyers are most active.</p>
        </div>
    </c:when>
    <c:otherwise>

        <div class="ins-section">
            <div class="insight-box">
                <b>&#128161; Smart Insight:</b>
                Your best-selling product is <b>${analytics.bestSellingProduct}</b>.
                Buyers are most active during <b>${analytics.peakSellingWindow}</b>.
                Your average order price is <b>Rs. ${analytics.averagePrice}</b>.
            </div>
        </div>

        <c:if test="${not empty analytics.lowStockAlerts}">
            <div class="ins-section">
                <h2>&#9888;&#65039; Stock Alerts</h2>
                <c:forEach var="alert" items="${analytics.lowStockAlerts}">
                    <div class="alert-row">${alert}</div>
                </c:forEach>
            </div>
        </c:if>

        <div class="ins-section fg-card" style="cursor:default;">
            <h2>Where Are My Products Selling?</h2>
            <c:forEach var="loc" items="${analytics.salesByLocation}">
                <div class="bar-row">
                    <div class="bar-label">${loc.label}</div>
                    <div class="bar-track"><div class="bar-fill" style="width:${loc.percent}%;"></div></div>
                    <div class="bar-value">${loc.percent}%</div>
                </div>
            </c:forEach>
        </div>

        <div class="ins-section fg-card" style="cursor:default;">
            <h2>Product Performance</h2>
            <table style="width:100%; border-collapse:collapse;">
                <thead>
                    <tr style="text-align:left; border-bottom:2px solid var(--border);">
                        <th style="padding:8px;">Product</th><th style="padding:8px;">Qty Sold</th><th style="padding:8px;">Revenue</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${analytics.productPerformance}">
                    <tr style="border-bottom:1px solid var(--border);">
                        <td style="padding:8px;"><b>${p.label}</b></td>
                        <td style="padding:8px;">${p.quantity}</td>
                        <td style="padding:8px;">Rs. ${p.revenue}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            <p style="margin-top:12px; font-size:.88rem; color:var(--muted);">
                &#128293; Best seller: <b>${analytics.bestSellingProduct}</b> &nbsp;&middot;&nbsp;
                &#128202; Lowest seller: <b>${analytics.lowestSellingProduct}</b>
            </p>
        </div>

        <div class="ins-section fg-card" style="cursor:default;">
            <h2>When Do Buyers Order?</h2>
            <c:forEach var="t" items="${analytics.sellingTimeOfDay}">
                <div class="bar-row">
                    <div class="bar-label">${t.label}</div>
                    <div class="bar-track"><div class="bar-fill" style="width:${t.percent}%;"></div></div>
                    <div class="bar-value">${t.percent}%</div>
                </div>
            </c:forEach>
            <p style="margin-top:10px; font-size:.88rem; color:var(--muted);">
                &#128337; Peak buying window: <b>${analytics.peakSellingWindow}</b>
            </p>
        </div>

        <div class="ins-section fg-card" style="cursor:default;">
            <h2>Revenue by Month</h2>
            <c:choose>
                <c:when test="${empty analytics.monthlyRevenue}">
                    <p style="color:var(--muted);">Not enough order history yet.</p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="m" items="${analytics.monthlyRevenue}">
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

    <div class="ins-section fg-card" style="cursor:default;">
        <h2>Current Inventory</h2>
        <c:choose>
            <c:when test="${empty analytics.inventory}">
                <p style="color:var(--muted);">You have no products listed yet.</p>
            </c:when>
            <c:otherwise>
                <table style="width:100%; border-collapse:collapse;">
                    <thead>
                        <tr style="text-align:left; border-bottom:2px solid var(--border);">
                            <th style="padding:8px;">Product</th><th style="padding:8px;">Remaining Stock</th>
                        </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="i" items="${analytics.inventory}">
                        <tr style="border-bottom:1px solid var(--border);">
                            <td style="padding:8px;">${i.label}</td>
                            <td style="padding:8px;">${i.quantity}</td>
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
