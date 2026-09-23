package com.klu.jfsd.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;
import com.klu.jfsd.service.FarmerService;
import com.klu.jfsd.service.MailService;
import com.klu.jfsd.service.OrderService;
import com.klu.jfsd.service.OtpService;
import com.klu.jfsd.service.ProductService;
import com.klu.jfsd.service.AnalyticsService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class FarmerController {

    private final FarmerService farmerService;
    private final ProductService productService;
    private final OrderService orderService;
    private final OtpService otpService;
    private final MailService mailService;
    private final AnalyticsService analyticsService;

    public FarmerController(FarmerService farmerService,
                            ProductService productService,
                            OrderService orderService,
                            OtpService otpService,
                            MailService mailService,
                            AnalyticsService analyticsService) {
        this.farmerService = farmerService;
        this.productService = productService;
        this.orderService = orderService;
        this.otpService = otpService;
        this.mailService = mailService;
        this.analyticsService = analyticsService;
    }

    // =====================================================================
    // REGISTRATION
    // =====================================================================

    @GetMapping("/register")
    public ModelAndView registerPage() {
        return new ModelAndView("register");
    }

    @PostMapping("checkfarmerregister")
    public ModelAndView registerFarmer(HttpServletRequest request) {
        Farmer farmer = new Farmer();
        farmer.setName(trim(request.getParameter("name")));
        farmer.setPhone(trim(request.getParameter("phone")));
        farmer.setUsername(trim(request.getParameter("username")));
        farmer.setPassword(request.getParameter("password"));
        farmer.setAddress(trim(request.getParameter("address")));
        farmer.setState(trim(request.getParameter("state")));
        farmer.setEmail(trim(request.getParameter("email")));

        String image = trim(request.getParameter("image"));
        if (image != null && !image.isBlank()) {
            farmer.setImage(image);
        }

        String message = farmerService.farmerRegestration(farmer);

        ModelAndView mv = new ModelAndView("regsuccesslogin");
        mv.addObject("message", message);
        return mv;
    }

    // =====================================================================
    // LOGIN / LOGOUT
    // =====================================================================

    @GetMapping("/login")
    public ModelAndView loginPage(@RequestParam(value = "expired", required = false) String expired) {
        ModelAndView mv = new ModelAndView("login");
        if (expired != null) {
            mv.addObject("message", "Please log in to continue.");
        }
        return mv;
    }

    @PostMapping("loginAction")
    public ModelAndView loginAction(HttpServletRequest request, HttpSession session) {
        String username = trim(request.getParameter("username"));
        String password = request.getParameter("password");

        ModelAndView mv = new ModelAndView();
        Farmer farmer = farmerService.checkFarmerLogin(username, password);

        if (farmer == null) {
            mv.setViewName("login");
            mv.addObject("message", "Invalid username or password.");
            return mv;
        }
        if (!farmer.isApproved()) {
            mv.setViewName("farmeraprovalpending");
            return mv;
        }

        session.invalidate();
        HttpSession fresh = request.getSession(true);
        fresh.setAttribute("farmer", farmer);
        fresh.setAttribute("loggedInFarmerId", farmer.getId());

        mv.setViewName("redirect:/farmerhome");
        return mv;
    }

    @GetMapping("farmerlogout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/home";
    }

    // =====================================================================
    // HOME
    // =====================================================================

    @GetMapping("/farmerhome")
    public ModelAndView farmerHome(HttpSession session) {
        Farmer farmer = currentFarmer(session);
        ModelAndView mv = new ModelAndView("farmerhome");
        mv.addObject("farmer", farmer);
        mv.addObject("productCount", farmerService.getProductsByFarmerId(farmer.getId()).size());
        mv.addObject("orderCount", orderService.getOrdersByFarmerId(farmer.getId()).size());
        return mv;
    }

    @GetMapping("/farmerinsights")
    public ModelAndView farmerInsights(HttpSession session) {
        Farmer farmer = currentFarmer(session);
        ModelAndView mv = new ModelAndView("farmerinsights");
        mv.addObject("farmer", farmer);
        mv.addObject("analytics", analyticsService.getFarmerAnalytics(farmer.getId()));
        return mv;
    }

    // =====================================================================
    // ADD PRODUCT
    // =====================================================================

    @GetMapping("farmeraddproduct")
    public ModelAndView addProductPage() {
        return new ModelAndView("farmeraddproduct");
    }

    @PostMapping("farmeraddproduct")
    public ModelAndView addProduct(HttpServletRequest request, HttpSession session) {
        Integer farmerId = currentFarmerId(session);

        Product product = new Product();
        product.setName(trim(request.getParameter("name")));
        product.setType(trim(request.getParameter("type")));
        product.setPrice(trim(request.getParameter("price")));
        product.setQuantity(defaultIfBlank(trim(request.getParameter("quantity")), "0"));
        product.setUnit(defaultIfBlank(trim(request.getParameter("unit")), "kg"));
        product.setLocation(trim(request.getParameter("location")));
        product.setContact(trim(request.getParameter("contact")));
        product.setSpecification(trim(request.getParameter("specification")));
        product.setDate(defaultIfBlank(trim(request.getParameter("date")),
                java.time.LocalDate.now().toString()));
        product.setDescription(trim(request.getParameter("description")));
        product.setState(defaultIfBlank(trim(request.getParameter("state")), "Andhra Pradesh"));
        // image1/image2 arrive either as a plain URL or as a base64 data URI
        // from the upload option on the form - both are just strings to this
        // column, so no extra handling is needed here.
        product.setImage(trim(request.getParameter("image1")));
        product.setImage2(trim(request.getParameter("image2")));
        product.setRequest(1);
        product.setFarmerId(farmerId);

        String message = farmerService.addProduct(product);

        ModelAndView mv = new ModelAndView("farmeraddproduct");
        mv.addObject("message", message);
        return mv;
    }

    // =====================================================================
    // REQUEST ADMIN ASSISTANCE FOR A LISTING (request = 0)
    // =====================================================================

    @GetMapping("farmerreqadding")
    public ModelAndView askAddProductPage() {
        return new ModelAndView("farmerreqadding");
    }

    @PostMapping("farmerreqadding")
    public ModelAndView askAddProduct(HttpServletRequest request, HttpSession session) {
        Integer farmerId = currentFarmerId(session);

        Product product = new Product();
        product.setName(trim(request.getParameter("name")));
        product.setType(trim(request.getParameter("type")));
        product.setPrice(trim(request.getParameter("price")));
        product.setQuantity(defaultIfBlank(trim(request.getParameter("quantity")), "0"));
        product.setSpecification(trim(request.getParameter("specification")));
        product.setContact(trim(request.getParameter("contact")));
        product.setDate(defaultIfBlank(trim(request.getParameter("date")),
                java.time.LocalDate.now().toString()));
        product.setState("Andhra Pradesh");
        product.setRequest(0);
        product.setFarmerId(farmerId);

        String message = farmerService.addProduct(product);

        ModelAndView mv = new ModelAndView("farmerreqadding");
        mv.addObject("message", "Request submitted. " + message);
        return mv;
    }

    // =====================================================================
    // MY PRODUCTS
    // =====================================================================

    @GetMapping("/farmerproducts")
    public ModelAndView viewFarmerProducts(HttpSession session) {
        Integer farmerId = currentFarmerId(session);
        ModelAndView mv = new ModelAndView("farmerproducts");
        mv.addObject("products", farmerService.getProductsByFarmerId(farmerId));
        return mv;
    }

    @GetMapping("/farmerupdateproduct")
    public ModelAndView farmerUpdateProduct(HttpSession session) {
        Integer farmerId = currentFarmerId(session);
        ModelAndView mv = new ModelAndView("farmerupdateproduct");
        mv.addObject("products", farmerService.getProductsByFarmerId(farmerId));
        mv.addObject("farmerId", farmerId);
        return mv;
    }

    @PostMapping("/updateproduct")
    public String updateProduct(@RequestParam("id") int id,
                                @RequestParam("name") String name,
                                @RequestParam("specification") String specification,
                                @RequestParam("type") String type,
                                @RequestParam("price") String price,
                                @RequestParam("quantity") String quantity,
                                @RequestParam(value = "unit", required = false) String unit,
                                @RequestParam(value = "location", required = false) String location,
                                @RequestParam(value = "image", required = false) String image,
                                @RequestParam(value = "description", required = false) String description,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {

        Integer farmerId = currentFarmerId(session);
        Product product = productService.getProductById(id);

        // The old version bound a whole Product via @ModelAttribute and saved it
        // blindly. Any farmer could POST another farmer's product id and
        // overwrite it, and unbound fields were silently wiped to null.
        if (product == null) {
            redirectAttributes.addFlashAttribute("message", "Product not found.");
            return "redirect:/farmerupdateproduct";
        }
        if (!java.util.Objects.equals(product.getFarmerId(), farmerId)) {
            redirectAttributes.addFlashAttribute("message", "You can only edit your own products.");
            return "redirect:/farmerupdateproduct";
        }

        product.setName(trim(name));
        product.setSpecification(trim(specification));
        product.setType(trim(type));
        product.setPrice(trim(price));
        product.setQuantity(trim(quantity));
        if (unit != null && !unit.isBlank()) {
            product.setUnit(trim(unit));
        }
        if (location != null && !location.isBlank()) {
            product.setLocation(trim(location));
        }
        if (image != null && !image.isBlank()) {
            product.setImage(trim(image));
        }
        if (description != null) {
            product.setDescription(trim(description));
        }

        redirectAttributes.addFlashAttribute("message", productService.updateProduct(product));
        return "redirect:/farmerupdateproduct";
    }

    // =====================================================================
    // DELETE PRODUCT
    // =====================================================================

    @GetMapping("/farmerdeleteproduct")
    public ModelAndView farmerDeleteProduct(HttpSession session) {
        Integer farmerId = currentFarmerId(session);
        ModelAndView mv = new ModelAndView("farmerdeleteproduct");
        mv.addObject("products", farmerService.getProductsByFarmerId(farmerId));
        return mv;
    }

    @PostMapping("/deleteproduct")
    public ModelAndView deleteProduct(@RequestParam("id") int productId,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        Integer farmerId = currentFarmerId(session);
        String message = farmerService.deleteProduct(farmerId, productId);
        redirectAttributes.addFlashAttribute("message", message);
        return new ModelAndView("redirect:/farmerdeleteproduct");
    }

    // =====================================================================
    // BROWSE
    // =====================================================================

    @GetMapping("farmerviewallproducts")
    public ModelAndView farmerViewAllProducts() {
        ModelAndView mv = new ModelAndView("farmerviewallproducts");
        List<Product> products = farmerService.viewAllProducts();
        mv.addObject("productlist", products);
        mv.addObject("productslist", products);  // some JSPs use this name
        return mv;
    }

    @GetMapping("farmerviewallusers")
    public ModelAndView farmerViewAllUsers() {
        ModelAndView mv = new ModelAndView("farmerviewallusers");
        List<User> users = farmerService.viewAllUsers();
        mv.addObject("userlist", users);
        mv.addObject("userslist", users);
        return mv;
    }

    // =====================================================================
    // PROFILE
    // =====================================================================

    @GetMapping("farmerupdateprofile")
    public ModelAndView viewProfile(HttpSession session) {
        Farmer farmer = currentFarmer(session);
        ModelAndView mv = new ModelAndView("farmerupdateprofile");
        mv.addObject("farmer", farmer);
        return mv;
    }

    @PostMapping("updatefarmerprofile")
    public ModelAndView updateFarmerProfile(@RequestParam("password") String password,
                                            @RequestParam("name") String name,
                                            @RequestParam("username") String username,
                                            @RequestParam(value = "email", required = false) String email,
                                            @RequestParam("phone") String phone,
                                            @RequestParam("address") String address,
                                            @RequestParam("state") String state,
                                            HttpSession session,
                                            RedirectAttributes redirectAttributes) {

        Farmer farmer = currentFarmer(session);

        if (!farmerService.verifyPassword(farmer, password)) {
            ModelAndView mv = new ModelAndView("farmerupdateprofile");
            mv.addObject("farmer", farmer);
            mv.addObject("error", "Invalid password. Please try again.");
            return mv;
        }

        farmer.setName(trim(name));
        farmer.setUsername(trim(username));
        farmer.setPhone(trim(phone));
        farmer.setAddress(trim(address));
        farmer.setState(trim(state));
        if (email != null && !email.isBlank()) {
            farmer.setEmail(trim(email));
        }

        String message = farmerService.updateFarmer1(farmer);
        session.setAttribute("farmer", farmer);
        redirectAttributes.addFlashAttribute("message", message);
        return new ModelAndView("redirect:/farmerupdateprofile");
    }

    // =====================================================================
    // PASSWORD RESET (OTP based) - see the note in UserController
    // =====================================================================

    @GetMapping("/forgetpassword")
    public ModelAndView forgetPassword() {
        return new ModelAndView("forgetPassword");
    }

    @PostMapping("/validateUser")
    public ModelAndView validateFarmer(@RequestParam("username") String username,
                                       @RequestParam("email") String email,
                                       HttpSession session) {

        Farmer farmer = farmerService.findByUsernameAndEmail(trim(username), trim(email));

        if (farmer != null) {
            String code = otpService.issue("farmer:" + farmer.getUsername());
            session.setAttribute("resetUsername", farmer.getUsername());
            session.setAttribute("resetRole", "farmer");
            mailService.send(farmer.getEmail(), "Your FarmConnect password reset code",
                    "<p>Your password reset code is <b>" + code + "</b>.</p>"
                  + "<p>It expires in 10 minutes. If you did not request this, ignore this email.</p>");
        }

        ModelAndView mv = new ModelAndView("verifyOtp");
        mv.addObject("role", "farmer");
        mv.addObject("message",
                "If that account exists, we have emailed a 6-digit code. Enter it below.");
        return mv;
    }

    @PostMapping("/verifyOtp")
    public ModelAndView verifyOtp(@RequestParam("code") String code, HttpSession session) {
        String username = (String) session.getAttribute("resetUsername");
        if (username == null) {
            return new ModelAndView("redirect:/forgetpassword");
        }
        if (!otpService.verify("farmer:" + username, trim(code))) {
            ModelAndView mv = new ModelAndView("verifyOtp");
            mv.addObject("role", "farmer");
            mv.addObject("error", "That code is incorrect or has expired.");
            return mv;
        }
        session.setAttribute("resetVerified", Boolean.TRUE);
        return new ModelAndView("redirect:/setPassword");
    }

    @GetMapping("/setPassword")
    public ModelAndView setPasswordPage(HttpSession session) {
        if (!Boolean.TRUE.equals(session.getAttribute("resetVerified"))) {
            return new ModelAndView("redirect:/forgetpassword");
        }
        ModelAndView mv = new ModelAndView("setPassword");
        mv.addObject("username", session.getAttribute("resetUsername"));
        return mv;
    }

    @PostMapping("/updatePassword")
    public ModelAndView updatePassword(@RequestParam("newPassword") String newPassword,
                                       @RequestParam("confirmPassword") String confirmPassword,
                                       HttpSession session) {

        if (!Boolean.TRUE.equals(session.getAttribute("resetVerified"))) {
            return new ModelAndView("redirect:/forgetpassword");
        }
        String username = (String) session.getAttribute("resetUsername");

        if (!newPassword.equals(confirmPassword)) {
            ModelAndView mv = new ModelAndView("setPassword");
            mv.addObject("username", username);
            mv.addObject("message", "Passwords do not match!");
            return mv;
        }

        String result = farmerService.changePassword(username, newPassword);
        if (!result.startsWith("Password changed")) {
            ModelAndView mv = new ModelAndView("setPassword");
            mv.addObject("username", username);
            mv.addObject("message", result);
            return mv;
        }

        session.removeAttribute("resetVerified");
        session.removeAttribute("resetUsername");

        ModelAndView mv = new ModelAndView("login");
        mv.addObject("message", result);
        return mv;
    }

    // =====================================================================

    private Farmer currentFarmer(HttpSession session) {
        Farmer farmer = (Farmer) session.getAttribute("farmer");
        if (farmer == null) {
            throw new SessionExpiredException("/login");
        }
        return farmer;
    }

    private Integer currentFarmerId(HttpSession session) {
        Integer id = (Integer) session.getAttribute("loggedInFarmerId");
        if (id == null) {
            throw new SessionExpiredException("/login");
        }
        return id;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String defaultIfBlank(String value, String fallback) {
        return (value == null || value.isBlank()) ? fallback : value;
    }
}
