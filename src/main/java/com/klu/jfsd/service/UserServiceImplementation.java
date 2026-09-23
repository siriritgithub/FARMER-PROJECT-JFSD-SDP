package com.klu.jfsd.service;

import java.util.Collections;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;
import com.klu.jfsd.repository.FarmerRepository;
import com.klu.jfsd.repository.ProductRepository;
import com.klu.jfsd.repository.UserRepository;
import com.klu.jfsd.security.PasswordService;

@Service
public class UserServiceImplementation implements UserService {

    private static final Logger log = LoggerFactory.getLogger(UserServiceImplementation.class);

    private final UserRepository userRepository;
    private final FarmerRepository farmerRepository;
    private final ProductRepository productRepository;
    private final PasswordService passwordService;
    private final MailService mailService;

    public UserServiceImplementation(UserRepository userRepository,
                                     FarmerRepository farmerRepository,
                                     ProductRepository productRepository,
                                     PasswordService passwordService,
                                     MailService mailService) {
        this.userRepository = userRepository;
        this.farmerRepository = farmerRepository;
        this.productRepository = productRepository;
        this.passwordService = passwordService;
        this.mailService = mailService;
    }

    @Override
    public String userRegistration(User user) {
        if (user.getUsername() == null || user.getUsername().isBlank()) {
            return "Username is required.";
        }
        if (user.getPassword() == null || user.getPassword().length() < 6) {
            return "Password must be at least 6 characters.";
        }
        // The old code went straight to save() and let a duplicate-key
        // exception bubble up as a generic failure message.
        if (userRepository.existsByUsername(user.getUsername())) {
            return "That username is already taken. Please choose another.";
        }
        try {
            user.setPassword(passwordService.encode(user.getPassword()));
            user.setUserApproval(false);
            userRepository.save(user);
            return "Registration successful. An admin will approve your account shortly.";
        } catch (Exception e) {
            log.error("User registration failed", e);
            return "Registration failed. Please try again.";
        }
    }

    @Override
    @Transactional
    public User checkUserLogin(String username, String rawPassword) {
        if (username == null || rawPassword == null) {
            return null;
        }
        User user = userRepository.findByUsername(username);
        if (user == null || !passwordService.matches(rawPassword, user.getPassword())) {
            return null;
        }
        // Silently upgrade legacy plain-text rows to BCrypt on successful login.
        if (passwordService.needsUpgrade(user.getPassword())) {
            user.setPassword(passwordService.encode(rawPassword));
            userRepository.save(user);
            log.info("Upgraded password hash for user '{}'", username);
        }
        return user;
    }

    @Override
    public List<Farmer> viewAllFarmers() {
        return farmerRepository.findAll();
    }

    @Override
    public List<Product> viewAllProducts() {
        // Only products the admin has released (request = 1) should be visible.
        return productRepository.findByRequest(1);
    }

    @Override
    public List<Product> getProductsByType(String type) {
        if (type == null || type.isBlank()) {
            return viewAllProducts();
        }
        return productRepository.findByType(type);
    }

    @Override
    public List<Product> getProductsBySpecification(String specification) {
        if (specification == null || specification.isBlank()) {
            return viewAllProducts();
        }
        List<Product> found = productRepository.findBySpecification(specification);
        return found == null ? Collections.emptyList() : found;
    }

    @Override
    public List<User> getAllPendingUsers() {
        return userRepository.findByUserApproval(false);
    }

    @Override
    public void approveUser(int userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found: " + userId));
        user.setUserApproval(true);
        userRepository.save(user);
        mailService.send(user.getEmail(), "Your FarmConnect account is approved",
                "<p>Hello " + escape(user.getName()) + ",</p>"
              + "<p>Your account has been approved. You can now log in and start shopping.</p>");
    }

    @Override
    public void rejectUser(int userId) {
        User user = userRepository.findById(userId).orElse(null);
        if (user == null) {
            return;
        }
        mailService.send(user.getEmail(), "Your FarmConnect registration was not approved",
                "<p>Hello " + escape(user.getName()) + ",</p>"
              + "<p>Unfortunately your registration was not approved at this time.</p>");
        userRepository.deleteById(userId);
    }

    @Override
    public String updateUser(User user) {
        try {
            userRepository.save(user);
            return "Profile updated successfully.";
        } catch (Exception e) {
            log.error("User update failed", e);
            return "Update unsuccessful, please try again.";
        }
    }

    @Override
    public User findByUsernameAndPhone(String username, String phone) {
        return userRepository.findByUsernameAndPhone(username, phone);
    }

    @Override
    public User findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public User findByUsernameAndEmail(String username, String email) {
        if (username == null || email == null) {
            return null;
        }
        return userRepository.findByUsernameAndEmailIgnoreCase(username, email);
    }

    @Override
    public User getUserById(int userId) {
        return userRepository.findById(userId).orElse(null);
    }

    @Override
    public boolean verifyPassword(User currentUser, String rawPassword) {
        return currentUser != null
                && passwordService.matches(rawPassword, currentUser.getPassword());
    }

    @Override
    public String changePassword(String username, String newRawPassword) {
        User user = userRepository.findByUsername(username);
        if (user == null) {
            return "User not found.";
        }
        if (newRawPassword == null || newRawPassword.length() < 6) {
            return "Password must be at least 6 characters.";
        }
        user.setPassword(passwordService.encode(newRawPassword));
        userRepository.save(user);
        return "Password changed successfully. Please log in.";
    }

    @Override
    public void deleteUser(int id, String reason) {
        User user = getUserById(id);
        if (user == null) {
            return;
        }
        mailService.send(user.getEmail(), "FarmConnect account deletion notice",
                "<p>Dear " + escape(user.getName()) + ",</p>"
              + "<p>Your account has been removed for the following reason:</p>"
              + "<blockquote>" + escape(reason) + "</blockquote>"
              + "<p>Regards,<br/>FarmConnect Admin</p>");
        userRepository.deleteById(id);
    }

    @Override
    public int getCount() {
        return userRepository.countAll();
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("<", "&lt;").replace(">", "&gt;");
    }
}
