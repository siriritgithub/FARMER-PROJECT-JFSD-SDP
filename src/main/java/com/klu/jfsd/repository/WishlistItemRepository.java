package com.klu.jfsd.repository;

import com.klu.jfsd.model.WishlistItem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistItemRepository extends JpaRepository<WishlistItem, Integer> {

    List<WishlistItem> findByUserIdOrderByAddedAtDesc(int userId);

    Optional<WishlistItem> findByUserIdAndProductId(int userId, int productId);

    boolean existsByUserIdAndProductId(int userId, int productId);

    void deleteByUserIdAndProductId(int userId, int productId);
}
