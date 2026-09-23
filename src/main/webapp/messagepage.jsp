<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>MESSAGE | PRO'FX</title>
    <style>
        /* General Page Styles */
        body {
            font-family: 'Arial', sans-serif;
            background-color: #F5F5F7; /* Light Gray */
            color: #333333; /* Dark Gray */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        /* Main Container */
        .container {
            text-align: center;
            background-color: #FFFFFF; /* White */
            padding: 30px 50px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            max-width: 500px;
            width: 90%;
        }

        /* Heading Styles */
        h1 {
            font-size: 24px;
            color: #4CAF50; /* Success Green */
            margin-bottom: 20px;
        }

        /* Paragraph Styles */
        p {
            font-size: 18px;
            color: #555555; /* Medium Gray */
            margin-bottom: 30px;
        }

        /* Link Styles */
        a {
            display: inline-block;
            text-decoration: none;
            background-color: #4CAF50; /* Success Green */
            color: #FFFFFF; /* White */
            padding: 10px 20px;
            font-size: 16px;
            border-radius: 5px;
            transition: background-color 0.3s;
        }

        a:hover {
            background-color: #45A049; /* Darker Green */
        }
    </style>
</head>
<body>
	<%@ include file="demoheader.jsp" %>
    <div class="container">
        <h1>MESSAGE</h1>
        <p><c:out value="${message}" /></p>
        <p>Thank you for Spending Valuable time!</p>
        <a href="login.jsp">Click here to login</a>
    </div>
</body>
</html>
