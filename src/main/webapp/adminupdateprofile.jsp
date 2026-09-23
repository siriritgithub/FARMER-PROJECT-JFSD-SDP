<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Update Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #F5F5F7;
        }

        h3 {
            text-align: center;
            color: #705C53; 
            margin-top: 20px;
        }

        .content-container {
            align-items: center;
            margin-left: 250px;
            padding: 20px;
        }

        .form-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            max-width: 600px;
            margin: 20px auto;
            text-align: center;
        }

        .form-group {
            margin-bottom: 15px;
            text-align: left;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
        }

        .form-group input {
            width: 90%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f9f9f9;
            pointer-events: none;
        }

        .form-group input.editable {
            background-color: white;
            pointer-events: auto;
        }

        .button-container {
            text-align: right;
        }

        .edit-button, .save-button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .edit-button {
            background-color: #705C53;
            color: white;
        }

        .edit-button:hover {
            background-color: #B7B7B7;
        }

        .save-button {
            background-color: #28a745;
            color: white;
        }

        .save-button:hover {
            background-color: #218838;
        }

        .popup-container {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background-color: white;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            padding: 20px;
            border-radius: 10px;
            z-index: 10;
            text-align: center;
        }

        .popup-container input[type="password"] {
            width: 80%;
            padding: 10px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        .popup-container button {
            margin-top: 10px;
            padding: 10px 20px;
            background-color: #705C53;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .popup-container button:hover {
            background-color: #B7B7B7;
        }

        .light-red {
        padding-left :0 px;
            color: #FF7F7F;
            font-style: italic;
            font-size: 14px;
        }
    </style>
    <script>
        let isEditable = false;

        function toggleEdit() {
            const inputs = document.querySelectorAll(".form-group input");
            isEditable = !isEditable;

            inputs.forEach(input => {
                if (isEditable) {
                    input.removeAttribute("readonly");
                    input.classList.add("editable");
                } else {
                    input.setAttribute("readonly", true);
                    input.classList.remove("editable");
                }
            });

            document.getElementById("edit-button").style.display = isEditable ? "none" : "block";
            document.getElementById("save-button").style.display = isEditable ? "block" : "none";
        }

        function showPasswordPopup() {
            document.getElementById("popup-container").style.display = "block";
        }

        function hidePasswordPopup() {
            document.getElementById("popup-container").style.display = "none";
        }

        function validatePassword() {
            const password = document.getElementById("current-password").value;
            const form = document.getElementById("update-form");

            const passwordField = document.createElement("input");
            passwordField.type = "hidden";
            passwordField.name = "currentPassword";
            passwordField.value = password;
            form.appendChild(passwordField);

            form.submit();
        }
    </script>
</head>
<body>
<%@ include file="adminnavbar.jsp" %>
<div class="content-container">
    <div class="form-container">
        <c:if test="${not empty message}">
            <div id="notification" class="notification ${status}">
                ${message}
            </div>
        </c:if>
        <h2>Update Admin Profile</h2>
        <form id="update-form" action="${pageContext.request.contextPath}/updateAdminProfile" method="POST">
        	<div class="form-group">
                <label for="email">Name</label>
                <input type="text" id="name" name="name" value="${admin.name}" readonly>
            </div>
           
            <div class="form-group">
              <p class="light-red">Not preferable to change Email</p>
                <label for="email">Email</label>
                <input type="email" id="email" name="email" value="${admin.email}" readonly>
            </div>
           
            <div class="form-group">
             <p class="light-red">Not preferable to change Username</p>
                <label for="email">Username</label>
                <input type="text" id="uname" name="uname" value="${admin.username}" readonly>
            </div>
            <div class="form-group">
                <label for="new-password">New Password</label>
                <input type="password" id="new-password" name="newPassword" value="" readonly>
            </div>
            <div class="button-container">
                <button type="button" id="edit-button" class="edit-button" onclick="toggleEdit()">Edit Profile</button>
                <button type="button" id="save-button" class="save-button" style="display: none;" onclick="showPasswordPopup()">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<div class="popup-container" id="popup-container">
    <div class="popup-content">
        <p>Please enter your current password to confirm changes:</p>
        <input type="password" id="current-password" placeholder="Enter current password">
        <button onclick="validatePassword()">Submit</button>
        <button onclick="hidePasswordPopup()">Cancel</button>
    </div>
</div>
</body>
</html>
