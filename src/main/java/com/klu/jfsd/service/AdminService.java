package com.klu.jfsd.service;

import java.util.List;

import com.klu.jfsd.model.Admin;
import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;

public interface AdminService {

    /** Returns the admin if the password verifies, otherwise null. */
    Admin checkAdminLogin(String username, String password);

    Admin getAdminByUsername(String username);

    String updateAdminProfile(String username, String currentPassword,
                             String newPassword, String newEmail);

    List<Farmer> viewAllFarmers();
    List<Product> viewAllProducts();
    List<User> viewAllUsers();

    String addFarmer(Farmer farmer);
    String addUser(User user);
    String addProduct(Product product);

    int getFeedbackCount();
}
