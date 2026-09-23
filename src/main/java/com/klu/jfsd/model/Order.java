package com.klu.jfsd.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "orders")
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    /** Human-friendly reference shown to the customer, e.g. ORD-4F2A9C. */
    @Column(name = "order_reference", length = 32)
    private String reference;

    @Column(name = "product_id", nullable = false)
    private int productId;

    @Column(name = "user_id", nullable = false)
    private int userId;

    /** Which farmer the order belongs to, so a farmer can see their sales. */
    @Column(name = "farmer_id")
    private Integer farmerId;

    @Column(name = "product_name", length = 100)
    private String productName;

    /** Unit price at the time of purchase. */
    @Column(name = "price", precision = 10, scale = 2)
    private BigDecimal price;

    @Column(name = "quantity")
    private int quantity;

    @Column(name = "unit", length = 20)
    private String unit = "kg";

    /** price * quantity, stored so old orders are not changed by later price edits. */
    @Column(name = "total_amount", precision = 12, scale = 2)
    private BigDecimal totalAmount;

    @Column(name = "status", length = 20)
    private String status = "CONFIRMED";

    @Column(name = "order_date")
    private LocalDateTime orderDate;

    @PrePersist
    void onCreate() {
        if (orderDate == null) {
            orderDate = LocalDateTime.now();
        }
        if (totalAmount == null && price != null) {
            totalAmount = price.multiply(BigDecimal.valueOf(quantity));
        }
        if (status == null) {
            status = "CONFIRMED";
        }
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getReference() { return reference; }
    public void setReference(String reference) { this.reference = reference; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Integer getFarmerId() { return farmerId; }
    public void setFarmerId(Integer farmerId) { this.farmerId = farmerId; }

    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getUnit() { return (unit == null || unit.isBlank()) ? "kg" : unit; }
    public void setUnit(String unit) { this.unit = unit; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }

    @Override
    public String toString() {
        return "Order[" + reference + ", product=" + productName
                + ", qty=" + quantity + ", total=" + totalAmount + "]";
    }
}
