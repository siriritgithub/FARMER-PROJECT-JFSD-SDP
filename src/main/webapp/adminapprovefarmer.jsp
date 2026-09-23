<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ include file="adminnavbar.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Approval</title>
    <style>
        /* General Body Styling */
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
      table th,
            table td {
                padding: 12px;
                text-align: center;
                border: 1px solid #ddd;
            }
            /* Page Layout Fix */
        .main-content {
            margin-left: 220px; /* Adjust this value to match the width of your navbar */
            padding: 20px;
        }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        table th
        {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
            background-color:  #705C53;
            color: white;
        }
        
        table td {
            padding: 12px;
            text-align: center;
            border: 1px solid #ddd;
           
        }

        table tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        table tr:hover {
            background-color: #f1f1f1;
        }

        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            border-radius: 5px;
            font-size: 14px;
            margin: 5px;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #45a049;
        }

        form button.reject {
            background-color: #f44336;
        }

        form button.reject:hover {
            background-color: #d32f2f;
        }
        h1{
        	align-content: center;
        	color :  #705C53;
        }
    </style>
</head>
<body>

<!-- Admin Navbar -->
<%@ include file="adminnavbar.jsp" %>

<div class="main-content">
    <h1>Pending Farmers for Approval</h1>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                 <th>Username</th>
                <th>Phone</th>
                <th>Address</th>
                 <th>State</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="farmer" items="${farmers}">
                <tr>
                    <td>${farmer.id}</td>
                    <td>${farmer.name}</td>
                    <td>${farmer.username}</td>
                    <td>${farmer.phone}</td>
                    <td>${farmer.address}</td>
                    <td>${farmer.state}</td>
                    <td>
                        <form action="approvefarmer" method="post" style="display:inline;">
                            <input type="hidden" name="farmerId" value="${farmer.id}" />
                            <button type="submit">Approve</button>
                        </form>
                        <form action="rejectfarmer" method="post" style="display:inline;">
                            <input type="hidden" name="farmerId" value="${farmer.id}" />
                            <button type="submit" class="reject">Reject</button>
                        </form>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>