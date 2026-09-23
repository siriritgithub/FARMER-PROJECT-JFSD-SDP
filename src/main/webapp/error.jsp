<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Something went wrong</title>
    <%@ include file="_pagestyle.jsp" %>
</head>
<body>
<div class="page">
    <div class="card" style="text-align:center;">
        <h1 style="font-size:64px; margin:0; color:var(--green-light);">
            ${not empty status ? status : 'Oops'}
        </h1>
        <h2>${not empty message ? message : 'Something went wrong.'}</h2>
        <p style="color:var(--muted);">
            <c:if test="${not empty path}">Requested path: <code>${path}</code></c:if>
        </p>
        <p>
            <a class="btn" href="${pageContext.request.contextPath}/home">Back to home</a>
            <a class="btn secondary" href="javascript:history.back()">Go back</a>
        </p>
    </div>
</div>
</body>
</html>
