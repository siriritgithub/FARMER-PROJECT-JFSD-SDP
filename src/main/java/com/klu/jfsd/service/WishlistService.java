package com.klu.jfsd.service;

import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.WishlistItem;
import com.klu.jfsd.repository.WishlistItemRepository;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class WishlistService {

    public static class WishlistLine {
        public final WishlistItem item;
        public final Product product;

        public WishlistLine(WishlistItem item, Product product) {
            this.item = item;
            this.product = product;
        }

        public Product getProduct() { return product; }
    }

    private final WishlistItemRepository wishlistItemRepository;
    private final ProductService productService;

    public WishlistService(WishlistItemRepository wishlistItemRepository,
                           ProductService productService) {
        this.wishlistItemRepository = wishlistItemRepository;
        this.productService = productService;
    }

    public void add(int userId, int productId) {
        if (!wishlistItemRepository.existsByUserIdAndProductId(userId, productId)) {
            WishlistItem item = new WishlistItem();
            item.setUserId(userId);
            item.setProductId(productId);
            wishlistItemRepository.save(item);
        }
    }

    public void remove(int userId, int productId) {
        wishlistItemRepository.deleteByUserIdAndProductId(userId, productId);
    }

    public boolean contains(int userId, int productId) {
        return wishlistItemRepository.existsByUserIdAndProductId(userId, productId);
    }

    public List<WishlistLine> getWishlist(int userId) {
        List<WishlistLine> lines = new ArrayList<>();
        for (WishlistItem item : wishlistItemRepository.findByUserIdOrderByAddedAtDesc(userId)) {
            Product product = productService.getProductById(item.getProductId());
            lines.add(new WishlistLine(item, product));
        }
        return lines;
    }
}
