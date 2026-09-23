<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ADMIN | VIEW AND DELETE FARMERS</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
        background-color: #F5F5F7;
        display: flex;
    }

    .navbar {
        width: 200px; /* Adjust this to your navbar's width */
        position: fixed;
        height: 100%;
        background-color: #705C53;
        color: white;
        padding: 20px;
    }

    .content {
        margin-left: 200px; /* Matches the navbar width */
        width: calc(100% - 200px);
        padding: 20px;
    }

    h2 {
        text-align: center;
        color: #705C53;
        margin: 20px 0;
    }

    table {
        width: 90%;
        margin: 20px auto;
        border-collapse: collapse;
        background-color: #FFFFFF;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    table th, table td {
        border: 1px solid #DDD;
        padding: 10px;
        text-align: center;
    }

    table th {
        background-color: #705C53;
        color: #FFFFFF;
    }

    .delete-btn {
        background-color: #FF6B6B;
        color: #FFFFFF;
        border: none;
        padding: 8px 12px;
        border-radius: 5px;
        cursor: pointer;
    }

    .delete-btn:hover {
        background-color: #FF4C4C;
    }
</style>
<script>
    function confirmDelete(farmerId) {
        const reason = prompt("Enter the reason for deleting this farmer:");
        if (reason) {
            document.getElementById('deleteForm-' + farmerId).reason.value = reason;
            document.getElementById('deleteForm-' + farmerId).submit();
        }
    }
</script>
</head>
<body>
    <%@ include file="adminnavbar.jsp" %> <!-- Your left-side navbar -->
    <div class="content">
        <h2>Delete Farmers</h2>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Username</th>
                    <th>Address</th>
                    <th>State</th>
					<th>Reports</th>                   
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach items="${farmerslist}" var="farmer">
                    <tr>
                        <td><c:out value="${farmer.id}" /></td>
                        <td><c:out value="${farmer.name}" /></td>
                        <td><c:out value="${farmer.phone}" /></td>
                        <td><c:out value="${farmer.username}" /></td>
                        <td><c:out value="${farmer.address}" /></td>
                        <td><c:out value="${farmer.state}" /></td>
                        <td>0</td>
                        <td>
                            <form id="deleteForm-${farmer.id}" action="deleteFarmer" method="post" style="display:inline;">
                                <input type="hidden" name="id" value="${farmer.id}">
                                <input type="hidden" name="reason">
                                <button type="button" class="delete-btn" onclick="confirmDelete(${farmer.id})">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>
