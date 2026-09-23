<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="adminnavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">Welcome back, <c:out value="${admin.name}" /></h1>
    <p style="color:var(--muted); margin-top:-6px;">Here's what needs your attention.</p>

    <div class="fg-stats">
        <div class="fg-stat">
            <div class="label">Pending Farmers</div>
            <div class="value">${pendingFarmers}</div>
        </div>
        <div class="fg-stat">
            <div class="label">Pending Users</div>
            <div class="value">${pendingUsers}</div>
        </div>
        <div class="fg-stat">
            <div class="label">Open Feedback</div>
            <div class="value">${pendingFeedback}</div>
        </div>
    </div>

    <h2 style="font-size:1.2rem;">Quick actions</h2>
    <div class="fg-grid">
        <a class="fg-card" href="${pageContext.request.contextPath}/adminapprovefarmers">
            <div class="icon">&#9989;</div><h3>Approve Farmers</h3>
            <p>Review and approve pending farmer registrations.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/adminapproveusers">
            <div class="icon">&#9989;</div><h3>Approve Users</h3>
            <p>Review and approve pending user registrations.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/adminviewfeedbacks">
            <div class="icon">&#128231;</div><h3>Feedback Inbox</h3>
            <p>Read and reply to messages from farmers and users.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/admin/dashboard">
            <div class="icon">&#128200;</div><h3>Analytics</h3>
            <p>Platform-wide stats and revenue.</p>
        </a>
    </div>
</div>
</body>
</html>
