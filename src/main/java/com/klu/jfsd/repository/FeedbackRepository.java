package com.klu.jfsd.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.klu.jfsd.model.Feedback;

@Repository
public interface FeedbackRepository extends JpaRepository<Feedback, Integer>{
	
	@Query("SELECT COUNT(f) FROM Feedback f")
	int countAll();

}
