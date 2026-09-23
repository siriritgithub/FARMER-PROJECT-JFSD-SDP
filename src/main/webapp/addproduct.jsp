<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - FarmGo Admin</title>
    <%@ include file="_theme.jsp" %>
</head>
<body>
<%@ include file="adminnavbar.jsp" %>

<div class="fg-main">
    <div class="fg-card" style="max-width:640px; margin:0 auto; text-align:left;">
        <h2 style="margin-top:0; text-align:center; color:var(--brand);">Add Product</h2>

        <c:if test="${not empty message}">
            <div class="fg-alert ok"><c:out value="${message}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/adminaddproduct" method="post">
            <div class="fg-field">
                <label for="name">Product Name</label>
                <input type="text" id="name" name="name" required placeholder="e.g. Tomato">
            </div>

            <div class="fg-field">
                <label for="specification">Category</label>
                <select id="specification" name="specification" required>
                    <option value="">Select category</option>
                    <option value="Vegetables">Vegetables</option>
                    <option value="Dairy Products">Dairy Products</option>
                    <option value="Value Added Products">Value Added Products</option>
                    <option value="Hand loom Products">Hand loom Products</option>
                    <option value="Organic Waste">Organic Waste</option>
                </select>
            </div>

            <div class="fg-field">
                <label for="type">Product Type / Variety</label>
                <input type="text" id="type" name="type" required placeholder="e.g. Hybrid Tomato">
            </div>

            <div class="fg-field">
                <label for="price">Price per unit (Rs)</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required>
            </div>

            <div class="fg-field">
                <label for="quantity">Quantity available</label>
                <div style="display:flex; gap:10px;">
                    <input type="number" id="quantity" name="quantity" min="0" required
                           placeholder="e.g. 100" style="flex:2;">
                    <select id="unit" name="unit" required style="flex:1;">
                        <option value="kg">kg</option>
                        <option value="ltr">ltr</option>
                        <option value="dozen">dozen</option>
                        <option value="piece">piece</option>
                        <option value="quintal">quintal</option>
                    </select>
                </div>
            </div>

            <div class="fg-field">
                <label for="date">Date of Harvest/Availability</label>
                <input type="date" id="date" name="date" required>
            </div>

            <div class="fg-field">
                <label for="location">Producer Location</label>
                <input type="text" id="location" name="location" required>
            </div>

            <div class="fg-field">
                <label for="contact">Producer Contact</label>
                <input type="tel" id="contact" name="contact" required>
            </div>

            <div class="fg-field">
                <label for="state">State</label>
                <select id="state" name="state" required>
                    <%@ include file="_states.jsp" %>
                </select>
            </div>

            <div class="fg-field">
                <label for="image">Image URL</label>
                <input type="text" id="image" name="image" required placeholder="https://...">
            </div>

            <div class="fg-field">
                <label for="description">Description (optional)</label>
                <textarea id="description" name="description" rows="3"></textarea>
            </div>

            <button type="submit" class="btn block">Add Product</button>
        </form>
    </div>
</div>
</body>
</html>
