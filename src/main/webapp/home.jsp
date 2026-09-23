<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FarmGo - Home</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>

<%@ include file="demoheader.jsp" %>

<section class="fg-hero">
    <div class="inner">
        <h1>Farm to table, without the middleman</h1>
        <p>FarmGo connects farmers directly with buyers — list produce, browse the
           marketplace, and manage every order in one place.</p>
        <div class="btn-row">
            <a href="${pageContext.request.contextPath}/login" class="btn accent">Farmer Login</a>
            <a href="${pageContext.request.contextPath}/userlogin" class="btn outline">User Login</a>
            <a href="${pageContext.request.contextPath}/register" class="btn outline">Register</a>
        </div>
    </div>
</section>

<section class="fg-section">
    <h2>Get started</h2>
    <p class="lead">Pick where you'd like to go.</p>
    <div class="fg-grid">
        <a class="fg-card" href="${pageContext.request.contextPath}/adminlogin">
            <div class="icon">&#128272;</div>
            <h3>Admin Login</h3>
            <p>Secure access for platform administrators.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/services">
            <div class="icon">&#127793;</div>
            <h3>Services</h3>
            <p>What FarmGo offers farmers and buyers.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/aboutus">
            <div class="icon">&#8505;&#65039;</div>
            <h3>About Us</h3>
            <p>Our mission and how FarmGo works.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/feedbackus">
            <div class="icon">&#128222;</div>
            <h3>Contact / Feedback</h3>
            <p>Reach our support team any time.</p>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/help">
            <div class="icon">&#10067;</div>
            <h3>Help &amp; FAQs</h3>
            <p>Answers to common questions.</p>
        </a>
    </div>
</section>

<section class="fg-section" style="background:#eef4ec; border-radius: var(--radius);">
    <h2>Why FarmGo</h2>
    <p class="lead">Built for the people who grow and the people who buy.</p>
    <div class="fg-grid">
        <div class="fg-card" style="cursor:default;">
            <div class="icon">&#128101;</div>
            <h3>For Farmers</h3>
            <p>List produce in minutes and reach buyers directly, no middleman.</p>
        </div>
        <div class="fg-card" style="cursor:default;">
            <div class="icon">&#128179;</div>
            <h3>Simple Ordering</h3>
            <p>Buyers browse, order and track deliveries from one dashboard.</p>
        </div>
        <div class="fg-card" style="cursor:default;">
            <div class="icon">&#128200;</div>
            <h3>Real Growth</h3>
            <p>Admin tools that support rural entrepreneurship at scale.</p>
        </div>
    </div>
</section>

<footer class="fg-footer">
    &copy; FarmGo &mdash; Farmer Management System
</footer>

</body>
</html>
