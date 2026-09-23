<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - FarmGo</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="demoheader.jsp" %>

<div class="fg-auth-wrap">
    <div class="fg-auth-card" style="max-width:520px;">
        <div class="icon-badge">&#128231;</div>
        <h2>Contact / Feedback</h2>
        <p class="sub">We read every message and reply by email.</p>

        <c:if test="${not empty message}">
            <div class="fg-alert ok"><c:out value="${message}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/submitContact" method="post">
            <div class="fg-field">
                <label for="name">Your Name</label>
                <input type="text" id="name" name="name" required>
            </div>
            <div class="fg-field">
                <label for="accessor">You Are A</label>
                <select id="accessor" name="userType" required>
                    <option value="" disabled selected>Select one</option>
                    <option value="general">General Visitor</option>
                    <option value="farmer">Farmer</option>
                    <option value="user">User</option>
                </select>
            </div>
            <div class="fg-field">
                <label for="email">Your Email</label>
                <input type="email" id="email" name="email" required>
            </div>
            <div class="fg-field">
                <label for="subject">Subject</label>
                <input type="text" id="subject" name="subject" required>
            </div>
            <div class="fg-field">
                <label for="message">Message</label>
                <textarea id="message" name="message" rows="4" required></textarea>
            </div>
            <button type="submit" class="btn block">Send Message</button>
        </form>
    </div>
</div>
</body>
</html>
