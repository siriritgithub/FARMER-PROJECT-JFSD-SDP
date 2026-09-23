<%@ include file="farmernavbar.jsp" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Farmer Add Product</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        .content {
            max-width: 1200px;
            margin: auto;
            padding: 20px;
            margin-left: 200px; /* Adjust margin to account for the navbar width */
        }
        h1, h2 {
            text-align: center;
            color: #333;
        }
        .product-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
        }
        .product-card {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
            width: 150px;
            padding: 10px;
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .product-card img {
            max-width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 8px;
        }
        .product-card:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .form-section {
            margin-top: 30px;
            text-align: center;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
        }
        .form-group {
            margin: 10px 0;
        }
        .form-group label {
            font-weight: bold;
            margin-right: 10px;
        }
        .form-group input {
            padding: 8px;
            width: 200px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        button {
            background-color: #28a745;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        button:hover {
            background-color: #218838;
        }
        .hidden {
            display: none;
        }
    </style>
    <script>
        let selectedProduct = '';
        let selectedVariety = '';

        function selectProduct(productName) {
            selectedProduct = productName;
            document.getElementById('product-name').value = productName;
            document.getElementById('varieties-section').classList.remove('hidden');
        }

        function selectVariety(varietyName) {
            selectedVariety = varietyName;
            document.getElementById('product-type').value = varietyName;
            document.getElementById('specification').value = 'Vegetable';
            document.getElementById('form-section').classList.remove('hidden');
        }

        window.onload = function() {
            // Automatically populate the current date in the form
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('date').value = today;
        };
    </script>
</head>
<body>
    <div class="content">
        <h1>Add a Product</h1>

        <!-- Display Products -->
        <div class="product-grid">
            <%
                // Sample product data with provided images (fetch dynamically in actual implementation)
                String[] products = {"Tomato", "Potato", "Onion", "Carrot", "Cucumber", "Spinach", "Pepper", "Broccoli", "Garlic", "Lettuce"};
                String[] productImages = {
                    "https://gardenandhappy.com/wp-content/uploads/2018/10/food-fresh-tomatoes-162830.jpg", 
                    "https://th.bing.com/th/id/OIP.K5mZ54kVsOvDeOtI5Ui4qAHaEK?rs=1&pid=ImgDetMain", 
                    "https://hips.hearstapps.com/hmg-prod/images/group-of-onions-top-view-royalty-free-image-636521528-1564522894.jpg?resize=480:*",
                    "https://th.bing.com/th/id/OIP.r2HLO7hld6cOrL0OrLfolwHaJ4?rs=1&pid=ImgDetMain",
                    "https://th.bing.com/th/id/OIP.nFtUUisZP0u9AEMZ8BPkmQHaHa?rs=1&pid=ImgDetMain",
                    "https://th.bing.com/th/id/OIP.vM7sLd-iGki5RFtPRAIBTgHaFj?rs=1&pid=ImgDetMain",
                    "https://wallpaperaccess.com/full/3601266.jpg",
                    "https://www.health.harvard.edu/media/content/images/p7_Broccoli_HH1812_gi905351392.jpg",
                    "https://th.bing.com/th/id/OIP.MBlodAeXthPf4O9yBMNaNgHaHa?rs=1&pid=ImgDetMain",
                    "https://th.bing.com/th/id/OIP.PhLi1uIbN3WcwVzRfKTCAAHaHG?rs=1&pid=ImgDetMain"
                };
               
                for (int i = 0; i < 5; i++) {
            %>
                <div class="product-card" onclick="selectProduct('<%= products[i] %>')">
                    <img src="<%= productImages[i] %>" alt="<%= products[i] %>">
                    <p><%= products[i] %></p>
                </div>
            <% } %>
        </div>

        <!-- Select Varieties -->
        <div id="varieties-section" class="hidden">
            <h2>Select a Variety</h2>
            <div class="product-grid">
                <%
                    // Sample varieties with provided images
                    String[] varieties = {"Premium", "Organic", "Hybrid", "Local", "Export Quality", "Seasonal", "Exotic", "Greenhouse", "Farm Fresh", "Bulk"};
                    String[] varietyImages = {
                        "https://gardenandhappy.com/wp-content/uploads/2018/10/food-fresh-tomatoes-162830.jpg", 
                        "https://th.bing.com/th/id/OIP.K5mZ54kVsOvDeOtI5Ui4qAHaEK?rs=1&pid=ImgDetMain", 
                        "https://hips.hearstapps.com/hmg-prod/images/group-of-onions-top-view-royalty-free-image-636521528-1564522894.jpg?resize=480:*",
                        "https://th.bing.com/th/id/OIP.r2HLO7hld6cOrL0OrLfolwHaJ4?rs=1&pid=ImgDetMain",
                        "https://th.bing.com/th/id/OIP.nFtUUisZP0u9AEMZ8BPkmQHaHa?rs=1&pid=ImgDetMain",
                        "https://th.bing.com/th/id/OIP.vM7sLd-iGki5RFtPRAIBTgHaFj?rs=1&pid=ImgDetMain",
                        "https://wallpaperaccess.com/full/3601266.jpg",
                        "https://www.health.harvard.edu/media/content/images/p7_Broccoli_HH1812_gi905351392.jpg",
                        "https://th.bing.com/th/id/OIP.MBlodAeXthPf4O9yBMNaNgHaHa?rs=1&pid=ImgDetMain",
                        "https://th.bing.com/th/id/OIP.PhLi1uIbN3WcwVzRfKTCAAHaHG?rs=1&pid=ImgDetMain"
                    };
                    for (int i = 0; i < varieties.length; i++) {
                %>
                    <div class="product-card" onclick="selectVariety('<%= varieties[i] %>')">
                        
                        <p><%= varieties[i] %></p>
                    </div>
                <% } %>
            </div>
        </div>

        <!-- Form Section -->
        <div id="form-section" class="form-section hidden">
            <h2>Complete Product Details</h2>
            <form action="farmerreqadding" method="post">
                <input type="hidden" id="product-name" name="name">
                <input type="hidden" id="product-type" name="type">
                <input type="hidden" id="specification" name="specification" value="Vegetables">
                <input type="hidden" id="date" name="date">

                <div class="form-group">
                    <label for="price">Price</label>
                    <input type="text" id="price" name="price">
                </div>
                <div class="form-group">
                    <label for="quantity">Quantity</label>
                    <input type="text" id="quantity" name="quantity">
                </div>
                <div class="form-group">
                    <label for="location">Location</label>
                    <input type="text" id="location" name="location">
                </div>
                <div class="form-group">
                    <label for="contact">Contact</label>
                    <input type="text" id="contact" name="contact">
                </div>
               
                <div class="form-group">
                    <button type="submit">Submit</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
