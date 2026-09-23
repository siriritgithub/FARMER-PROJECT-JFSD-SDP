package com.klu.jfsd.service;

import java.math.BigDecimal;
import java.util.List;

import com.klu.jfsd.model.Order;

public interface OrderService {

    /** Result of an order attempt, so the controller can show a real message. */
    class OrderResult {
        public final boolean success;
        public final String message;
        public final Order order;

        private OrderResult(boolean success, String message, Order order) {
            this.success = success;
            this.message = message;
            this.order = order;
        }

        public static OrderResult ok(Order order) {
            return new OrderResult(true, "Order placed successfully.", order);
        }

        public static OrderResult fail(String message) {
            return new OrderResult(false, message, null);
        }

        public boolean isSuccess() { return success; }
        public String getMessage() { return message; }
        public Order getOrder() { return order; }
    }

    /** Validates stock, saves the order and decrements the product quantity. */
    OrderResult placeOrder(int userId, int productId, int quantity);

    List<Order> getOrdersByUserId(int userId);

    List<Order> getOrdersByFarmerId(Integer farmerId);

    List<Order> getAllOrders();

    BigDecimal getTotalRevenue();

    int getCount();
}
