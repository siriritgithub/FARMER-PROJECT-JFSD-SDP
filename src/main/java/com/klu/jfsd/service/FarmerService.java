package com.klu.jfsd.service;

import java.util.List;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;

public interface FarmerService {

    String farmerRegestration(Farmer farmer);

    /** Returns the farmer if the password verifies, otherwise null. */
    Farmer checkFarmerLogin(String username, String password);

    List<User> viewAllUsers();

    List<Product> viewAllProducts();

    String addProduct(Product product);

    // ---- profile ----
    Farmer getFarmerById(int id);
    void updateFarmer(Farmer farmer);
    void updateFarmerprofile(Farmer farmer);
    String updateFarmer1(Farmer farmer);
    boolean verifyPassword(Farmer farmer, String rawPassword);
    String changePassword(String username, String newRawPassword);

    // ---- approval ----
    List<Farmer> getUnapprovedFarmers();
    void approveFarmer(int farmerId);

    /** Delete without notification (used when rejecting a pending registration). */
    void deleteFarmer(int farmerId);

    /** Delete and email the farmer the reason. Returns a message for the admin UI. */
    String deleteFarmer(int farmerId, String reason);

    // ---- lookup ----
    Farmer findByUsernameAndPhone(String username, String phone);
    Farmer findByUsername(String username);
    Farmer findByUsernameAndEmail(String username, String email);

    // ---- products ----
    List<Product> getProductsByFarmerId(Integer farmerId);
    String deleteProduct(Integer farmerId, int productId);

    int getCount();
}
