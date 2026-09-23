package com.klu.jfsd.repository;

import com.klu.jfsd.model.Order;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {

    List<Order> findByUserIdOrderByOrderDateDesc(int userId);

    List<Order> findByFarmerIdOrderByOrderDateDesc(Integer farmerId);

    List<Order> findAllByOrderByOrderDateDesc();

    /**
     * Total revenue across all orders. The admin dashboard used to hardcode
     * income = 0 with a comment saying it was "assumed" to come from orders.
     * COALESCE keeps it at 0 instead of null when there are no orders yet.
     */
    @Query("SELECT COALESCE(SUM(o.totalAmount), 0) FROM Order o WHERE o.status <> 'CANCELLED'")
    BigDecimal sumTotalRevenue();

    @Query("SELECT COUNT(o) FROM Order o")
    int countAll();
}
