package com.klu.jfsd.repository;

import com.klu.jfsd.model.Feedback;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Integer> {

    @Query("SELECT COUNT(f) FROM Feedback f")
    int countAll();

    @Query("SELECT COUNT(f) FROM Feedback f WHERE f.status = false")
    int countPending();

    List<Feedback> findAllByOrderByIdDesc();

    List<Feedback> findByStatusOrderByIdDesc(boolean status);
}
