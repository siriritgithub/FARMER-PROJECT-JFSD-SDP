package com.klu.jfsd.service;

import java.util.List;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;

public interface UserService {

    String userRegistration(User user);

    /** Returns the user if the password verifies, otherwise null. */
    User checkUserLogin(String username, String password);

    List<Farmer> viewAllFarmers();

    List<Product> viewAllProducts();

    List<Product> getProductsBySpecification(String specification);

    List<Product> getProductsByType(String type);

    // ---- approval ----
    List<User> getAllPendingUsers();
    void approveUser(int userId);
    void rejectUser(int userId);

    // ---- lookup ----
    User findByUsernameAndPhone(String username, String phone);
    User findByUsername(String username);
    User findByUsernameAndEmail(String username, String email);

    String updateUser(User user);

    User getUserById(int userId);

    /** Verify a raw password against the stored hash. */
    boolean verifyPassword(User currentUser, String rawPassword);

    /** Hash and store a new password. */
    String changePassword(String username, String newRawPassword);

    void deleteUser(int id, String reason);

    int getCount();
}
