package com.klu.jfsd.service;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.klu.jfsd.model.Product;
import com.klu.jfsd.repository.ProductRepository;

@Service
public class ProductServiceImplementation implements ProductService {

    private static final Logger log = LoggerFactory.getLogger(ProductServiceImplementation.class);

    private final ProductRepository productRepository;

    public ProductServiceImplementation(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    @Override
    public List<Product> getAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public List<Product> getProductsByType(String type) {
        if (type == null || type.isBlank()) {
            return getAllProducts();
        }
        List<Product> found = productRepository.findByType(type);
        return found == null ? Collections.emptyList() : found;
    }

    /**
     * The old version threw a RuntimeException for a missing id, which turned a
     * stale bookmark or a deleted product into a 500 error page. Returning null
     * lets the controller redirect with a friendly message instead.
     */
    @Override
    public Product getProductById(int productId) {
        Optional<Product> product = productRepository.findById(productId);
        return product.orElse(null);
    }

    @Override
    public List<Product> getProductsByFarmerId(Integer farmerId) {
        List<Product> found = productRepository.findByFarmerId(farmerId);
        return found == null ? Collections.emptyList() : found;
    }

    @Override
    public List<Product> getProductsByRequest(int request) {
        List<Product> found = productRepository.findByRequest(request);
        return found == null ? Collections.emptyList() : found;
    }

    @Override
    public String updateProduct(Product product) {
        try {
            productRepository.save(product);
            return "Product updated successfully.";
        } catch (Exception e) {
            log.error("Product update failed", e);
            return "Something went wrong, please try again.";
        }
    }

    @Override
    public String deleteProduct(int id) {
        if (!productRepository.existsById(id)) {
            return "Product not found!";
        }
        productRepository.deleteById(id);
        return "Product deleted successfully!";
    }

    @Override
    public int getCount() {
        return productRepository.countAll();
    }
}
