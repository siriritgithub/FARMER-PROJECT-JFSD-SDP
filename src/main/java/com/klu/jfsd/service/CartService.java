package com.klu.jfsd.service;

import com.klu.jfsd.model.CartItem;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.repository.CartItemRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Service
public class CartService {

    /** A cart row paired with its live product, for rendering. */
    public static class CartLine {
        public final CartItem item;
        public final Product product;

        public CartLine(CartItem item, Product product) {
            this.item = item;
            this.product = product;
        }

        public int getQuantity() { return item.getQuantity(); }
        public Product getProduct() { return product; }

        public BigDecimal getLineTotal() {
            return product == null ? BigDecimal.ZERO
                    : product.getPriceValue().multiply(BigDecimal.valueOf(item.getQuantity()));
        }
    }

    private final CartItemRepository cartItemRepository;
    private final ProductService productService;
    private final OrderService orderService;

    public CartService(CartItemRepository cartItemRepository,
                       ProductService productService,
                       OrderService orderService) {
        this.cartItemRepository = cartItemRepository;
        this.productService = productService;
        this.orderService = orderService;
    }

    public void addToCart(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            quantity = 1;
        }
        CartItem existing = cartItemRepository.findByUserIdAndProductId(userId, productId).orElse(null);
        if (existing != null) {
            existing.setQuantity(existing.getQuantity() + quantity);
            cartItemRepository.save(existing);
        } else {
            CartItem item = new CartItem();
            item.setUserId(userId);
            item.setProductId(productId);
            item.setQuantity(quantity);
            cartItemRepository.save(item);
        }
    }

    public void updateQuantity(int userId, int productId, int quantity) {
        if (quantity <= 0) {
            cartItemRepository.deleteByUserIdAndProductId(userId, productId);
            return;
        }
        cartItemRepository.findByUserIdAndProductId(userId, productId).ifPresent(item -> {
            item.setQuantity(quantity);
            cartItemRepository.save(item);
        });
    }

    public void remove(int userId, int productId) {
        cartItemRepository.deleteByUserIdAndProductId(userId, productId);
    }

    public List<CartLine> getCart(int userId) {
        List<CartLine> lines = new ArrayList<>();
        for (CartItem item : cartItemRepository.findByUserIdOrderByAddedAtDesc(userId)) {
            Product product = productService.getProductById(item.getProductId());
            lines.add(new CartLine(item, product));
        }
        return lines;
    }

    public long getCartCount(int userId) {
        return cartItemRepository.countByUserId(userId);
    }

    public BigDecimal getCartTotal(int userId) {
        return getCart(userId).stream()
                .map(CartLine::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    /**
     * Places a real order (via OrderService, same path as "Buy Now") for every
     * item still valid in the cart, then empties the cart of whatever
     * succeeded. Items that fail (out of stock, deleted product, etc.) are
     * left in the cart with their failure reason reported back.
     */
    @Transactional
    public CheckoutResult checkout(int userId) {
        List<CartItem> items = cartItemRepository.findByUserIdOrderByAddedAtDesc(userId);
        List<String> failures = new ArrayList<>();
        int placed = 0;

        for (CartItem item : items) {
            OrderService.OrderResult result =
                    orderService.placeOrder(userId, item.getProductId(), item.getQuantity());
            if (result.isSuccess()) {
                placed++;
                cartItemRepository.deleteByUserIdAndProductId(userId, item.getProductId());
            } else {
                failures.add(result.getMessage());
            }
        }
        return new CheckoutResult(placed, failures);
    }

    public static class CheckoutResult {
        public final int placedCount;
        public final List<String> failures;

        CheckoutResult(int placedCount, List<String> failures) {
            this.placedCount = placedCount;
            this.failures = failures;
        }

        public int getPlacedCount() { return placedCount; }
        public List<String> getFailures() { return failures; }
    }
}
