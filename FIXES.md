# Fixes Applied

Everything changed from the original submission, grouped by severity.
Useful as a reference while testing, and as evidence of work for your report.

---

## Deployment blockers

| # | Problem | Fix |
|---|---|---|
| 1 | `<packaging>jar</packaging>` with JSP views. `src/main/webapp` is not packaged into a fat jar, so every page 404s under `java -jar`. Worked only in the IDE. | Switched to `war` with `spring-boot-starter-tomcat` + `tomcat-embed-jasper` at `provided` scope. Produces an executable WAR that also deploys to standalone Tomcat 10+. |
| 2 | Railway MySQL root password and a Gmail app password committed in `application.properties`. | All config moved to `${ENV_VAR:default}`. Added `.env.example`, hardened `.gitignore`. **You must still rotate both credentials — they are in git history.** |
| 3 | `admin_table` empty on a fresh DB and no admin-creation flow anywhere, so admin login could never succeed. | `DataSeeder` creates the first admin on startup from env vars and logs a banner. |
| 4 | Four JSPs declared the dead JSTL 1.x namespace `http://java.sun.com/jsp/jstl/core`, which throws under Jakarta JSTL 3.0. These were the farmer-approval, user-approval, assist-request and payment pages. | Changed to `jakarta.tags.core`. Added the matching JSTL API + impl pair to the POM. |
| 5 | `tomcat-jasper` (standalone Tomcat artifact) pulled in instead of the embedded one. | Replaced with `tomcat-embed-jasper`. |

## Features that appeared to work but did nothing

| # | Problem | Fix |
|---|---|---|
| 6 | **Ordering was entirely fake.** `userviewdetails.jsp` and `userviewproduct.jsp` posted to `action="orderconfirmation.jsp"` — straight to a JSP, bypassing every controller. No row was written, no stock decremented. The user saw a green success page with a `Math.random()` order ID. | Forms now post to `/placeorder`. `OrderServiceImplementation.placeOrder()` validates quantity and stock, writes a real order with a reference and total, decrements the product quantity, and emails a confirmation. |
| 7 | The real `placeOrder`/`myorders` endpoints read `session.getAttribute("loggedInUser")`, but login set `"user"`. Always null → always redirected to `/login`. | Session keys unified on `"user"` / `"loggedInUserId"`. |
| 8 | `placeOrder` had `order.setPrice(...)` commented out, so price would have been NULL anyway. | Unit price and computed total are both persisted. |
| 9 | `FarmerServiceImplementation.deleteFarmer(int, String)` was an **empty method body with a `// TODO Auto-generated method stub`**. The admin screen emailed the farmer, reported "Email Sent Successfully" and deleted nothing. | Implemented, including cleanup of the farmer's orphaned products. |
| 10 | `deleteProduct` compared `product.getFarmerId() == farmerId` — reference equality on two `Integer` objects. Only worked for IDs ≤ 127 because of the Integer cache; past that, farmers could not delete their own products. | `Objects.equals(...)`. |
| 11 | `submitContact` returned view `"contactus"`, which does not exist in the project. Feedback saved, then error page. | Returns `homefeedbackus` with a success message. |
| 12 | `Feedback.email` was `unique = true`, so the same person could only ever submit feedback once. | Constraint removed. Added `reply` and `createdAt` columns. |
| 13 | `adminviewfeedbacks.jsp` existed as an 11-line stub with no mapping and no service method — the admin could not read a single message. | Full feedback inbox: listing, reply, mark-resolved, reply emailed to sender. |
| 14 | Views `contactus`, `error` and `updateprofile` were referenced in Java but did not exist. | `error.jsp` created; the other two references repointed to real views. |
| 15 | `farmeraddproduct.jsp` posted to `/farmerreqadding`, so "Add Product" silently filed an assistance *request* instead. | Points at `/farmeraddproduct`. |
| 16 | **Every number on the analytics dashboard was a hardcoded literal** — 50 farmers, 234 positive feedbacks, ₹765456 income in Q4. `income` was set to `0` in the controller with a comment saying it was "assumed" to come from orders. | Rewritten against live counts and `SUM(total_amount)` over the orders table, plus a recent-orders table. |
| 17 | `myorders.jsp` used `<c:forEach>` with no taglib declaration → render failure. | Rewritten with the taglib, an empty state, and the new order fields. |
| 18 | `updateuserprofile` took `@RequestParam("email")` and assigned it to `setUsername()`. The field labelled Email was editing the login identity. | Separate `username` and `email` fields, bound correctly. |
| 19 | `farmerupdateproduct.jsp` had no quantity input, but the update endpoint needs one — stock could never be changed. | Quantity, image and description fields added and wired through the popup. |
| 20 | Analytics, feedback inbox and assist-requests had no navbar link — unreachable by clicking. | Added to the admin sidebar. "My Orders" added to the user navbar. |
| 21 | `getProductsByFarmer()` returned `null` with a TODO. `getProductById()` threw a `RuntimeException` on a missing id, turning a stale bookmark into a 500. | Dead method removed; lookups return null and controllers redirect with a message. |
| 22 | Navbar and form links were root-absolute (`href="adminhome"`, `action="/checkuserlogin"`), which breaks under a servlet context path. | All rewritten as `${pageContext.request.contextPath}/...`. |

## Security

| # | Problem | Fix |
|---|---|---|
| 23 | **No access control at all.** Typing `/adminviewallusers` or `/admindeleteusers` into the address bar worked without logging in. Every admin, farmer and user page was public. | `AuthInterceptor` + `WebConfig` guard all three role path groups and send unauthenticated requests to the right login page. |
| 24 | **Passwords stored in plain text** in all four tables, compared inside SQL queries. | BCrypt via `PasswordService`. Login loads by username and verifies the hash in Java. Existing plaintext rows are **transparently upgraded on first successful login**, so no data is lost and no migration script is needed. |
| 25 | **Password reset required only username + phone**, both printed on the public "view all farmers" page. Anyone could take over any account. It also set `approved = false` as a side effect, locking the account until an admin re-approved it. | Rebuilt as an email OTP flow: 6-digit code, 10-minute expiry, 5 attempts, single use. The username now comes from the verified session, never from a form field. The de-approval side effect is gone. |
| 26 | `updateAdminProfile` took the target account from a request parameter — any logged-in admin could edit another admin's record by editing the form. | Identity taken from the session. |
| 27 | Session fixation: the session ID was not rotated on login. | All three logins invalidate and start a fresh session. |
| 28 | `/deleteproduct` was a `GET` link, so a state change sat behind a URL that could be prefetched or crawled. | Converted to `POST`. |
| 29 | Registration saved straight to the DB and let duplicate-key exceptions surface as a generic failure. No length or uniqueness validation. | Explicit username-uniqueness and password-length checks with clear messages. |
| 30 | `/deleteFarmer` sent mail before checking anything, and mail failures threw out of the request — the admin saw a 500 while the operation never ran. | `MailService` wrapper: failures are logged and returned as a boolean, never thrown. With `MAIL_ENABLED=false` the whole app runs without SMTP credentials. |
| 31 | `Farmer.email` defaulted to a hardcoded personal Gmail address, so deletion notices for every farmer without an email went to one private inbox. | Default removed; email captured at registration. |
| 32 | User registration never captured an email at all. | Email field added to the form and the controller. |

## Code quality

- Deleted `Card.java` (an empty class).
- Removed `import ch.qos.logback.core.model.Model` from `UserController` — a logging class imported by IDE autocomplete accident.
- Removed the `@ManyToOne Farmer farmer` mapping on `Product`: never populated anywhere, so `product.farmer` was always null in JSPs while creating a redundant FK column. Removed the matching dangling `@OneToMany` on `Farmer`.
- Added `getPriceValue()` / `getQuantityValue()` transient helpers so the `VARCHAR` price and quantity columns can be used for arithmetic without blowing up on malformed input.
- Replaced field `@Autowired` with constructor injection throughout the service and controller layers.
- Added `GlobalExceptionHandler` and `AppErrorController` so unhandled exceptions and 404s render `error.jsp` instead of a raw stack trace.
- Removed the redundant `@ComponentScan("com.klu.jfsd")`.
- Replaced the `@SpringBootTest` `contextLoads()` test, which required a live MySQL connection and therefore broke `mvn package` on any machine without the DB configured.
- Stripped several hundred lines of blank filler and commented-out dead code from the controllers.
- Connection pool capped at 5 (`DB_POOL_SIZE`) — free MySQL tiers cap concurrent connections below Hikari's default of 10.

---

## Not changed (deliberately)

- The `mailto:deepak.yaramala@gmail.com` contact links on the about/pending pages. Those are intentional contact details, not a leak — change them if you want a different address shown.
- `price` / `quantity` remain `VARCHAR`. Converting to `DECIMAL` / `INT` is correct but needs a real migration, since `ddl-auto=update` never alters existing column types.
- CSRF tokens. See the limitations section of `DEPLOYMENT.md`.
