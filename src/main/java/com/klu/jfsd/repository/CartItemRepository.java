package com.klu.jfsd.repository;

import com.klu.jfsd.model.CartItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartItemRepository extends JpaRepository<CartItem, Integer> {

    List<CartItem> findByUserIdOrderByAddedAtDesc(int userId);

    Optional<CartItem> findByUserIdAndProductId(int userId, int productId);

    void deleteByUserIdAndProductId(int userId, int productId);

    void deleteByUserId(int userId);

    long countByUserId(int userId);
}
