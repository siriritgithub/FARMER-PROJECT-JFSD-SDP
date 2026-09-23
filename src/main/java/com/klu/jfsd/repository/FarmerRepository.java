package com.klu.jfsd.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import com.klu.jfsd.model.Farmer;

@Repository
public interface FarmerRepository extends JpaRepository<Farmer, Integer> {
 
    List<Farmer> findByApprovedFalse();
	   
    Farmer findByUsernameAndPhone(String username, String phone);
    Farmer findByUsername(String username);
  
    
    
    
    @Query("SELECT COUNT(f) FROM Farmer f")
    int countAll();
    
    
    
    boolean existsByUsername(String username);

    Farmer findByUsernameAndEmailIgnoreCase(String username, String email);

    // checkCustomerLogin(username, password) was removed for the same reason
    // as the user one: password comparison has moved out of SQL and into
    // PasswordService so that BCrypt hashes can be verified.
}
