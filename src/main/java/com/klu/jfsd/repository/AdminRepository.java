package com.klu.jfsd.repository;



import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.klu.jfsd.model.Admin;
@Repository
public interface AdminRepository extends JpaRepository<Admin, String>{
	
	Admin findByUsername(String username);
	 
	Admin findByEmail(String email);

	// checkAdminLogin(username, password) removed - password verification now
	// happens in PasswordService against a BCrypt hash.
}
