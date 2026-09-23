package com.klu.jfsd.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Order;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;
import com.klu.jfsd.service.MailService;
import com.klu.jfsd.service.OrderService;
import com.klu.jfsd.service.OtpService;
import com.klu.jfsd.service.ProductService;
import com.klu.jfsd.service.UserService;
import com.klu.jfsd.service.CartService;
import com.klu.jfsd.service.WishlistService;
import com.klu.jfsd.service.AnalyticsService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class UserController {

    private final UserService userService;
    private final ProductService productService;
    private final OrderService orderService;
    private final OtpService otpService;
    private final MailService mailService;
    private final CartService cartService;
    private final WishlistService wishlistService;
    private final AnalyticsService analyticsService;

    public UserController(UserService userService,
                          ProductService productService,
                          OrderService orderService,
                          OtpService otpService,
                          MailService mailService,
                          CartService cartService,
                          WishlistService wishlistService,
                          AnalyticsService analyticsService) {
        this.userService = userService;
        this.productService = productService;
        this.orderService = orderService;
        this.otpService = otpService;
        this.mailService = mailService;
        this.cartService = cartService;
        this.wishlistService = wishlistService;
        this.analyticsService = analyticsService;
    }

    // =====================================================================
    // REGISTRATION
    // =====================================================================

    @GetMapping("userregister")
    public ModelAndView showRegistrationForm() {
        return new ModelAndView("userregestration");
    }

    @PostMapping("checkuserregister")
    public ModelAndView handleRegistration(HttpServletRequest request) {
        User user = new User();
        user.setName(trim(request.getParameter("name")));
        user.setPhone(trim(request.getParameter("phone")));
        user.setUsername(trim(request.getParameter("username")));
        user.setPassword(request.getParameter("password"));
        user.setAddress(trim(request.getParameter("address")));
        user.setState(trim(request.getParameter("state")));
        user.setImageUrl(trim(request.getParameter("imageUrl")));
        // Email was never captured before, which left every user unreachable
        // and made password reset by email impossible.
        user.setEmail(trim(request.getParameter("email")));

        String message = userService.userRegistration(user);

        ModelAndView mv = new ModelAndView("userregsuccesslogin");
        mv.addObject("message", message);
        return mv;
    }

    // =====================================================================
    // LOGIN / LOGOUT
    // =====================================================================

    @GetMapping("userlogin")
    public ModelAndView showLoginForm(@RequestParam(value = "expired", required = false) String expired) {
        ModelAndView mv = new ModelAndView("userlogin");
        if (expired != null) {
            mv.addObject("message", "Please log in to continue.");
        }
        return mv;
    }

    @PostMapping("checkuserlogin")
    public ModelAndView loginAction(HttpServletRequest request, HttpSession session) {
        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");

        ModelAndView mv = new ModelAndView();
        User user = userService.checkUserLogin(username, password);

        if (user == null) {
            mv.setViewName("userlogin");
            mv.addObject("message", "Invalid username or password.");
            return mv;
        }
        if (!user.isUserApproval()) {
            mv.setViewName("useraprovalpending");
            return mv;
        }

        // Guard against session fixation: start a fresh session on login.
        session.invalidate();
        HttpSession fresh = request.getSession(true);
        fresh.setAttribute("user", user);
        fresh.setAttribute("loggedInUserId", user.getId());

        mv.setViewName("redirect:/userhome");
        return mv;
    }

    @GetMapping("userlogout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/userlogin";
    }

    // =====================================================================
    // HOME AND BROWSING
    // =====================================================================

    @GetMapping("userhome")
    public ModelAndView userHome(HttpSession session) {
        User user = currentUser(session);
        ModelAndView mv = new ModelAndView("userhome");
        mv.addObject("username", user.getUsername());
        mv.addObject("user", user);
        return mv;
    }

    @GetMapping("/myinsights")
    public ModelAndView myInsights(HttpSession session) {
        User user = currentUser(session);
        ModelAndView mv = new ModelAndView("myinsights");
        mv.addObject("analytics", analyticsService.getUserAnalytics(user.getId()));
        return mv;
    }

    @GetMapping("userviewallfarmers")
    public ModelAndView userViewAllFarmers() {
        List<Farmer> farmers = userService.viewAllFarmers();
        ModelAndView mv = new ModelAndView("userviewallfarmers");
        mv.addObject("farmerslist", farmers);
        return mv;
    }

    @GetMapping("userviewallproducts")
    public ModelAndView userViewAllProducts() {
        ModelAndView mv = new ModelAndView("userviewallproducts");
        mv.addObject("productslist", userService.viewAllProducts());
        return mv;
    }

    @GetMapping("/userviewallproducts1")
    public ModelAndView viewAllProductsAlt() {
        ModelAndView mv = new ModelAndView("userviewallproducts");
        mv.addObject("productslist", productService.getAllProducts());
        return mv;
    }

    @GetMapping("userbuyproducts")
    public ModelAndView userBuyProducts() {
        ModelAndView mv = new ModelAndView("userbuyproducts");
        mv.addObject("productslist", userService.viewAllProducts());
        return mv;
    }

    @GetMapping("userbuyproductsbyname")
    public ModelAndView userBuyProductsByName() {
        ModelAndView mv = new ModelAndView("userbuyproductsbyname");
        mv.addObject("productslist", userService.viewAllProducts());
        return mv;
    }

    @GetMapping("/filterproducts")
    public ModelAndView filterProducts(
            @RequestParam(value = "specification", required = false) String specification) {
        ModelAndView mv = new ModelAndView("userbuyproducts");
        mv.addObject("productslist", userService.getProductsBySpecification(specification));
        mv.addObject("selectedSpecification", specification);
        return mv;
    }

    /**
     * Used to render its own duplicate copy of the product-detail page
     * (userviewdetails.jsp). Nothing links to this route anymore, so it now
     * just forwards to the one real detail page instead of maintaining two
     * near-identical JSPs that could quietly drift apart.
     */
    @GetMapping("/productdetails")
    public String showProductDetails(@RequestParam("productId") int productId) {
        return "redirect:/userviewproduct?productId=" + productId;
    }

    @GetMapping("/userviewproduct")
    public ModelAndView viewProductDetails(@RequestParam("productId") int productId,
                                           RedirectAttributes redirectAttributes) {
        Product product = productService.getProductById(productId);
        if (product == null) {
            redirectAttributes.addFlashAttribute("message", "That product is no longer available.");
            return new ModelAndView("redirect:/userbuyproducts");
        }
        ModelAndView mv = new ModelAndView("userviewproduct");
        mv.addObject("product", product);
        return mv;
    }

    // =====================================================================
    // ORDERS
    //
    // The "Buy Now" modal used to post directly to orderconfirmation.jsp.
    // Nothing was saved and stock was never reduced - the customer just saw a
    // success page. It now posts here, where the order is validated, written to
    // the database and stock is decremented.
    // =====================================================================

    @PostMapping("/placeorder")
    public ModelAndView placeOrder(@RequestParam("productId") int productId,
                                   @RequestParam(value = "quantity", defaultValue = "0") String quantityRaw,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {

        User user = currentUser(session);

        // The quantity arrives from a hidden field filled in by JavaScript, so
        // it can legitimately be empty. Parse defensively instead of letting
        // Spring throw a 400 on an unparseable value.
        int quantity;
        try {
            quantity = Integer.parseInt(quantityRaw.trim());
        } catch (Exception e) {
            quantity = 0;
        }

        OrderService.OrderResult result = orderService.placeOrder(user.getId(), productId, quantity);

        if (!result.isSuccess()) {
            redirectAttributes.addFlashAttribute("message", result.getMessage());
            return new ModelAndView("redirect:/userviewproduct?productId=" + productId);
        }

        Order order = result.getOrder();

        mailService.send(user.getEmail(), "Your FarmConnect order " + order.getReference(),
                "<p>Hello " + escape(user.getName()) + ",</p>"
              + "<p>We have received your order.</p>"
              + "<p><b>Reference:</b> " + order.getReference() + "<br/>"
              + "<b>Item:</b> " + escape(order.getProductName()) + "<br/>"
              + "<b>Quantity:</b> " + order.getQuantity() + "<br/>"
              + "<b>Total:</b> Rs. " + order.getTotalAmount() + "</p>"
              + "<p>Thank you for shopping with us.</p>");

        ModelAndView mv = new ModelAndView("orderconfirmation");
        mv.addObject("order", order);
        return mv;
    }

    @GetMapping("/myorders")
    public ModelAndView viewMyOrders(HttpSession session) {
        User user = currentUser(session);
        List<Order> orders = orderService.getOrdersByUserId(user.getId());
        ModelAndView mv = new ModelAndView("myorders");
        mv.addObject("orders", orders);
        return mv;
    }

    /**
     * This page used to open its own raw JDBC connection with a hardcoded
     * password, pointing at a database and table that don't exist in this
     * schema ("fms-sdpproject" / "farmers"), and its "Proceed to Pay" button
     * only ran a JavaScript alert() - no payment was ever processed. It now
     * shows the user's real order history and spend instead of pretending to
     * take a payment that doesn't exist.
     */
    @GetMapping("userpaymentdetails")
    public ModelAndView userPaymentDetails(HttpSession session) {
        User user = currentUser(session);
        List<Order> orders = orderService.getOrdersByUserId(user.getId());

        java.math.BigDecimal totalSpent = orders.stream()
                .map(Order::getTotalAmount)
                .filter(java.util.Objects::nonNull)
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);

        ModelAndView mv = new ModelAndView("userpaymentdetails");
        mv.addObject("orders", orders);
        mv.addObject("totalSpent", totalSpent);
        return mv;
    }

    // =====================================================================
    // CART
    // =====================================================================

    @PostMapping("/cart/add")
    public String addToCart(@RequestParam("productId") int productId,
                            @RequestParam(value = "quantity", defaultValue = "1") int quantity,
                            HttpSession session,
                            RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        cartService.addToCart(user.getId(), productId, quantity);
        redirectAttributes.addFlashAttribute("message", "Added to cart.");
        return "redirect:/cart";
    }

    @GetMapping("/cart")
    public ModelAndView viewCart(HttpSession session) {
        User user = currentUser(session);
        ModelAndView mv = new ModelAndView("cart");
        mv.addObject("lines", cartService.getCart(user.getId()));
        mv.addObject("cartTotal", cartService.getCartTotal(user.getId()));
        return mv;
    }

    @PostMapping("/cart/update")
    public String updateCartQuantity(@RequestParam("productId") int productId,
                                     @RequestParam("quantity") int quantity,
                                     HttpSession session) {
        User user = currentUser(session);
        cartService.updateQuantity(user.getId(), productId, quantity);
        return "redirect:/cart";
    }

    @PostMapping("/cart/remove")
    public String removeFromCart(@RequestParam("productId") int productId, HttpSession session) {
        User user = currentUser(session);
        cartService.remove(user.getId(), productId);
        return "redirect:/cart";
    }

    @PostMapping("/cart/checkout")
    public ModelAndView checkoutCart(HttpSession session, RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        CartService.CheckoutResult result = cartService.checkout(user.getId());

        if (result.getFailures().isEmpty()) {
            redirectAttributes.addFlashAttribute("message",
                    "Order placed for " + result.getPlacedCount() + " item(s).");
        } else {
            redirectAttributes.addFlashAttribute("message",
                    result.getPlacedCount() + " item(s) ordered. Some items could not be ordered: "
                            + String.join("; ", result.getFailures()));
        }
        return new ModelAndView("redirect:/myorders");
    }

    // =====================================================================
    // WISHLIST
    // =====================================================================

    @PostMapping("/wishlist/add")
    public String addToWishlist(@RequestParam("productId") int productId,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        User user = currentUser(session);
        wishlistService.add(user.getId(), productId);
        redirectAttributes.addFlashAttribute("message", "Saved to wishlist.");
        return "redirect:/wishlist";
    }

    @GetMapping("/wishlist")
    public ModelAndView viewWishlist(HttpSession session) {
        User user = currentUser(session);
        ModelAndView mv = new ModelAndView("wishlist");
        mv.addObject("lines", wishlistService.getWishlist(user.getId()));
        return mv;
    }

    @PostMapping("/wishlist/remove")
    public String removeFromWishlist(@RequestParam("productId") int productId, HttpSession session) {
        User user = currentUser(session);
        wishlistService.remove(user.getId(), productId);
        return "redirect:/wishlist";
    }

    @PostMapping("/wishlist/move-to-cart")
    public String moveToCart(@RequestParam("productId") int productId, HttpSession session) {
        User user = currentUser(session);
        cartService.addToCart(user.getId(), productId, 1);
        wishlistService.remove(user.getId(), productId);
        return "redirect:/wishlist";
    }

    // =====================================================================
    // PROFILE
    // =====================================================================

    @GetMapping("userupdateprofile")
    public ModelAndView viewProfile(HttpSession session) {
        User user = currentUser(session);
        ModelAndView mv = new ModelAndView("userupdateprofile");
        mv.addObject("user", user);
        return mv;
    }

    @PostMapping("updateuserprofile")
    public ModelAndView updateUserProfile(@RequestParam("password") String password,
                                          @RequestParam("name") String name,
                                          @RequestParam("username") String username,
                                          @RequestParam(value = "email", required = false) String email,
                                          @RequestParam("phone") String phone,
                                          @RequestParam("address") String address,
                                          @RequestParam("state") String state,
                                          HttpSession session,
                                          RedirectAttributes redirectAttributes) {

        User currentUser = currentUser(session);

        if (!userService.verifyPassword(currentUser, password)) {
            ModelAndView mv = new ModelAndView("userupdateprofile");
            mv.addObject("user", currentUser);
            mv.addObject("error", "Invalid password. Please try again.");
            return mv;
        }

        currentUser.setName(trim(name));
        currentUser.setUsername(trim(username));
        currentUser.setPhone(trim(phone));
        currentUser.setAddress(trim(address));
        currentUser.setState(trim(state));
        if (email != null && !email.isBlank()) {
            currentUser.setEmail(trim(email));
        }

        String message = userService.updateUser(currentUser);
        session.setAttribute("user", currentUser);
        redirectAttributes.addFlashAttribute("message", message);
        return new ModelAndView("redirect:/userupdateprofile");
    }

    // =====================================================================
    // PASSWORD RESET (OTP based)
    //
    // The old flow asked only for username + phone, both of which are printed
    // on the public "view all farmers/users" pages, so anyone could reset
    // anyone's password. It also set userApproval=false as a side effect,
    // locking the account until an admin re-approved it. Both are gone.
    // =====================================================================

    @GetMapping("/user/forgetpassword")
    public ModelAndView forgetPassword() {
        return new ModelAndView("userForgetPassword");
    }

    @PostMapping("/user/validateUser")
    public ModelAndView validateUser(@RequestParam("username") String username,
                                     @RequestParam("email") String email,
                                     HttpSession session) {

        User user = userService.findByUsernameAndEmail(trim(username), trim(email));

        // Always show the same screen whether or not the account exists, so the
        // form cannot be used to discover which usernames are registered.
        if (user != null) {
            String code = otpService.issue("user:" + user.getUsername());
            session.setAttribute("resetUsername", user.getUsername());
            session.setAttribute("resetRole", "user");
            mailService.send(user.getEmail(), "Your FarmConnect password reset code",
                    "<p>Your password reset code is <b>" + code + "</b>.</p>"
                  + "<p>It expires in 10 minutes. If you did not request this, ignore this email.</p>");
        }

        ModelAndView mv = new ModelAndView("verifyOtp");
        mv.addObject("role", "user");
        mv.addObject("message",
                "If that account exists, we have emailed a 6-digit code. Enter it below.");
        return mv;
    }

    @PostMapping("/user/verifyOtp")
    public ModelAndView verifyOtp(@RequestParam("code") String code, HttpSession session) {
        String username = (String) session.getAttribute("resetUsername");
        if (username == null) {
            return new ModelAndView("redirect:/user/forgetpassword");
        }
        if (!otpService.verify("user:" + username, trim(code))) {
            ModelAndView mv = new ModelAndView("verifyOtp");
            mv.addObject("role", "user");
            mv.addObject("error", "That code is incorrect or has expired.");
            return mv;
        }
        session.setAttribute("resetVerified", Boolean.TRUE);
        return new ModelAndView("redirect:/user/setPassword");
    }

    @GetMapping("/user/setPassword")
    public ModelAndView setPasswordPage(HttpSession session) {
        if (!Boolean.TRUE.equals(session.getAttribute("resetVerified"))) {
            return new ModelAndView("redirect:/user/forgetpassword");
        }
        ModelAndView mv = new ModelAndView("userSetPassword");
        mv.addObject("username", session.getAttribute("resetUsername"));
        return mv;
    }

    @PostMapping("/user/updatePassword")
    public ModelAndView updatePassword(@RequestParam("newPassword") String newPassword,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       HttpSession session) {

        // The username now comes from the verified session, never from the form,
        // so a crafted POST cannot reset a different account's password.
        if (!Boolean.TRUE.equals(session.getAttribute("resetVerified"))) {
            return new ModelAndView("redirect:/user/forgetpassword");
        }
        String username = (String) session.getAttribute("resetUsername");

        if (!newPassword.equals(confirmPassword)) {
            ModelAndView mv = new ModelAndView("userSetPassword");
            mv.addObject("username", username);
            mv.addObject("message", "Passwords do not match!");
            return mv;
        }

        String result = userService.changePassword(username, newPassword);
        if (!result.startsWith("Password changed")) {
            ModelAndView mv = new ModelAndView("userSetPassword");
            mv.addObject("username", username);
            mv.addObject("message", result);
            return mv;
        }

        session.removeAttribute("resetVerified");
        session.removeAttribute("resetUsername");

        ModelAndView mv = new ModelAndView("userlogin");
        mv.addObject("message", result);
        return mv;
    }

    // =====================================================================

    /** The interceptor guarantees a session, but keep this defensive. */
    private User currentUser(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            throw new SessionExpiredException("/userlogin");
        }
        return user;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("<", "&lt;").replace(">", "&gt;");
    }
}
