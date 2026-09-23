<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="adminnavbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <%@ include file="_pagestyle.jsp" %>
    <style>
        .stats { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
                 gap: 16px; margin-bottom: 24px; }
        .stat { background: var(--card); border: 1px solid var(--border);
                border-radius: 12px; padding: 20px; }
        .stat .label { font-size: 13px; color: var(--muted); text-transform: uppercase;
                       letter-spacing: .04em; }
        .stat .value { font-size: 30px; font-weight: 700; color: var(--green); margin-top: 6px; }
        .charts { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 20px; }
        .chart-box { background: var(--card); border: 1px solid var(--border);
                     border-radius: 12px; padding: 20px; }
    </style>
</head>
<body>
<div class="page">
    <h1>Platform Analytics</h1>

    <%-- Every figure below comes from a live count or SUM() over the database.
         The previous version of this page hardcoded all of them
         (50 farmers, 234 positive feedbacks, 765456 income in Q4, and so on). --%>
    <div class="stats">
        <div class="stat"><div class="label">Farmers</div><div class="value">${farmersCount}</div></div>
        <div class="stat"><div class="label">Users</div><div class="value">${usersCount}</div></div>
        <div class="stat"><div class="label">Products</div><div class="value">${productsCount}</div></div>
        <div class="stat"><div class="label">Orders</div><div class="value">${ordersCount}</div></div>
        <div class="stat"><div class="label">Feedback</div><div class="value">${feedbackCount}</div></div>
        <div class="stat"><div class="label">Total Income</div><div class="value">Rs. ${income}</div></div>
    </div>

    <div class="charts">
        <div class="chart-box">
            <h3>Platform composition</h3>
            <canvas id="compositionChart"></canvas>
        </div>
        <div class="chart-box">
            <h3>Revenue by recent orders</h3>
            <canvas id="incomeChart"></canvas>
        </div>
    </div>

    <div class="card" style="margin-top:24px;">
        <h2>Recent orders</h2>
        <c:choose>
            <c:when test="${empty recentOrders}">
                <div class="empty">No orders have been placed yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Reference</th><th>Product</th><th>Qty</th>
                        <th>Total</th><th>Status</th><th>Date</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${recentOrders}" end="19">
                        <tr>
                            <td>${o.reference}</td>
                            <td>${o.productName}</td>
                            <td>${o.quantity}</td>
                            <td>Rs. ${o.totalAmount}</td>
                            <td><span class="badge done">${o.status}</span></td>
                            <td>${o.orderDate}</td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<script>
    new Chart(document.getElementById('compositionChart'), {
        type: 'doughnut',
        data: {
            labels: ['Farmers', 'Users', 'Products', 'Orders'],
            datasets: [{
                data: [${farmersCount}, ${usersCount}, ${productsCount}, ${ordersCount}],
                backgroundColor: ['#4CAF50', '#2196F3', '#FF9800', '#9C27B0']
            }]
        },
        options: { responsive: true }
    });

    var orderLabels = [<c:forEach var="o" items="${recentOrders}" end="9" varStatus="st">'${o.reference}'<c:if test="${!st.last}">,</c:if></c:forEach>];
    var orderTotals = [<c:forEach var="o" items="${recentOrders}" end="9" varStatus="st">${o.totalAmount}<c:if test="${!st.last}">,</c:if></c:forEach>];

    new Chart(document.getElementById('incomeChart'), {
        type: 'bar',
        data: {
            labels: orderLabels,
            datasets: [{
                label: 'Order total (Rs.)',
                data: orderTotals,
                backgroundColor: 'rgba(76, 175, 80, 0.6)',
                borderColor: '#2e7d32',
                borderWidth: 1
            }]
        },
        options: { responsive: true, scales: { y: { beginAtZero: true } } }
    });
</script>

<div class="page" style="margin-top:0;">
    <div class="card">
        <h2>Top Products by Revenue</h2>
        <c:choose>
            <c:when test="${empty platform.topProductsByRevenue}">
                <div class="empty">No orders yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>Product</th><th>Qty Sold</th><th>Revenue</th></tr></thead>
                    <tbody>
                    <c:forEach var="p" items="${platform.topProductsByRevenue}">
                        <tr><td>${p.label}</td><td>${p.quantity}</td><td>Rs. ${p.revenue}</td></tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="charts" style="margin-top:24px;">
        <div class="chart-box">
            <h3>Farmers by State</h3>
            <c:forEach var="s" items="${platform.farmersByState}">
                <div style="display:flex; justify-content:space-between; padding:6px 0; border-bottom:1px solid var(--border); font-size:.9rem;">
                    <span>${s.label}</span><span><b>${s.count}</b> (${s.percent}%)</span>
                </div>
            </c:forEach>
        </div>
        <div class="chart-box">
            <h3>Users by State</h3>
            <c:forEach var="s" items="${platform.usersByState}">
                <div style="display:flex; justify-content:space-between; padding:6px 0; border-bottom:1px solid var(--border); font-size:.9rem;">
                    <span>${s.label}</span><span><b>${s.count}</b> (${s.percent}%)</span>
                </div>
            </c:forEach>
        </div>
    </div>

    <div class="card" style="margin-top:24px;">
        <h2>Alerts</h2>
        <c:if test="${pendingFarmers > 0}">
            <div class="alert err" style="background:#fff3e0; color:#e65100; border-color:#ffe0b2;">
                &#128992; ${pendingFarmers} farmer(s) awaiting approval
            </div>
        </c:if>
        <c:if test="${pendingUsers > 0}">
            <div class="alert err" style="background:#fff3e0; color:#e65100; border-color:#ffe0b2;">
                &#128992; ${pendingUsers} user(s) awaiting approval
            </div>
        </c:if>
        <c:if test="${pendingFeedback > 0}">
            <div class="alert err" style="background:#e3f2fd; color:#0d47a1; border-color:#bbdefb;">
                &#128309; ${pendingFeedback} feedback message(s) awaiting reply
            </div>
        </c:if>
        <c:if test="${pendingFarmers == 0 && pendingUsers == 0 && pendingFeedback == 0}">
            <div class="alert ok">&#9989; Nothing pending &mdash; you're all caught up.</div>
        </c:if>
    </div>
</div>
</body>
</html>
