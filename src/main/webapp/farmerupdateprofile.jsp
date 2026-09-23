<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Update Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            
             background-color: #F5F5F7;
        }
	
	    h3 {
	        text-align: center;
	        color: #705C53; /* Heading color */
	        margin-top: 20px;
	    }
        .content-container {
            align-items: center;
            margin-left: 250px; /* Adjust this to match the width of your navbar */
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

        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 20%;
            object-fit: cover;
            margin-bottom: 20px;
            border: 2px solid #ddd;
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
            pointer-events: none; /* Disable editing */
        }

        .form-group input.editable {
            background-color: white;
            pointer-events: auto; /* Enable editing */
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

        /* Centered Popup */
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

        /* Notification */
        .notification {
            padding: 10px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: bold;
        }

        .notification.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .notification.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
    </style>
    <script>
        let isEditable = false;

        function toggleEdit() {
            const inputs = document.querySelectorAll(".form-group input");
            isEditable = !isEditable;

            // Toggle the 'readonly' attribute and the CSS class
            inputs.forEach(input => {
                if (isEditable) {
                    input.removeAttribute("readonly");  // Enable editing
                    input.classList.add("editable");    // Apply editable style
                } else {
                    input.setAttribute("readonly", true);  // Disable editing
                    input.classList.remove("editable");    // Remove editable style
                }
            });

            // Toggle the visibility of the buttons
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
            const password = document.getElementById("password").value;
            const form = document.getElementById("update-form");

            // Create a hidden input field to store the password and submit it with the form
            const passwordField = document.createElement("input");
            passwordField.type = "hidden";
            passwordField.name = "password";
            passwordField.value = password;
            form.appendChild(passwordField);

            // Submit the form to the backend for password validation
            form.submit();
        }
    </script>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>
<div class="content-container">
    <div class="form-container">
        <img src="${farmer.image}" alt="Profile Picture" class="profile-pic">
        <c:if test="${not empty message}">
            <div id="notification" 
                 style="padding: 10px; background-color: #dff0d8; color: #3c763d; 
                        border: 1px solid #d6e9c6; border-radius: 5px; margin-bottom: 20px; 
                        opacity: 1; transition: opacity 1s ease;">
                ${message}
            </div>
            <script>
                setTimeout(function() {
                    var notification = document.getElementById("notification");
                    if (notification) {
                        notification.style.opacity = "0";
                        setTimeout(function() {
                            notification.style.display = "none";
                        }, 1000);
                    }
                }, 3000);
            </script>
        </c:if>
        <h2>Update Farmer Profile</h2>
        <form id="update-form" action="updatefarmerprofile" method="POST">
            <div class="form-group">
                <label for="name">Name</label>
                <input type="text" id="name" name="name" value="${farmer.name}" readonly>
            </div>
            <div class="form-group">
                <label for="email">Username</label>
                <input type="text" id="username" name="username" value="${farmer.username}" readonly>
            </div>
            <div class="form-group">
                <label for="phone">Phone</label>
                <input type="tel" id="phone" name="phone" value="${farmer.phone}" readonly>
            </div>
            <div class="form-group">
                <label for="address">Address</label>
                <input type="text" id="address" name="address" value="${farmer.address}" readonly>
            </div>
            <div class="form-group">
                <label for="state">State</label>
                <input type="text" id="state" name="state" value="${farmer.state}" readonly>
            </div>
            <div class="button-container">
                <button type="button" id="edit-button" class="edit-button" onclick="toggleEdit()">Edit Profile</button>
                <button type="button" id="save-button" class="save-button" style="display: none;" onclick="showPasswordPopup()">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Password Popup -->
<div class="popup-container" id="popup-container">
    <div class="popup-content">
        <p>Please enter your password to confirm changes:</p>
        <input type="password" id="password" placeholder="Enter your password">
        <button onclick="validatePassword()">Submit</button>
        <button onclick="hidePasswordPopup()">Cancel</button>
    </div>
</div>
</body>
</html>
