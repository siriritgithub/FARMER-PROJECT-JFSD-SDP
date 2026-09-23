package com.klu.jfsd.repository;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.klu.jfsd.model.User;

public interface UserRepository extends JpaRepository<User, Integer> {

   
	 List<User> findByUserApproval(boolean userApproval); 
	 
	// Find a user by username and phone number
	    User findByUsernameAndPhone(String username, String phone);

	    // Find a user by username
	    User findByUsername(String username);
	    
	    
	    @Query("SELECT COUNT(u) FROM User u")
	    int countAll();
	    
	    
	 
    boolean existsByUsername(String username);

    User findByUsernameAndEmailIgnoreCase(String username, String email);

    // NOTE: the old checkUserLogin(username, password) query compared the
    // password inside SQL. That only works while passwords are plain text.
    // Passwords are now BCrypt-hashed, so the service loads the user by
    // username and verifies the hash in Java instead.
}
