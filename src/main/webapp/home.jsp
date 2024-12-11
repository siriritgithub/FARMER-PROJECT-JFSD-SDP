<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PRO'FX - Home</title>
    <!-- Embedded CSS -->
    <style>
        /* General Body Styles */
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #B2C9AD;
            color: #333;
        }

        /* Header Section */
        header {
            background-color: #008080; /* Header background color */
            padding: 5px 0; /* Reduced padding for smaller header height */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        header .container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
        }

        header h1 {
            color: #ffffff;
            margin: 0;
            font-size: 1.8rem; /* Adjusted for a balanced look */
        }

        header nav ul {
            list-style: none;
            margin: 0;
            padding: 0;
            display: flex;
        }

        header nav ul li {
            margin: 0 15px;
        }

        header nav ul li a {
            color: #F5F0CD;
            text-decoration: none;
            font-size: 16px;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        header nav ul li a:hover {
            color: #FFD700;
        }

        /* Hero Section */
        .hero {
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            height: 70vh;
            color: #ffffff;
            background: url('https://images.deepai.org/art-image/5a2d183ac41b4a6f975da1ba78853701/farmer-standing-in-the-field-and-looking-at-h_vBHXezk.jpg') no-repeat center center/cover;
            position: relative;
        }

        .hero::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.5); /* Overlay effect */
            z-index: 1;
        }

        .hero .container {
            position: relative;
            z-index: 2;
            max-width: 800px;
        }

        .hero h1 {
            font-size: 3rem;
            margin-bottom: 20px;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }

        .hero p {
            font-size: 1.2rem;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.7);
        }

        /* Grid Container */
        .grid-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .grid-item {
            background: linear-gradient(135deg, #91AC8F, #66785F);
            border-radius: 10px;
            text-align: center;
            padding: 20px;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
            color: #2A3335;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .grid-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .grid-item img {
            width: 80px;
            margin-bottom: 15px;
        }

        .grid-item h3 {
            font-size: 1.5rem;
            margin-bottom: 10px;
        }

        .grid-item p {
            font-size: 1rem;
        }

        /* Info Section */
        .info-containers {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: space-around;
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .info-item {
            flex: 1;
            min-width: 250px;
            background: linear-gradient(135deg,  #91AC8F, #66785F);
            border-radius: 10px;
            color: #2A3335;
            padding: 20px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .info-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .info-item h3 {
            margin-bottom: 15px;
            font-size: 1.5rem;
            font-weight: bold;
        }

        .info-item p {
            font-size: 1rem;
            line-height: 1.5;
        }

        /* Additional Styling */
        .four-containers {
            display: flex;
            gap: 15px;
            justify-content: space-around;
            margin: 40px 0;
            padding-left: 20px;
            padding-right: 20px;
        }

        .container-item {
            position: relative;
            flex: 1;
            height: 250px;
            border-radius: 8px;
            background-size: cover;
            background-position: center;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            overflow: hidden;
        }

        .container-item:hover {
            transform: scale(1.05);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .container-item h3 {
            position: absolute;
            bottom: 15px;
            left: 15px;
            color: #FFFFFF;
            background: rgba(0, 0, 0, 0.5);
            padding: 10px;
            border-radius: 5px;
            margin: 0;
        }
    </style>
</head>
<body>

<%@ include file="demoheader.jsp" %>

<section class="hero">
    <div class="container">
        <h1>Farming Management System</h1>
        <p>PRO'FX is a Simpler & Enhanced Farmer Management System. Explore Our Awesome <a href = "services">Services</a> Now.</p>
        <div class="buttons">
            <a href="login" class="btn">Farmer Login</a>
            <a href="userlogin" class="btn">User Login</a>
            <a href="register" class="btn">Register</a>
        </div>
    </div>
</section>

<section class="home-section">
    <div class="grid-container">
        <div class="grid-item" onclick="location.href='/adminlogin';">
            <img src="https://www.svgrepo.com/show/421614/admin-user-web.svg" alt="Admin Login">
            <h3>Admin Login</h3>
            <p>Secure admin access for management operations.</p>
        </div>
        <div class="grid-item" onclick="location.href='/services';">
            <img src="https://www.svgrepo.com/show/524608/globus.svg" alt="Services">
            <h3>Services</h3>
            <p>Providing top-notch services for your farming needs.</p>
        </div>
        <div class="grid-item" onclick="location.href='aboutus';">
            <img src="https://www.svgrepo.com/show/129388/about-us.svg" alt="About Us">
            <h3>About Us</h3>
            <p>Learn more about our mission and values.</p>
        </div>
        <div class="grid-item" onclick="location.href='feedbackus';">
            <img src="https://www.svgrepo.com/show/415812/contact-phone-talking.svg" alt="Contact Us">
            <h3>To Contact or Feedback Us</h3>
            <p>Get in touch with our support team anytime.</p>
        </div>
        <div class="grid-item" onclick="location.href='faqs';">
            <img src="https://www.svgrepo.com/show/42847/question-mark.svg" alt="FAQs">
            <h3>FAQs</h3>
            <p>Find answers to frequently asked questions.</p>
        </div>
    </div>
</section>

<section class="info-containers">
    <div class="info-item">
        <h3>Pro'Fx Farmers</h3>
        <p>Empowering farmers with advanced tools to boost productivity.</p>
    </div>
    <div class="info-item">
        <h3>Online Transactions</h3>
        <p>Safe and secure online transactions for seamless buying and selling.</p>
    </div>
    <div class="info-item">
        <h3>Rural Entrepreneurship</h3>
        <p>Promoting entrepreneurship in rural areas through innovative solutions.</p>
    </div>
</section>


</body>
</html>
