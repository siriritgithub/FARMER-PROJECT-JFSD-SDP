package com.klu.jfsd.service;

import java.util.List;

import com.klu.jfsd.model.Product;

public interface ProductService {

    List<Product> getAllProducts();

    List<Product> getProductsByType(String type);

    /** Returns null when the id does not exist, instead of throwing. */
    Product getProductById(int productId);

    List<Product> getProductsByFarmerId(Integer farmerId);

    List<Product> getProductsByRequest(int request);

    String updateProduct(Product product);

    String deleteProduct(int productId);

    int getCount();
}
