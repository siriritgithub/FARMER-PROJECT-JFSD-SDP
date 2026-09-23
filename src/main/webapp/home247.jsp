<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Help - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<section class="fg-hero" style="padding:60px 24px 80px;">
    <div class="inner">
        <h1 style="font-size:2.1rem;">We're Here to Help</h1>
        <p>Reach out any time on your favorite platform, or use the contact form below.</p>
    </div>
</section>

<section class="fg-section">
    <div class="fg-grid" style="max-width:640px; margin:0 auto;">
        <a class="fg-card" href="https://instagram.com" target="_blank" rel="noopener">
            <div class="icon">&#128247;</div><h3>Instagram</h3>
        </a>
        <a class="fg-card" href="https://wa.me" target="_blank" rel="noopener">
            <div class="icon">&#128241;</div><h3>WhatsApp</h3>
        </a>
        <a class="fg-card" href="${pageContext.request.contextPath}/feedbackus">
            <div class="icon">&#128231;</div><h3>Contact Form</h3>
        </a>
    </div>
</section>

<footer class="fg-footer">&copy; FarmGo &mdash; Farmer Management System</footer>
</body>
</html>
