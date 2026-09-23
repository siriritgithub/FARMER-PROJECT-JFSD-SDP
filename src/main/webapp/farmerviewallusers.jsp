<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri = "jakarta.tags.core" prefix = "c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FARMER | VIEW ALL USERS</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #F5F5F7; /* Light background */
    }

    h3 {
        text-align: center;
        color: #705C53; /* Heading color */
        margin-top: 20px;
    }

    /* Ensure content starts after the navbar */
    .main-content {
        margin-left: 250px; /* Matches navbar width */
        padding: 20px;
    }

    table {
        width: 80%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #FFFFFF; /* Table background */
        box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1); /* Subtle shadow */
    }

    th, td {
        padding: 15px;
        text-align: left;
        border: 1px solid #B7B7B7; /* Border color */
    }

    th {
        background-color: #705C53; /* Header background */
        color: white; /* Header text */
        font-weight: bold;
    }

    td {
        color: #705C53; /* Cell text */
    }

    /* Zebra striping for rows */
    tr:nth-child(even) {
        background-color: #EDDDE0; /* Light row background */
    }

    tr:hover {
        background-color: #B7B7B7; /* Hover effect */
        color: white; /* Hover text */
    }
</style>
</head>
<body>
    <%@ include file="farmernavbar.jsp" %>
    <div class="main-content">
        <h3>View All Users</h3>
        <table>
            <tr>
                <th>ID</th>
                <th>NAME</th>
                <th>PHONE</th>
                <th>USERNAME</th>
                <th>ADDRESS</th>
                <th>STATE</th>
            </tr>
            <c:forEach items="${userlist}" var="user">
                <tr>
                    <td><c:out value="${user.id}"></c:out></td>
                    <td><c:out value="${user.name}"></c:out></td>
                    <td><c:out value="${user.phone}"></c:out></td>
                    <td><c:out value="${user.username}"></c:out></td>
                    <td><c:out value="${user.address}"></c:out></td>
                    <td><c:out value="${user.state}"></c:out></td>
                </tr>
            </c:forEach>
        </table>
    </div>
</body>
</html>
