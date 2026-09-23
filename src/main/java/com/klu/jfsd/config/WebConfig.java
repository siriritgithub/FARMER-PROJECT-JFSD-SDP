package com.klu.jfsd.config;

import com.klu.jfsd.security.AuthInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Wires up role-based access control.
 *
 * Public (no login needed): /, /home, /aboutus, /services, /help, /feedbackus,
 * /submitContact, all login + registration + password-reset endpoints.
 * Everything else is locked to the matching role.
 */
@Configuration
public class WebConfig implements WebMvcConfigurer {

    private static final String[] ADMIN_PATHS = {
            "/adminhome",
            "/admin/**",
            "/adminviewallfarmers", "/adminviewallusers", "/adminviewallproducts",
            "/adminviewfeedbacks", "/adminviewanalytics",
            "/adminapprovefarmers", "/adminapproveusers",
            "/admindeletefarmers", "/admindeleteusers",
            "/adminassistrequest", "/adminupdateprofile",
            "/addfarmer", "/adduser", "/addproduct",
            "/adminaddfarmer", "/adminaddUser", "/adminaddproduct",
            "/approvefarmer", "/rejectfarmer", "/approveuser", "/rejectuser",
            "/deleteFarmer", "/deleteUser",
            "/updateProduct", "/updateAdminProfile",
            "/resolvefeedback", "/admindeleteproduct"
    };

    private static final String[] FARMER_PATHS = {
            "/farmerhome",
            "/farmeraddproduct", "/farmerreqadding",
            "/farmerproducts", "/farmerupdateproduct", "/updateproduct",
            "/farmerdeleteproduct", "/deleteproduct",
            "/farmerviewallproducts", "/farmerviewallusers",
            "/farmerupdateprofile", "/updatefarmerprofile",
            "/farmerinsights"
    };

    private static final String[] USER_PATHS = {
            "/userhome",
            "/userviewallfarmers", "/userviewallproducts", "/userviewallproducts1",
            "/userbuyproducts", "/userbuyproductsbyname",
            "/filterproducts", "/productdetails", "/userviewproduct",
            "/userupdateprofile", "/updateuserprofile",
            "/placeorder", "/myorders", "/orderconfirmation",
            "/userpaymentdetails",
            "/cart", "/cart/**",
            "/wishlist", "/wishlist/**",
            "/myinsights"
    };

    @Override
    public void addInterceptors(InterceptorRegistry registry) {

        registry.addInterceptor(new AuthInterceptor("loggedAdmin", "/adminlogin", "admin"))
                .addPathPatterns(ADMIN_PATHS);

        registry.addInterceptor(new AuthInterceptor("farmer", "/login", "farmer"))
                .addPathPatterns(FARMER_PATHS);

        registry.addInterceptor(new AuthInterceptor("user", "/userlogin", "user"))
                .addPathPatterns(USER_PATHS);
    }
}
