# 🌾 FarmGo — Farmer Management System

FarmGo is a role-based marketplace connecting farmers directly with buyers —
no middleman. Farmers list produce, buyers browse and order, and admins keep
the platform running. Built with Spring Boot, JSP, and MySQL.

> Academic project (JFSD SDP). See [FIXES.md](FIXES.md) for the full list of
> bugs fixed and features added on top of the original submission, and
> [DEPLOYMENT.md](DEPLOYMENT.md) for detailed run/deploy instructions.

---

## ✨ Features

**For Farmers**
- Register, get admin-approved, and list produce (price, quantity, unit, images)
- Upload a product photo directly or link an image URL
- Manage listings — update stock, price, or delete
- Real-time analytics: best-selling products, sales by location, peak buying
  hours, monthly revenue trend, low-stock alerts

**For Buyers**
- Browse by category or search by name
- Cart and wishlist, with real checkout that places actual orders
- Order history with live status and totals
- Personal insights: top purchases, spending by category, favorite farmer

**For Admins**
- Approve/reject farmer and user registrations
- Add products directly or complete farmer-submitted listing requests
- Platform-wide analytics — revenue, top products, users/farmers by state
- Feedback inbox with reply-by-email
- Full user/farmer/product management

---

## 🛠️ Tech Stack

- **Backend:** Spring Boot 3.3, Spring Data JPA, Hibernate
- **Frontend:** JSP + JSTL, vanilla CSS/JS (no framework)
- **Database:** MySQL
- **Auth:** Session-based, BCrypt password hashing
- **Email:** Spring Mail (Gmail SMTP) for OTP password reset and notifications
- **Deployment:** Docker, deployable to Render/Railway or any Tomcat 10+ server

---

## 🚀 Quick Start

```bash
docker compose up --build
```

Then open **http://localhost:9091/home**.

First admin login is seeded automatically — check the startup logs for the
generated credentials, or set `ADMIN_USERNAME` / `ADMIN_PASSWORD` yourself.
Full setup (including running without Docker) is in
**[DEPLOYMENT.md](DEPLOYMENT.md)**.

---

## 📁 Project Structure

```
src/main/java/com/klu/jfsd/
├── controller/      # Admin, Farmer, User request handlers
├── service/          # Business logic + analytics
├── repository/        # Spring Data JPA repositories
├── model/              # JPA entities
├── config/              # Security interceptors, data seeding
└── security/             # Password hashing

src/main/webapp/            # JSP views
```

---

## 🔒 Security Notes

- Passwords are hashed with BCrypt; legacy plaintext rows upgrade automatically on login
- Role-based access control via a servlet interceptor
- Password reset uses email OTP (not security questions)
- No secrets are committed — everything sensitive is an environment variable (see `.env.example`)

## ⚠️ Known Limitations

- Payments are simulated — FarmGo confirms orders directly rather than integrating a real payment gateway
- No automated test suite
- Single-instance only (in-memory OTP store; add Redis before scaling horizontally)

---

## 📄 License

Academic project — no license specified.
