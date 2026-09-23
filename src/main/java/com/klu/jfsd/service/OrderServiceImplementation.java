package com.klu.jfsd.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.klu.jfsd.model.Order;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.repository.OrderRepository;
import com.klu.jfsd.repository.ProductRepository;

/**
 * Real order handling.
 *
 * Previously the "Buy Now" form posted straight to orderconfirmation.jsp, which
 * simply printed a success page. No order row was ever written and stock was
 * never reduced. Everything below is new behaviour.
 */
@Service
public class OrderServiceImplementation implements OrderService {

    private static final Logger log = LoggerFactory.getLogger(OrderServiceImplementation.class);

    private final OrderRepository orderRepository;
    private final ProductRepository productRepository;

    public OrderServiceImplementation(OrderRepository orderRepository,
                                      ProductRepository productRepository) {
        this.orderRepository = orderRepository;
        this.productRepository = productRepository;
    }

    @Override
    @Transactional
    public OrderResult placeOrder(int userId, int productId, int quantity) {

        if (quantity <= 0) {
            return OrderResult.fail("Please enter a quantity of at least 1.");
        }

        Product product = productRepository.findById(productId).orElse(null);
        if (product == null) {
            return OrderResult.fail("That product is no longer available.");
        }

        int available = product.getQuantityValue();
        if (available <= 0) {
            return OrderResult.fail("Sorry, '" + product.getName() + "' is out of stock.");
        }
        if (quantity > available) {
            return OrderResult.fail("Only " + available + " unit(s) of '"
                    + product.getName() + "' are available.");
        }

        BigDecimal unitPrice = product.getPriceValue();

        Order order = new Order();
        order.setReference(generateReference());
        order.setUserId(userId);
        order.setProductId(product.getId());
        order.setFarmerId(product.getFarmerId());
        order.setProductName(product.getName());
        order.setPrice(unitPrice);
        order.setQuantity(quantity);
        order.setUnit(product.getUnit());
        order.setTotalAmount(unitPrice.multiply(BigDecimal.valueOf(quantity)));
        order.setStatus("CONFIRMED");

        orderRepository.save(order);

        // Reduce stock. quantity is a String column in this schema, so write it back as one.
        product.setQuantity(String.valueOf(available - quantity));
        productRepository.save(product);

        log.info("Order {} placed by user {} for product {} x{}",
                order.getReference(), userId, product.getId(), quantity);

        return OrderResult.ok(order);
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        return orderRepository.findByUserIdOrderByOrderDateDesc(userId);
    }

    @Override
    public List<Order> getOrdersByFarmerId(Integer farmerId) {
        return orderRepository.findByFarmerIdOrderByOrderDateDesc(farmerId);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderRepository.findAllByOrderByOrderDateDesc();
    }

    @Override
    public BigDecimal getTotalRevenue() {
        BigDecimal total = orderRepository.sumTotalRevenue();
        return total == null ? BigDecimal.ZERO : total;
    }

    @Override
    public int getCount() {
        return orderRepository.countAll();
    }

    private String generateReference() {
        return "ORD-" + UUID.randomUUID().toString()
                .substring(0, 8).toUpperCase(Locale.ROOT);
    }
}
