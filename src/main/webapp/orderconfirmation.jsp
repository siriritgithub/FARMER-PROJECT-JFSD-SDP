<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order Confirmation</title>
    <%@ include file="_pagestyle.jsp" %>
</head>
<body>
<div class="page" style="max-width:640px;">
    <div class="card" style="text-align:center;">

        <c:choose>
            <c:when test="${not empty order}">
                <div style="font-size:52px; line-height:1;">&#10003;</div>
                <h2>Your order is confirmed</h2>

                <%-- These values come from the saved database row, not from a
                     random number generated in the browser. --%>
                <table style="text-align:left; margin-top:24px;">
                    <tr><th>Order reference</th><td><b>${order.reference}</b></td></tr>
                    <tr><th>Item</th><td>${order.productName}</td></tr>
                    <tr><th>Unit price</th><td>Rs. ${order.price}/${order.unit}</td></tr>
                    <tr><th>Quantity</th><td>${order.quantity} ${order.unit}</td></tr>
                    <tr><th>Total paid</th><td><b>Rs. ${order.totalAmount}</b></td></tr>
                    <tr><th>Status</th><td><span class="badge done">${order.status}</span></td></tr>
                    <tr>
                        <th>Placed on</th>
                        <td>${order.orderDate}</td>
                    </tr>
                </table>

                <p style="margin-top:24px; color:var(--muted);">
                    A confirmation email has been sent if an address is on your account.
                </p>

                <p>
                    <a class="btn" href="${pageContext.request.contextPath}/myorders">View my orders</a>
                    <a class="btn secondary" href="${pageContext.request.contextPath}/userbuyproducts">Keep shopping</a>
                </p>
            </c:when>

            <c:otherwise>
                <h2>No order to show</h2>
                <p style="color:var(--muted);">
                    This page is shown after you place an order. Open it from your cart.
                </p>
                <a class="btn" href="${pageContext.request.contextPath}/userbuyproducts">Browse products</a>
            </c:otherwise>
        </c:choose>

    </div>
</div>
</body>
</html>
