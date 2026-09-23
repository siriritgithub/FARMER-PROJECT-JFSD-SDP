<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - FarmGo</title>
    <%@ include file="_theme.jsp" %>
    <style>
        .img-toggle { display: flex; gap: 8px; margin-bottom: 8px; }
        .img-toggle button {
            flex: 1; padding: 9px; border-radius: 8px; border: 1.5px solid var(--border);
            background: #fbfcfa; cursor: pointer; font-size: .85rem; font-weight: 600;
        }
        .img-toggle button.active { background: var(--brand-light); color: #fff; border-color: var(--brand-light); }
        .img-preview {
            margin-top: 10px; max-width: 140px; max-height: 140px; border-radius: 8px;
            border: 1px solid var(--border); display: none;
        }
        .field-hint { font-size: .8rem; color: var(--muted); margin: -10px 0 14px; }
    </style>
</head>
<body>
<%@ include file="farmernavbar.jsp" %>

<div class="fg-main">
    <div class="fg-card" style="max-width:640px; margin:0 auto; text-align:left;">
        <h2 style="margin-top:0; text-align:center; color:var(--brand);">Register Your Product</h2>

        <c:if test="${not empty message}">
            <div class="fg-alert ok"><c:out value="${message}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/farmeraddproduct" method="post" id="productForm">

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
                <p class="field-hint">The broad group buyers filter by on the marketplace.</p>
            </div>

            <div class="fg-field">
                <label for="type">Product Type</label>
                <input type="text" id="type" name="type" required placeholder="e.g. Hybrid Tomato, A2 Cow Milk">
                <p class="field-hint">The specific variety or kind &mdash; more detail than the category above.</p>
            </div>

            <div class="fg-field">
                <label for="price">Price per unit (Rs)</label>
                <input type="number" id="price" name="price" step="0.01" min="0" required placeholder="Your price">
                <p class="field-hint">Set your own price per kg/ltr/unit &mdash; nothing here is fixed for you.</p>
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
                <label for="date">Date of Availability</label>
                <input type="date" id="date" name="date" required>
            </div>

            <div class="fg-field">
                <label for="location">Location</label>
                <input type="text" id="location" name="location" required placeholder="e.g. Vijayawada">
            </div>

            <div class="fg-field">
                <label for="contact">Contact Number</label>
                <input type="text" id="contact" name="contact" required placeholder="A number buyers can reach you on">
            </div>

            <div class="fg-field">
                <label for="state">State</label>
                <select id="state" name="state" required>
                    <%@ include file="_states.jsp" %>
                </select>
            </div>

            <%-- Image 1: URL or upload --%>
            <div class="fg-field">
                <label>Product Image</label>
                <div class="img-toggle">
                    <button type="button" id="img1UrlBtn" class="active" onclick="setImgMode(1,'url')">Use a URL</button>
                    <button type="button" id="img1FileBtn" onclick="setImgMode(1,'file')">Upload a photo</button>
                </div>
                <input type="text" id="image1_url" placeholder="https://example.com/photo.jpg"
                       oninput="document.getElementById('image1').value=this.value">
                <input type="file" id="image1_file" accept="image/*" style="display:none;">
                <input type="hidden" id="image1" name="image1">
                <img id="image1_preview" class="img-preview">
            </div>

            <%-- Image 2: URL or upload (optional) --%>
            <div class="fg-field">
                <label>Second Image (optional)</label>
                <div class="img-toggle">
                    <button type="button" id="img2UrlBtn" class="active" onclick="setImgMode(2,'url')">Use a URL</button>
                    <button type="button" id="img2FileBtn" onclick="setImgMode(2,'file')">Upload a photo</button>
                </div>
                <input type="text" id="image2_url" placeholder="https://example.com/photo2.jpg"
                       oninput="document.getElementById('image2').value=this.value">
                <input type="file" id="image2_file" accept="image/*" style="display:none;">
                <input type="hidden" id="image2" name="image2">
                <img id="image2_preview" class="img-preview">
            </div>

            <div class="fg-field">
                <label for="description">Description</label>
                <textarea id="description" name="description" rows="4" required
                          placeholder="Anything a buyer should know"></textarea>
            </div>

            <button type="submit" class="btn block">Register Product</button>
        </form>
    </div>
</div>

<script>
    // Toggle between "paste a URL" and "upload a photo" per image slot.
    function setImgMode(slot, mode) {
        var urlInput = document.getElementById('image' + slot + '_url');
        var fileInput = document.getElementById('image' + slot + '_file');
        var urlBtn = document.getElementById('img' + slot + 'UrlBtn');
        var fileBtn = document.getElementById('img' + slot + 'FileBtn');
        var hidden = document.getElementById('image' + slot);

        if (mode === 'url') {
            urlInput.style.display = '';
            fileInput.style.display = 'none';
            urlBtn.classList.add('active');
            fileBtn.classList.remove('active');
            hidden.value = urlInput.value;
        } else {
            urlInput.style.display = 'none';
            fileInput.style.display = '';
            urlBtn.classList.remove('active');
            fileBtn.classList.add('active');
            hidden.value = '';
        }
    }

    // Convert an uploaded photo to a base64 data URI so it can travel in a
    // normal form field - no separate file-storage server needed.
    function wireFileInput(slot) {
        var fileInput = document.getElementById('image' + slot + '_file');
        var hidden = document.getElementById('image' + slot);
        var preview = document.getElementById('image' + slot + '_preview');

        fileInput.addEventListener('change', function () {
            var file = fileInput.files[0];
            if (!file) { return; }
            if (file.size > 4 * 1024 * 1024) {
                alert('Please choose an image under 4MB.');
                fileInput.value = '';
                return;
            }
            var reader = new FileReader();
            reader.onload = function (e) {
                hidden.value = e.target.result;
                preview.src = e.target.result;
                preview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        });
    }
    wireFileInput(1);
    wireFileInput(2);
</script>
</body>
</html>
