<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Set Password</title>
    <link rel="stylesheet" href="styles.css">
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
            padding: 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .left-section h1 {
            color: #705C53;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #B7B7B7;
        }

        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #B7B7B7;
            border-radius: 4px;
        }

        .submit-button {
            background-color: #705C53;
            color: #FFFFFF;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .submit-button:hover {
            background-color: #B7B7B7;
        }

        .right-section {
            flex: 1;
            background: url('https://th.bing.com/th/id/OIP.7r81Iygh6k_nbAtev6b4MgHaF1?rs=1&pid=ImgDetMain') no-repeat center center;
            background-size: cover;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .left-section, .right-section {
                flex: none;
                width: 100%;
            }

            .left-section {
                padding: 20px;
            }
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
                <h1>Set Your Password</h1>
                <form action="${pageContext.request.contextPath}/user/updatePassword" method="POST">
                    <input type="hidden" name="username" value="${username}">
                    <div class="form-group">
                        <label for="newPassword">New Password</label>
                        <input type="password" id="newPassword" name="newPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirm Password</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                    </div>
                    <button type="submit" class="submit-button">Set Password</button>
                </form>
            </div>
            <div class="right-section"></div>
        </div>
    </div>
</body>
</html>
