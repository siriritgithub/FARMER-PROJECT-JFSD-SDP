<%-- Shared buyer-facing product grid. Expects ${productslist}. Include
     _theme.jsp and _productcard.jsp before this. --%>
<c:choose>
    <c:when test="${empty productslist}">
        <div class="pc-empty">
            <div class="icon">&#127807;</div>
            <h3>No products available right now</h3>
        </div>
    </c:when>
    <c:otherwise>
        <div class="pc-toolbar" style="margin-top:20px;">
            <input type="text" id="pc-search" oninput="pcFilter()" placeholder="Search by name, type or location...">
        </div>
        <div id="pc-no-results" class="pc-empty" style="display:none;">No products match your search.</div>

        <div class="pc-grid">
            <c:forEach var="product" items="${productslist}">
                <div class="pc-card"
                     data-search="${product.name} ${product.type} ${product.specification} ${product.location}">
                    <c:choose>
                        <c:when test="${not empty product.image}">
                            <img class="pc-image" src="${product.image}" alt="${product.name}">
                        </c:when>
                        <c:otherwise>
                            <div class="pc-image placeholder">&#127807;</div>
                        </c:otherwise>
                    </c:choose>
                    <div class="pc-body">
                        <div class="pc-top">
                            <h3 class="pc-name">${product.name}</h3>
                            <c:choose>
                                <c:when test="${product.inStock}">
                                    <span class="pc-badge in-stock">In Stock</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="pc-badge out-stock">Out of Stock</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <p class="pc-tagline">${product.type} &middot; ${product.location}</p>
                        <div class="pc-meta">
                            <div class="pc-meta-item"><span class="k">Price</span><span class="v">${product.displayPrice}</span></div>
                            <div class="pc-meta-item"><span class="k">Available</span><span class="v">${product.displayQuantity}</span></div>
                        </div>
                        <div class="pc-actions">
                            <a href="${pageContext.request.contextPath}/userviewproduct?productId=${product.id}"
                               class="pc-btn primary">View Details</a>
                            <form action="${pageContext.request.contextPath}/cart/add" method="post">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="hidden" name="quantity" value="1">
                                <button type="submit" class="pc-btn" ${product.inStock ? '' : 'disabled'}>&#128722; Add to Cart</button>
                            </form>
                            <form action="${pageContext.request.contextPath}/wishlist/add" method="post">
                                <input type="hidden" name="productId" value="${product.id}">
                                <button type="submit" class="pc-btn wish">&#9825; Wishlist</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </c:otherwise>
</c:choose>
