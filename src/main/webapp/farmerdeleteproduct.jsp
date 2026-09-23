<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Farmer | Delete Products</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }

        .content-container {
            margin-left: 250px; /* Adjust this to match the width of your navbar */
            padding: 20px;
        }

        .table-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }

        th {
            background-color: #705C53;
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .delete-button {
            padding: 5px 10px;
            background-color: red;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .delete-button:hover {
            background-color: #ff6666;
        }
    </style>
    <script>
        function confirmDelete(productId, productName) {
            if (confirm("Are you sure you want to delete the product: " + productName + "?")) {
                var f = document.createElement('form');
                f.method = 'POST';
                f.action = '${pageContext.request.contextPath}/deleteproduct';
                var i = document.createElement('input');
                i.type = 'hidden'; i.name = 'id'; i.value = productId;
                f.appendChild(i); document.body.appendChild(f); f.submit();
            }
        }
    </script>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>
<div class="content-container">
    <div class="table-container">
        <h2>Delete Products</h2>
        
        <c:if test="${not empty message}">
            <div id="notification" 
                 style="padding: 10px; background-color: #dff0d8; color: #3c763d; 
                        border: 1px solid #d6e9c6; border-radius: 5px; margin-bottom: 20px; 
                        opacity: 1; transition: opacity 1s ease;">
                ${message}
            </div>
            <script>
                // Automatically hide the notification after 3 seconds with a smooth transition
                setTimeout(function() {
                    var notification = document.getElementById("notification");
                    if (notification) {
                        notification.style.opacity = "0"; // Start the fade-out transition
                        setTimeout(function() {
                            notification.style.display = "none"; // Hide completely after transition ends
                        }, 1000); // Wait for the transition duration (1 second)
                    }
                }, 3000); // Show the notification for 3 seconds
            </script>
        </c:if>
        
        <c:if test="${not empty products}">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Type</th>
                    <th>Date</th>
                    <th>Price</th>
                    <th>Location</th>
                    <th>Contact</th>
                    <th>Specification</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${products}" var="product">
                    <tr>
                        <td><c:out value="${product.id}" /></td>
                        <td><c:out value="${product.name}" /></td>
                        <td><c:out value="${product.type}" /></td>
                        <td><c:out value="${product.date}" /></td>
                        <td><c:out value="${product.price}" /></td>
                        <td><c:out value="${product.location}" /></td>
                        <td><c:out value="${product.contact}" /></td>
                        <td><c:out value="${product.specification}" /></td>
                        <td>
                            <button class="delete-button" 
                                    onclick="confirmDelete('${product.id}', '${product.name}')">
                                Delete
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        </c:if>
        <c:if test="${empty products}">
            <p>No products available to display.</p>
        </c:if>
    </div>
</div>
</body>
</html>
