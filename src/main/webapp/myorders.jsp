<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="usernavbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Orders</title>
    <%@ include file="_pagestyle.jsp" %>
</head>
<body>
<div class="page">
    <div class="card">
        <h2>My Orders</h2>

        <c:if test="${not empty message}"><div class="alert ok">${message}</div></c:if>

        <c:choose>
            <c:when test="${empty orders}">
                <div class="empty">
                    <p>You have not placed any orders yet.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/userbuyproducts">Browse products</a>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                    <tr>
                        <th>Reference</th>
                        <th>Product</th>
                        <th>Unit price</th>
                        <th>Qty</th>
                        <th>Total</th>
                        <th>Status</th>
                        <th>Ordered on</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${orders}">
                        <tr>
                            <td><b>${order.reference}</b></td>
                            <td>${order.productName}</td>
                            <td>Rs. ${order.price}/${order.unit}</td>
                            <td>${order.quantity} ${order.unit}</td>
                            <td><b>Rs. ${order.totalAmount}</b></td>
                            <td><span class="badge done">${order.status}</span></td>
                            <td>${order.orderDate}</td>
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
