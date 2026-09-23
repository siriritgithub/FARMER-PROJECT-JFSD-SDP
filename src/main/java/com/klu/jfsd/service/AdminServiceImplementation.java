package com.klu.jfsd.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.klu.jfsd.model.Admin;
import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;
import com.klu.jfsd.repository.AdminRepository;
import com.klu.jfsd.repository.FarmerRepository;
import com.klu.jfsd.repository.FeedbackRepository;
import com.klu.jfsd.repository.ProductRepository;
import com.klu.jfsd.repository.UserRepository;
import com.klu.jfsd.security.PasswordService;

@Service
public class AdminServiceImplementation implements AdminService {

    private static final Logger log = LoggerFactory.getLogger(AdminServiceImplementation.class);

    private final AdminRepository adminRepository;
    private final FarmerRepository farmerRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final FeedbackRepository feedbackRepository;
    private final PasswordService passwordService;

    public AdminServiceImplementation(AdminRepository adminRepository,
                                      FarmerRepository farmerRepository,
                                      UserRepository userRepository,
                                      ProductRepository productRepository,
                                      FeedbackRepository feedbackRepository,
                                      PasswordService passwordService) {
        this.adminRepository = adminRepository;
        this.farmerRepository = farmerRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
        this.feedbackRepository = feedbackRepository;
        this.passwordService = passwordService;
    }

    @Override
    @Transactional
    public Admin checkAdminLogin(String username, String rawPassword) {
        if (username == null || rawPassword == null) {
            return null;
        }
        Admin admin = adminRepository.findByUsername(username);
        if (admin == null || !passwordService.matches(rawPassword, admin.getPassword())) {
            return null;
        }
        if (passwordService.needsUpgrade(admin.getPassword())) {
            admin.setPassword(passwordService.encode(rawPassword));
            adminRepository.save(admin);
            log.info("Upgraded password hash for admin '{}'", username);
        }
        return admin;
    }

    @Override
    public Admin getAdminByUsername(String username) {
        return adminRepository.findByUsername(username);
    }

    @Override
    public String updateAdminProfile(String username, String currentPassword,
                                     String newPassword, String newEmail) {
        Admin admin = adminRepository.findByUsername(username);
        if (admin == null) {
            return "Admin account not found.";
        }
        if (!passwordService.matches(currentPassword, admin.getPassword())) {
            return "Current password is incorrect!";
        }
        if (newEmail != null && !newEmail.isBlank()) {
            admin.setEmail(newEmail);
        }
        if (newPassword != null && !newPassword.isBlank()) {
            if (newPassword.length() < 6) {
                return "New password must be at least 6 characters.";
            }
            admin.setPassword(passwordService.encode(newPassword));
        }
        adminRepository.save(admin);
        return "Profile updated successfully!";
    }

    @Override
    public List<Farmer> viewAllFarmers() {
        return farmerRepository.findAll();
    }

    @Override
    public List<Product> viewAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public List<User> viewAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public String addFarmer(Farmer farmer) {
        if (farmer.getUsername() == null || farmer.getUsername().isBlank()) {
            return "Username is required.";
        }
        if (farmerRepository.existsByUsername(farmer.getUsername())) {
            return "That username is already taken.";
        }
        try {
            farmer.setPassword(passwordService.encode(farmer.getPassword()));
            // An admin-created farmer is trusted, so it is approved immediately.
            farmer.setApproved(true);
            farmerRepository.save(farmer);
            return "Farmer added successfully!";
        } catch (Exception e) {
            log.error("Add farmer failed", e);
            return "Something went wrong while adding the farmer. Please try again.";
        }
    }

    @Override
    public String addUser(User user) {
        if (user.getUsername() == null || user.getUsername().isBlank()) {
            return "Username is required.";
        }
        if (userRepository.existsByUsername(user.getUsername())) {
            return "That username is already taken.";
        }
        try {
            user.setPassword(passwordService.encode(user.getPassword()));
            user.setUserApproval(true);
            userRepository.save(user);
            return "User added successfully!";
        } catch (Exception e) {
            log.error("Add user failed", e);
            return "Something went wrong while adding the user. Please try again.";
        }
    }

    @Override
    public String addProduct(Product product) {
        try {
            productRepository.save(product);
            return "Product added successfully!";
        } catch (Exception e) {
            log.error("Add product failed", e);
            return "Something went wrong while adding the product. Please try again.";
        }
    }

    @Override
    public int getFeedbackCount() {
        return feedbackRepository.countAll();
    }
}
