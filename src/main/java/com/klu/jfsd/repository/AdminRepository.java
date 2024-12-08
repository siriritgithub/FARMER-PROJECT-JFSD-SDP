package com.klu.jfsd.repository;



import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.klu.jfsd.model.Admin;
@Repository
public interface AdminRepository extends JpaRepository<Admin, String>{
	
	Admin findByUsername(String username);
	 
	@Query("select a from Admin a where a.username = ?1 and a.password = ?2")
	public Admin checkAdminLogin(String username, String password );
}
