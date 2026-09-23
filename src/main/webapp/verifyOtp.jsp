<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Verify reset code</title>
    <%@ include file="_pagestyle.jsp" %>
</head>
<body>
<div class="page" style="max-width:480px;">
    <div class="card">
        <h2>Enter your reset code</h2>

        <c:if test="${not empty message}"><div class="alert ok">${message}</div></c:if>
        <c:if test="${not empty error}"><div class="alert err">${error}</div></c:if>

        <c:set var="action" value="${role eq 'user' ? '/user/verifyOtp' : '/verifyOtp'}" />
        <form action="${pageContext.request.contextPath}${action}" method="post">
            <label for="code">6-digit code</label>
            <input type="text" id="code" name="code" required
                   pattern="[0-9]{6}" maxlength="6" inputmode="numeric"
                   autocomplete="one-time-code" placeholder="000000">
            <p style="color:var(--muted); font-size:14px;">
                The code expires in 10 minutes. Check your spam folder if it has not arrived.
            </p>
            <button class="btn" type="submit">Verify</button>
        </form>

        <p style="margin-top:20px;">
            <c:choose>
                <c:when test="${role eq 'user'}">
                    <a href="${pageContext.request.contextPath}/user/forgetpassword">Start over</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/forgetpassword">Start over</a>
                </c:otherwise>
            </c:choose>
        </p>
    </div>
</div>
</body>
</html>
