<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PRO'FX - Forgot Password</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #F5F5F7;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .header {
            width: 100%;
            position: fixed;
            top: 0;
            z-index: 1000;
        }

        .content {
            margin-top: 120px; /* Adjust to ensure proper spacing below the fixed header */
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            height: calc(100vh - 120px);
        }

        .container {
            display: flex;
            flex-direction: row;
            background-color: #FFFFFF;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }

        .left-section {
            flex: 1;
            background-color: #EDDDE0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .left-section img {
            max-width: 100%;
            height: auto;
        }

        .right-section {
            flex: 1;
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .right-section h1 {
            color: #705C53;
            margin-bottom: 20px;
        }

        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            margin-bottom: 5px;
            color: #B7B7B7;
        }

        .input-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #B7B7B7;
            border-radius: 4px;
        }

        .reset-button {
            background-color: #705C53;
            color: #FFFFFF;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .reset-button:hover {
            background-color: #B7B7B7;
        }

        .signin-link {
            margin-top: 20px;
            color: #705C53;
            text-decoration: none;
            display: inline-block;
        }

        .signin-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .left-section, .right-section {
                flex: none;
                width: 100%;
            }

            .right-section {
                padding: 20px;
            }
        }
        /* Styling for the form inputs and submit button */
.form-group {
    margin-bottom: 20px;
}

.form-group label {
    display: block;
    margin-bottom: 5px;
    color: #B7B7B7;
    font-size: 14px;
}

.form-group input {
    width: 100%;
    padding: 10px;
    border: 1px solid #B7B7B7;
    border-radius: 4px;
    font-size: 14px;
    color: #333;
}

.submit-button {
    background-color: #705C53;
    color: #FFFFFF;
    padding: 10px 20px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    width: 106%;
    transition: background-color 0.3s;
}

.submit-button:hover {
    background-color: #B7B7B7;
}

/* Error message styling */
.error-message {
    color: red;
    font-size: 14px;
    margin-top: 10px;
}

/* Back to Sign In link */
.signin-link {
    margin-top: 20px;
    color: #705C53;
    text-decoration: none;
    font-size: 14px;
    display: inline-block;
}

.signin-link:hover {
    text-decoration: underline;
}
        .left-section img {
    width: 100%;
    height: 100%;
    object-fit: cover; /* Ensures the image covers the container while maintaining aspect ratio */
}
    </style>
</head>
<body>
    <div class="header">
        <%@ include file="demoheader.jsp" %>
    </div>
   
    <div class="content">
        <div class="container">
            <div class="left-section">
                <img src="https://i.imghippo.com/files/yBN2638ixk.png" alt="Farming Management System">
            </div>
            <div class="right-section">
                <h1>Forgot Your Password?</h1>
                 <div class="checklogin">
                <c:if test="${not empty message}">
                    <p class="error-message"><c:out value="${message}" /></p>
                </c:if>
            </div>
                <form action="${pageContext.request.contextPath}/validateUser" method="POST">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                <div class="form-group">
                    <label for="email">Registered Email</label>
                    <input type="email" id="email" name="email" required placeholder="you@example.com">
                </div>
                <button type="submit" class="submit-button">Submit</button>
            </form>
                <a href="login" class="signin-link">Back to Sign In</a>
            </div>
        </div>
    </div>
</body>
</html>
