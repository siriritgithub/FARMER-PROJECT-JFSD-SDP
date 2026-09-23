package com.klu.jfsd.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.klu.jfsd.model.Admin;
import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Feedback;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;
import com.klu.jfsd.service.AdminService;
import com.klu.jfsd.service.FarmerService;
import com.klu.jfsd.service.FeedbackService;
import com.klu.jfsd.service.OrderService;
import com.klu.jfsd.service.ProductService;
import com.klu.jfsd.service.UserService;
import com.klu.jfsd.service.AnalyticsService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class AdminController {

    private final AdminService adminService;
    private final FarmerService farmerService;
    private final UserService userService;
    private final ProductService productService;
    private final FeedbackService feedbackService;
    private final OrderService orderService;
    private final AnalyticsService analyticsService;

    public AdminController(AdminService adminService,
                           FarmerService farmerService,
                           UserService userService,
                           ProductService productService,
                           FeedbackService feedbackService,
                           OrderService orderService,
                           AnalyticsService analyticsService) {
        this.adminService = adminService;
        this.farmerService = farmerService;
        this.userService = userService;
        this.productService = productService;
        this.feedbackService = feedbackService;
        this.orderService = orderService;
        this.analyticsService = analyticsService;
    }

    // =====================================================================
    // PUBLIC PAGES
    // =====================================================================

    @GetMapping("/")
    public ModelAndView root() {
        return new ModelAndView("redirect:/home");
    }

    @GetMapping("/home")
    public ModelAndView homePage() {
        return new ModelAndView("home");
    }

    @GetMapping("aboutus")
    public ModelAndView aboutUs() {
        return new ModelAndView("homeaboutus");
    }

    @GetMapping("services")
    public ModelAndView services() {
        return new ModelAndView("homeservices");
    }

    @GetMapping("help")
    public ModelAndView help() {
        return new ModelAndView("home247");
    }

    @GetMapping("feedbackus")
    public ModelAndView feedbackUs() {
        return new ModelAndView("homefeedbackus");
    }

    /**
     * The old version returned the view name "contactus", but no contactus.jsp
     * exists anywhere in the project, so submitting the contact form always
     * produced an error page even though the row was saved.
     */
    @PostMapping("/submitContact")
    public ModelAndView submitContact(@RequestParam("name") String name,
                                      @RequestParam("userType") String userType,
                                      @RequestParam("email") String email,
                                      @RequestParam("subject") String subject,
                                      @RequestParam("message") String message) {

        Feedback feedback = new Feedback();
        feedback.setName(trim(name));
        feedback.setAccessor(trim(userType));
        feedback.setEmail(trim(email));
        feedback.setSubject(trim(subject));
        feedback.setMessage(trim(message));

        String result = feedbackService.saveFeedback(feedback);

        ModelAndView mv = new ModelAndView("homefeedbackus");
        mv.addObject("message", result);
        return mv;
    }

    // =====================================================================
    // LOGIN / LOGOUT
    // =====================================================================

    @GetMapping("/adminlogin")
    public ModelAndView adminLogin(@RequestParam(value = "expired", required = false) String expired) {
        ModelAndView mv = new ModelAndView("adminlogin");
        if (expired != null) {
            mv.addObject("message", "Please log in to continue.");
        }
        return mv;
    }

    @PostMapping("checkadminlogin")
    public ModelAndView checkAdminLogin(HttpServletRequest request, HttpSession session) {
        String username = trim(request.getParameter("admin-username"));
        String password = request.getParameter("admin-password");

        Admin admin = adminService.checkAdminLogin(username, password);

        ModelAndView mv = new ModelAndView();
        if (admin == null) {
            mv.setViewName("adminlogin");
            mv.addObject("message", "Login failed! Please try again.");
            return mv;
        }

        session.invalidate();
        HttpSession fresh = request.getSession(true);
        fresh.setAttribute("loggedAdmin", admin);

        mv.setViewName("redirect:/adminhome");
        return mv;
    }

    @GetMapping("/adminlogout")
    public String adminLogout(HttpSession session) {
        session.invalidate();
        return "redirect:/adminlogin";
    }

    // =====================================================================
    // HOME + DASHBOARD
    // =====================================================================

    @GetMapping("adminhome")
    public ModelAndView adminHome(HttpSession session) {
        Admin admin = currentAdmin(session);
        ModelAndView mv = new ModelAndView("adminhome");
        mv.addObject("admin", admin);
        mv.addObject("pendingFarmers", farmerService.getUnapprovedFarmers().size());
        mv.addObject("pendingUsers", userService.getAllPendingUsers().size());
        mv.addObject("pendingFeedback", feedbackService.getPendingCount());
        return mv;
    }

    /**
     * Income used to be a literal 0 with a comment saying it was "assumed" to
     * come from orders. It is now summed from the orders table.
     */
    @GetMapping("/admin/dashboard")
    public ModelAndView showAdminDashboard() {
        ModelAndView mv = new ModelAndView("adminviewanalytics");
        mv.addObject("farmersCount", farmerService.getCount());
        mv.addObject("usersCount", userService.getCount());
        mv.addObject("productsCount", productService.getCount());
        mv.addObject("feedbackCount", feedbackService.getCount());
        mv.addObject("ordersCount", orderService.getCount());
        mv.addObject("income", orderService.getTotalRevenue());
        mv.addObject("recentOrders", orderService.getAllOrders());
        mv.addObject("pendingFarmers", farmerService.getUnapprovedFarmers().size());
        mv.addObject("pendingUsers", userService.getAllPendingUsers().size());
        mv.addObject("pendingFeedback", feedbackService.getPendingCount());
        mv.addObject("platform", analyticsService.getPlatformAnalytics());
        return mv;
    }

    // =====================================================================
    // ADD RECORDS
    // =====================================================================

    @GetMapping("addfarmer")
    public ModelAndView addFarmerPage() {
        return new ModelAndView("addfarmer");
    }

    @PostMapping("adminaddfarmer")
    public ModelAndView adminAddFarmer(HttpServletRequest request) {
        Farmer farmer = new Farmer();
        farmer.setName(trim(request.getParameter("name")));
        farmer.setPhone(trim(request.getParameter("phone")));
        farmer.setUsername(trim(request.getParameter("username")));
        farmer.setAddress(trim(request.getParameter("address")));
        farmer.setState(trim(request.getParameter("state")));
        farmer.setPassword(request.getParameter("password"));
        farmer.setEmail(trim(request.getParameter("email")));

        String image = trim(request.getParameter("image"));
        if (image != null && !image.isBlank()) {
            farmer.setImage(image);
        }

        ModelAndView mv = new ModelAndView("addfarmer");
        mv.addObject("message", adminService.addFarmer(farmer));
        return mv;
    }

    @GetMapping("adduser")
    public ModelAndView addUserPage() {
        return new ModelAndView("adduser");
    }

    @PostMapping("adminaddUser")
    public ModelAndView adminAddUser(HttpServletRequest request) {
        User user = new User();
        user.setName(trim(request.getParameter("name")));
        user.setPhone(trim(request.getParameter("phone")));
        user.setUsername(trim(request.getParameter("username")));
        user.setAddress(trim(request.getParameter("address")));
        user.setState(trim(request.getParameter("state")));
        user.setPassword(request.getParameter("password"));
        user.setEmail(trim(request.getParameter("email")));
        user.setImageUrl(trim(request.getParameter("image")));

        ModelAndView mv = new ModelAndView("adduser");
        mv.addObject("message", adminService.addUser(user));
        return mv;
    }

    @GetMapping("addproduct")
    public ModelAndView addProductPage() {
        return new ModelAndView("addproduct");
    }

    @PostMapping("adminaddproduct")
    public ModelAndView adminAddProduct(HttpServletRequest request) {
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
        product.setImage(trim(request.getParameter("image")));
        product.setDescription(trim(request.getParameter("description")));
        product.setState(defaultIfBlank(trim(request.getParameter("state")), "Andhra Pradesh"));
        product.setRequest(1);

        ModelAndView mv = new ModelAndView("addproduct");
        mv.addObject("message", adminService.addProduct(product));
        return mv;
    }

    // =====================================================================
    // FARMER LISTING REQUESTS (request = 0)
    // =====================================================================

    @GetMapping("/adminassistrequest")
    public ModelAndView showProductsForAdmin() {
        ModelAndView mv = new ModelAndView("adminassistrequest");
        mv.addObject("products", productService.getProductsByRequest(0));
        return mv;
    }

    @PostMapping("/updateProduct")
    public String updateProduct(@RequestParam("id") int id,
                                @RequestParam("name") String name,
                                @RequestParam("specification") String specification,
                                @RequestParam("type") String type,
                                @RequestParam("price") String price,
                                @RequestParam("quantity") String quantity,
                                @RequestParam(value = "location", required = false) String location,
                                @RequestParam(value = "state", required = false) String state,
                                @RequestParam(value = "image", required = false) String image,
                                @RequestParam(value = "description", required = false) String description,
                                RedirectAttributes redirectAttributes) {

        Product product = productService.getProductById(id);
        if (product == null) {
            redirectAttributes.addFlashAttribute("message", "Product not found.");
            return "redirect:/adminassistrequest";
        }

        product.setName(trim(name));
        product.setSpecification(trim(specification));
        product.setType(trim(type));
        product.setPrice(trim(price));
        product.setQuantity(trim(quantity));
        product.setLocation(trim(location));
        product.setState(trim(state));
        product.setImage(trim(image));
        product.setDescription(trim(description));
        product.setRequest(1);   // release it to the marketplace

        redirectAttributes.addFlashAttribute("message", productService.updateProduct(product));
        return "redirect:/adminassistrequest";
    }

    // =====================================================================
    // VIEW
    // =====================================================================

    @GetMapping("adminviewallfarmers")
    public ModelAndView adminViewAllFarmers() {
        ModelAndView mv = new ModelAndView("adminviewallfarmers");
        mv.addObject("farmerslist", adminService.viewAllFarmers());
        return mv;
    }

    @GetMapping("adminviewallusers")
    public ModelAndView adminViewAllUsers() {
        ModelAndView mv = new ModelAndView("adminviewallusers");
        mv.addObject("userslist", adminService.viewAllUsers());
        return mv;
    }

    @GetMapping("adminviewallproducts")
    public ModelAndView adminViewAllProducts() {
        ModelAndView mv = new ModelAndView("adminviewallproducts");
        mv.addObject("productslist", adminService.viewAllProducts());
        return mv;
    }

    /** Lets admin remove any listing platform-wide - e.g. inappropriate or duplicate entries. */
    @PostMapping("/admindeleteproduct")
    public String adminDeleteProduct(@RequestParam("id") int id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("message", productService.deleteProduct(id));
        return "redirect:/adminviewallproducts";
    }

    /**
     * adminviewfeedbacks.jsp existed in the project but had no mapping and no
     * service method, so the admin could never read a single message.
     */
    @GetMapping("adminviewfeedbacks")
    public ModelAndView adminViewFeedbacks() {
        ModelAndView mv = new ModelAndView("adminviewfeedbacks");
        List<Feedback> feedbacks = feedbackService.getAllFeedback();
        mv.addObject("feedbacks", feedbacks);
        mv.addObject("feedbackslist", feedbacks);
        return mv;
    }

    @PostMapping("/resolvefeedback")
    public String resolveFeedback(@RequestParam("id") int id,
                                  @RequestParam(value = "reply", required = false) String reply,
                                  RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("message", feedbackService.resolveFeedback(id, reply));
        return "redirect:/adminviewfeedbacks";
    }

    // =====================================================================
    // DELETE
    // =====================================================================

    @GetMapping("/admindeletefarmers")
    public ModelAndView viewFarmersForDelete() {
        ModelAndView mv = new ModelAndView("admindeletefarmer");
        mv.addObject("farmerslist", adminService.viewAllFarmers());
        return mv;
    }

    /**
     * Previously this sent an email, reported "Email Sent Successfully" and then
     * called a service method whose body was an empty TODO stub, so the farmer
     * was never actually deleted.
     */
    @PostMapping("/deleteFarmer")
    public String deleteFarmer(@RequestParam("id") int id,
                               @RequestParam("reason") String reason,
                               RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("message", farmerService.deleteFarmer(id, reason));
        return "redirect:/admindeletefarmers";
    }

    @GetMapping("admindeleteusers")
    public ModelAndView viewUsersForDelete() {
        ModelAndView mv = new ModelAndView("admindeleteusers");
        mv.addObject("userslist", adminService.viewAllUsers());
        return mv;
    }

    @PostMapping("/deleteUser")
    public String deleteUser(@RequestParam("id") int id,
                             @RequestParam("reason") String reason,
                             RedirectAttributes redirectAttributes) {
        userService.deleteUser(id, reason);
        redirectAttributes.addFlashAttribute("message", "User deleted.");
        return "redirect:/admindeleteusers";
    }

    // =====================================================================
    // APPROVALS
    // =====================================================================

    @GetMapping("/adminapprovefarmers")
    public ModelAndView viewUnapprovedFarmers() {
        ModelAndView mv = new ModelAndView("adminapprovefarmer");
        mv.addObject("farmers", farmerService.getUnapprovedFarmers());
        return mv;
    }

    @PostMapping("/approvefarmer")
    public String approveFarmer(@RequestParam("farmerId") int farmerId,
                                RedirectAttributes redirectAttributes) {
        farmerService.approveFarmer(farmerId);
        redirectAttributes.addFlashAttribute("message", "Farmer approved.");
        return "redirect:/adminapprovefarmers";
    }

    @PostMapping("/rejectfarmer")
    public String rejectFarmer(@RequestParam("farmerId") int farmerId,
                               RedirectAttributes redirectAttributes) {
        farmerService.deleteFarmer(farmerId);
        redirectAttributes.addFlashAttribute("message", "Farmer registration rejected.");
        return "redirect:/adminapprovefarmers";
    }

    @GetMapping("/adminapproveusers")
    public ModelAndView showPendingUsers() {
        ModelAndView mv = new ModelAndView("adminapproveuser");
        mv.addObject("users", userService.getAllPendingUsers());
        return mv;
    }

    @PostMapping("/approveuser")
    public String approveUser(@RequestParam("userId") int userId,
                              RedirectAttributes redirectAttributes) {
        userService.approveUser(userId);
        redirectAttributes.addFlashAttribute("message", "User approved.");
        return "redirect:/adminapproveusers";
    }

    @PostMapping("/rejectuser")
    public String rejectUser(@RequestParam("userId") int userId,
                             RedirectAttributes redirectAttributes) {
        userService.rejectUser(userId);
        redirectAttributes.addFlashAttribute("message", "User registration rejected.");
        return "redirect:/adminapproveusers";
    }

    // =====================================================================
    // PROFILE
    // =====================================================================

    @GetMapping("/adminupdateprofile")
    public ModelAndView adminProfile(HttpSession session) {
        Admin admin = currentAdmin(session);
        ModelAndView mv = new ModelAndView("adminupdateprofile");
        mv.addObject("admin", admin);
        return mv;
    }

    @PostMapping("/updateAdminProfile")
    public ModelAndView updateAdminProfile(HttpSession session,
                                           @RequestParam(value = "email", required = false) String email,
                                           @RequestParam("currentPassword") String currentPassword,
                                           @RequestParam(value = "newPassword", required = false) String newPassword) {

        Admin admin = currentAdmin(session);

        // Identify the admin by the session, not by a form field. The old code
        // took the target account from a request parameter, so any logged-in
        // admin could edit another admin's record by changing the form.
        String message = adminService.updateAdminProfile(
                admin.getUsername(), currentPassword, newPassword, email);

        Admin refreshed = adminService.getAdminByUsername(admin.getUsername());
        session.setAttribute("loggedAdmin", refreshed);

        ModelAndView mv = new ModelAndView("adminupdateprofile");
        mv.addObject("admin", refreshed);
        mv.addObject("message", message);
        mv.addObject("status", message.contains("successfully") ? "success" : "error");
        return mv;
    }

    // =====================================================================

    private Admin currentAdmin(HttpSession session) {
        Admin admin = (Admin) session.getAttribute("loggedAdmin");
        if (admin == null) {
            throw new SessionExpiredException("/adminlogin");
        }
        return admin;
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String defaultIfBlank(String value, String fallback) {
        return (value == null || value.isBlank()) ? fallback : value;
    }
}
