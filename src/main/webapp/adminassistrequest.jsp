<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assist Requests - FarmGo Admin</title>
    <%@ include file="_theme.jsp" %>
    <style>
        .modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.45); z-index: 1000; align-items: center; justify-content: center; }
        .modal.open { display: flex; }
        .modal-box { background: #fff; border-radius: var(--radius); padding: 28px; max-width: 480px; width: 92%; max-height: 85vh; overflow-y: auto; }
    </style>
</head>
<body>
<%@ include file="adminnavbar.jsp" %>

<div class="fg-main">
    <h1 style="margin-top:0;">Farmer Assist Requests</h1>
    <p style="color:var(--muted); margin-top:-6px;">
        Products farmers asked for help listing, submitted via "Request Listing Help".
        Review and complete the details, then update to publish it to the marketplace.
    </p>

    <c:if test="${not empty message}"><div class="fg-alert ok">${message}</div></c:if>

    <c:set var="pendingCount" value="0" />
    <c:forEach var="p" items="${products}">
        <c:if test="${p.request == 0}"><c:set var="pendingCount" value="${pendingCount + 1}" /></c:if>
    </c:forEach>

    <c:choose>
        <c:when test="${pendingCount == 0}">
            <div class="pc-empty fg-card" style="text-align:center; cursor:default;">
                <div style="font-size:2.4rem;">&#9989;</div>
                <h3>No pending requests</h3>
                <p style="color:var(--muted);">
                    Nothing to review right now. Requests appear here when a farmer uses
                    "Request Listing Help" instead of adding a product themselves.
                </p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="fg-grid">
                <c:forEach var="product" items="${products}">
                    <c:if test="${product.request == 0}">
                        <div class="fg-card" style="text-align:left; cursor:default;">
                            <h3 style="margin-top:0;">${product.name}</h3>
                            <p style="color:var(--muted); font-size:.9rem;">${product.type} &middot; ${product.specification}</p>
                            <table style="width:100%; font-size:.88rem; margin-bottom:14px;">
                                <tr><td style="color:var(--muted);">Price</td><td>Rs. ${product.price}</td></tr>
                                <tr><td style="color:var(--muted);">Quantity</td><td>${product.quantity} ${product.unit}</td></tr>
                                <tr><td style="color:var(--muted);">Location</td><td>${product.location}</td></tr>
                                <tr><td style="color:var(--muted);">Contact</td><td>${product.contact}</td></tr>
                            </table>
                            <button class="btn block"
                                onclick="openModal('${product.id}', '${product.name}', '${product.specification}', '${product.type}', '${product.price}', '${product.quantity}', '${product.location}', '${product.state}', '${product.image}', '${product.description}')">
                                Complete &amp; Publish
                            </button>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<div id="modal" class="modal">
    <div class="modal-box">
        <h2 style="margin-top:0;">Complete Product Listing</h2>
        <form action="${pageContext.request.contextPath}/updateProduct" method="post">
            <input type="hidden" id="product_id" name="id">
            <div class="fg-field">
                <label for="product_name">Product Name</label>
                <input type="text" id="product_name" name="name" required>
            </div>
            <div class="fg-field">
                <label for="product_specification">Category</label>
                <select id="product_specification" name="specification" required>
                    <option value="Vegetables">Vegetables</option>
                    <option value="Dairy Products">Dairy Products</option>
                    <option value="Value Added Products">Value Added Products</option>
                    <option value="Hand loom Products">Hand loom Products</option>
                    <option value="Organic Waste">Organic Waste</option>
                </select>
            </div>
            <div class="fg-field">
                <label for="product_type">Type</label>
                <input type="text" id="product_type" name="type" required>
            </div>
            <div class="fg-field">
                <label for="product_price">Price per unit (Rs)</label>
                <input type="number" id="product_price" name="price" step="0.01" required>
            </div>
            <div class="fg-field">
                <label for="product_quantity">Quantity</label>
                <input type="number" id="product_quantity" name="quantity" required>
            </div>
            <div class="fg-field">
                <label for="producer_location">Location</label>
                <input type="text" id="producer_location" name="location" required>
            </div>
            <div class="fg-field">
                <label for="producer_state">State</label>
                <select id="producer_state" name="state" required>
                    <%@ include file="_states.jsp" %>
                </select>
            </div>
            <div class="fg-field">
                <label for="product_images">Image URL</label>
                <input type="text" id="product_images" name="image">
            </div>
            <div class="fg-field">
                <label for="product_description">Description</label>
                <textarea id="product_description" name="description" rows="3"></textarea>
            </div>
            <button type="submit" class="btn block">Publish to Marketplace</button>
            <button type="button" class="btn secondary block" style="margin-top:8px;" onclick="closeModal()">Cancel</button>
        </form>
    </div>
</div>

<script>
    function openModal(id, name, specification, type, price, quantity, location, state, image, description) {
        document.getElementById('product_id').value = id;
        document.getElementById('product_name').value = name;
        document.getElementById('product_specification').value = specification;
        document.getElementById('product_type').value = type;
        document.getElementById('product_price').value = price;
        document.getElementById('product_quantity').value = quantity;
        document.getElementById('producer_location').value = location;
        document.getElementById('producer_state').value = state;
        document.getElementById('product_images').value = image;
        document.getElementById('product_description').value = description;
        document.getElementById('modal').classList.add('open');
    }
    function closeModal() {
        document.getElementById('modal').classList.remove('open');
    }
    window.onclick = function (event) {
        if (event.target === document.getElementById('modal')) closeModal();
    };
</script>
</body>
</html>
