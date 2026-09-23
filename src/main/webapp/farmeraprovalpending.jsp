<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Approval Pending - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<div class="fg-auth-wrap">
    <div class="fg-auth-card" style="text-align:center;">
        <div class="icon-badge">&#8987;</div>
        <h2>Approval Pending</h2>
        <p class="sub">Your farmer account is pending admin approval. Please check back shortly.</p>
        <p style="font-size:.9rem; color:var(--muted);">
            Questions? <a href="mailto:deepak.yaramala@gmail.com" style="color:var(--brand); font-weight:600;">Contact support</a>
        </p>
        <a href="${pageContext.request.contextPath}/home" class="btn secondary block">Back to Home</a>
    </div>
</div>
</body>
</html>
