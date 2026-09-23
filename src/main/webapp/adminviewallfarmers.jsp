<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ADMIN | VIEW ALL FARMERS</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #F5F5F7;
    }

    h2 {
        text-align: center;
        color: #705C53;
        margin: 20px 0;
    }

    .card-container {
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        gap: 20px;
        padding: 20px;
    }

    .card {
        background-color: #FFFFFF;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        border-radius: 10px;
        display: flex;
        width: 31%; /* Two cards per row */
        max-width: 600px;
        overflow: hidden;
    }

    .card img {
        width: 40%;
        height: auto;
        object-fit: cover;
    }

    .card-content {
        padding: 15px;
        width: 60%;
        display: flex;
        flex-direction: column;
        justify-content: center;
    }

    .card h4 {
        color: #705C53;
        margin: 10px 0;
    }

    .card p {
        color: #B7B7B7;
        margin: 5px 0;
        font-size: 14px;
    }

    .card .state {
        font-weight: bold;
        color: #705C53;
        margin-top: 10px;
    }

    .main-content {
        margin-top: 60px; /* Adjust for fixed navbar height */
    }
</style>
</head>
<body>
    <%@ include file="adminnavbar.jsp" %>
    <div class="main-content">
        <h2>View All Farmers</h2>
        <div class="card-container">
            <c:forEach items="${farmerslist}" var="farmer">
                <div class="card">
                    <c:choose>
                        <c:when test="${not empty farmer.image}">
                            <img src="${farmer.image}" alt="Farmer Image" />
                        </c:when>
                        <c:otherwise>
                            <img src="no-image-available.png" alt="No Image Available" />
                        </c:otherwise>
                    </c:choose>
                    <div class="card-content">
                        <h4><c:out value="${farmer.name}" /></h4>
                        <p>Phone: <c:out value="${farmer.phone}" /></p>
                        <p>Username: <c:out value="${farmer.username}" /></p>
                        <p>Address: <c:out value="${farmer.address}" /></p>
                        <p class="state">State: <c:out value="${farmer.state}" /></p>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>
