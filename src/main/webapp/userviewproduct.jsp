<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.name} - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <style>
        .pd-wrap { max-width: 980px; margin: 0 auto; padding: 32px 24px; }
        .pd-grid { display: grid; grid-template-columns: 380px 1fr; gap: 32px; }
        @media (max-width: 800px) { .pd-grid { grid-template-columns: 1fr; } }
        .pd-image { width: 100%; border-radius: var(--radius); box-shadow: var(--shadow); object-fit: cover; max-height: 380px; }
        .pd-image.placeholder { display:flex; align-items:center; justify-content:center; font-size:4rem; height:300px; background:#eef2ec; border-radius:var(--radius); }
        .pd-info-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 14px 24px; margin: 18px 0 24px; }
        .pd-info-item .k { font-size: .78rem; text-transform: uppercase; color: var(--muted); display: block; }
        .pd-info-item .v { font-weight: 700; color: var(--ink); }
        .pd-order-box { background: #f6f8f4; border: 1px solid var(--border); border-radius: var(--radius); padding: 20px; margin-top: 10px; }
        .modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,.45); z-index: 1000; align-items: center; justify-content: center; }
        .modal.open { display: flex; }
        .modal-box { background: #fff; border-radius: var(--radius); padding: 28px; max-width: 420px; width: 90%; }
    </style>
</head>
<body>
<%@ include file="usernavbar.jsp" %>

<div class="pd-wrap">
    <a href="javascript:history.back()" style="color:var(--brand); text-decoration:none; font-weight:600;">&larr; Back</a>

    <div class="pd-grid" style="margin-top:16px;">
        <c:choose>
            <c:when test="${not empty product.image}">
                <img class="pd-image" src="${product.image}" alt="${product.name}">
            </c:when>
            <c:otherwise>
                <div class="pd-image placeholder">&#127807;</div>
            </c:otherwise>
        </c:choose>

        <div>
            <h1 style="margin:0 0 4px;">${product.name}</h1>
            <p style="color:var(--muted); margin:0 0 18px;">${product.type} &middot; ${product.specification}</p>

            <div class="pd-info-grid">
                <div class="pd-info-item"><span class="k">Price</span><span class="v">${product.displayPrice}</span></div>
                <div class="pd-info-item"><span class="k">Available</span><span class="v">${product.displayQuantity}</span></div>
                <div class="pd-info-item"><span class="k">Location</span><span class="v">${product.location}</span></div>
                <div class="pd-info-item"><span class="k">Contact</span><span class="v">${product.contact}</span></div>
            </div>

            <c:if test="${not empty product.description}">
                <p style="color:var(--ink); line-height:1.6;">${product.description}</p>
            </c:if>

            <div class="pd-order-box">
                <label for="quantity" style="font-weight:700;">Quantity (${product.unit})</label>
                <input type="number" id="quantity" min="1" value="1"
                       data-price="${product.priceValue}" data-available="${product.quantityValue}"
                       oninput="calcTotal()"
                       style="width:100%; padding:11px 14px; border:1.5px solid var(--border); border-radius:9px; margin:8px 0;">
                <div id="feedback" style="color:var(--danger); font-size:.85rem;"></div>
                <div id="totalDisplay" style="font-size:1.1rem; font-weight:700; color:var(--brand); margin:8px 0;"></div>

                <div style="display:flex; gap:10px; margin-top:14px; flex-wrap:wrap;">
                    <button type="button" class="btn" style="flex:1;" onclick="openConfirm()"
                            ${product.inStock ? '' : 'disabled'}>Buy Now</button>
                    <form action="${pageContext.request.contextPath}/cart/add" method="post" style="flex:1;">
                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" id="cartQty" name="quantity" value="1">
                        <button type="submit" class="btn secondary block" ${product.inStock ? '' : 'disabled'}>Add to Cart</button>
                    </form>
                    <form action="${pageContext.request.contextPath}/wishlist/add" method="post">
                        <input type="hidden" name="productId" value="${product.id}">
                        <button type="submit" class="btn secondary" style="padding:13px 18px;">&#9825;</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- Honest order-summary confirmation - no fake card fields collected here.
     The previous version of this page asked for a card number, expiry and
     CVV and then discarded them without ever reading or storing them
     anywhere; that looked like a real payment step but wasn't one. --%>
<div id="confirmModal" class="modal">
    <div class="modal-box">
        <h2 style="margin-top:0;">Confirm Your Order</h2>
        <p style="color:var(--muted);">FarmGo does not process real payments yet &mdash; this places your order directly.</p>
        <div style="background:#f6f8f4; border-radius:10px; padding:14px; margin:16px 0;">
            <div style="display:flex; justify-content:space-between; margin-bottom:6px;">
                <span>${product.name} &times; <span id="confirmQty"></span></span>
                <span id="confirmTotal" style="font-weight:700;"></span>
            </div>
        </div>
        <form action="${pageContext.request.contextPath}/placeorder" method="post">
            <input type="hidden" name="productId" value="${product.id}">
            <input type="hidden" id="confirmQtyInput" name="quantity" value="1">
            <button type="submit" class="btn block">Confirm Order</button>
        </form>
        <button type="button" class="btn secondary block" style="margin-top:8px;" onclick="closeConfirm()">Cancel</button>
    </div>
</div>

<script>
    function calcTotal() {
        var qtyInput = document.getElementById('quantity');
        var qty = parseInt(qtyInput.value, 10);
        var price = parseFloat(qtyInput.dataset.price);
        var available = parseInt(qtyInput.dataset.available, 10);
        var feedback = document.getElementById('feedback');
        var totalDisplay = document.getElementById('totalDisplay');

        if (!qty || qty <= 0) {
            feedback.textContent = 'Enter a valid quantity.';
            totalDisplay.textContent = '';
            return;
        }
        if (qty > available) {
            feedback.textContent = 'Only ' + available + ' available.';
            totalDisplay.textContent = '';
            return;
        }
        feedback.textContent = '';
        totalDisplay.textContent = 'Total: Rs. ' + (price * qty).toFixed(2);
        document.getElementById('cartQty').value = qty;
    }

    function openConfirm() {
        var qty = parseInt(document.getElementById('quantity').value, 10) || 1;
        var price = parseFloat(document.getElementById('quantity').dataset.price);
        document.getElementById('confirmQty').textContent = qty;
        document.getElementById('confirmTotal').textContent = 'Rs. ' + (price * qty).toFixed(2);
        document.getElementById('confirmQtyInput').value = qty;
        document.getElementById('confirmModal').classList.add('open');
    }
    function closeConfirm() {
        document.getElementById('confirmModal').classList.remove('open');
    }
    window.onclick = function (event) {
        if (event.target === document.getElementById('confirmModal')) closeConfirm();
    };
    calcTotal();
</script>
</body>
</html>
