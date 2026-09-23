package com.klu.jfsd.service;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

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
public class FarmerServiceImplementation implements FarmerService {

    private static final Logger log = LoggerFactory.getLogger(FarmerServiceImplementation.class);

    private final FarmerRepository farmerRepository;
    private final UserRepository userRepository;
    private final ProductRepository productRepository;
    private final PasswordService passwordService;
    private final MailService mailService;

    public FarmerServiceImplementation(FarmerRepository farmerRepository,
                                       UserRepository userRepository,
                                       ProductRepository productRepository,
                                       PasswordService passwordService,
                                       MailService mailService) {
        this.farmerRepository = farmerRepository;
        this.userRepository = userRepository;
        this.productRepository = productRepository;
        this.passwordService = passwordService;
        this.mailService = mailService;
    }

    @Override
    public String farmerRegestration(Farmer f) {
        if (f.getUsername() == null || f.getUsername().isBlank()) {
            return "Username is required.";
        }
        if (f.getPassword() == null || f.getPassword().length() < 6) {
            return "Password must be at least 6 characters.";
        }
        if (farmerRepository.existsByUsername(f.getUsername())) {
            return "That username is already taken. Please choose another.";
        }
        try {
            f.setPassword(passwordService.encode(f.getPassword()));
            f.setApproved(false);
            farmerRepository.save(f);
            return "Registration successful. An admin will approve your account shortly.";
        } catch (Exception e) {
            log.error("Farmer registration failed", e);
            return "Registration failed. Please try again.";
        }
    }

    @Override
    @Transactional
    public Farmer checkFarmerLogin(String username, String rawPassword) {
        if (username == null || rawPassword == null) {
            return null;
        }
        Farmer farmer = farmerRepository.findByUsername(username);
        if (farmer == null || !passwordService.matches(rawPassword, farmer.getPassword())) {
            return null;
        }
        if (passwordService.needsUpgrade(farmer.getPassword())) {
            farmer.setPassword(passwordService.encode(rawPassword));
            farmerRepository.save(farmer);
            log.info("Upgraded password hash for farmer '{}'", username);
        }
        return farmer;
    }

    @Override
    public List<User> viewAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public List<Product> viewAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Farmer getFarmerById(int id) {
        return farmerRepository.findById(id).orElse(null);
    }

    @Override
    public void updateFarmerprofile(Farmer farmer) {
        Farmer existing = farmerRepository.findById(farmer.getId()).orElse(null);
        if (existing == null) {
            return;
        }
        existing.setName(farmer.getName());
        existing.setUsername(farmer.getUsername());
        existing.setPhone(farmer.getPhone());
        existing.setAddress(farmer.getAddress());
        existing.setState(farmer.getState());
        if (farmer.getImage() != null && !farmer.getImage().isBlank()) {
            existing.setImage(farmer.getImage());
        }
        farmerRepository.save(existing);
    }

    @Override
    public List<Farmer> getUnapprovedFarmers() {
        return farmerRepository.findByApprovedFalse();
    }

    @Override
    public void approveFarmer(int farmerId) {
        Farmer farmer = farmerRepository.findById(farmerId).orElse(null);
        if (farmer == null) {
            return;
        }
        farmer.setApproved(true);
        farmerRepository.save(farmer);
        mailService.send(farmer.getEmail(), "Your FarmConnect farmer account is approved",
                "<p>Hello " + escape(farmer.getName()) + ",</p>"
              + "<p>Your account has been approved. You can now log in and list your produce.</p>");
    }

    @Override
    public void deleteFarmer(int farmerId) {
        removeFarmerAndProducts(farmerId);
    }

    /**
     * This used to be an empty method body with a "TODO Auto-generated method
     * stub" comment. The admin delete-farmer screen called it, showed
     * "Email Sent Successfully", and deleted nothing at all.
     */
    @Override
    @Transactional
    public String deleteFarmer(int farmerId, String reason) {
        Farmer farmer = getFarmerById(farmerId);
        if (farmer == null) {
            return "Farmer not found.";
        }
        String name = farmer.getName();
        String email = farmer.getEmail();

        boolean mailed = mailService.send(email, "FarmConnect account deletion notice",
                "<p>Dear " + escape(name) + ",</p>"
              + "<p>Your farmer account has been removed for the following reason:</p>"
              + "<blockquote>" + escape(reason) + "</blockquote>"
              + "<p>Regards,<br/>FarmConnect Admin</p>");

        removeFarmerAndProducts(farmerId);

        return mailed
                ? "Farmer '" + name + "' deleted and notified by email."
                : "Farmer '" + name + "' deleted. (No notification email was sent.)";
    }

    /** Products carry a farmer id with no FK cascade, so clean them up explicitly. */
    private void removeFarmerAndProducts(int farmerId) {
        List<Product> products = productRepository.findByFarmerId(farmerId);
        if (products != null && !products.isEmpty()) {
            productRepository.deleteAll(products);
        }
        farmerRepository.deleteById(farmerId);
    }

    @Override
    public Farmer findByUsernameAndPhone(String username, String phone) {
        return farmerRepository.findByUsernameAndPhone(username, phone);
    }

    @Override
    public Farmer findByUsername(String username) {
        return farmerRepository.findByUsername(username);
    }

    @Override
    public Farmer findByUsernameAndEmail(String username, String email) {
        if (username == null || email == null) {
            return null;
        }
        return farmerRepository.findByUsernameAndEmailIgnoreCase(username, email);
    }

    @Override
    public void updateFarmer(Farmer farmer) {
        farmerRepository.save(farmer);
    }

    @Override
    public String addProduct(Product p) {
        try {
            productRepository.save(p);
            return "Product saved successfully!";
        } catch (Exception e) {
            log.error("Add product failed", e);
            return "Could not save the product. Please check the values and try again.";
        }
    }

    @Override
    public boolean verifyPassword(Farmer farmer, String rawPassword) {
        return farmer != null && passwordService.matches(rawPassword, farmer.getPassword());
    }

    @Override
    public String changePassword(String username, String newRawPassword) {
        Farmer farmer = farmerRepository.findByUsername(username);
        if (farmer == null) {
            return "Farmer not found.";
        }
        if (newRawPassword == null || newRawPassword.length() < 6) {
            return "Password must be at least 6 characters.";
        }
        farmer.setPassword(passwordService.encode(newRawPassword));
        farmerRepository.save(farmer);
        return "Password changed successfully. Please log in.";
    }

    @Override
    public String updateFarmer1(Farmer farmer) {
        try {
            farmerRepository.save(farmer);
            return "Profile updated successfully!";
        } catch (Exception e) {
            log.error("Farmer update failed", e);
            return "Update unsuccessful, please try again.";
        }
    }

    @Override
    public List<Product> getProductsByFarmerId(Integer farmerId) {
        List<Product> products = productRepository.findByFarmerId(farmerId);
        return products == null ? Collections.emptyList() : products;
    }

    @Override
    public String deleteProduct(Integer farmerId, int productId) {
        Optional<Product> productOpt = productRepository.findById(productId);
        if (productOpt.isEmpty()) {
            return "Product not found!";
        }
        Product product = productOpt.get();

        // Objects.equals, not ==. The old code compared two Integer objects by
        // reference, which only happens to work for ids up to 127 because of
        // the Integer cache. Past that, farmers could not delete their own
        // products and got "You can only delete your own products!".
        if (Objects.equals(product.getFarmerId(), farmerId)) {
            productRepository.delete(product);
            return "Product deleted successfully!";
        }
        return "You can only delete your own products!";
    }

    @Override
    public int getCount() {
        return farmerRepository.countAll();
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("<", "&lt;").replace(">", "&gt;");
    }
}
