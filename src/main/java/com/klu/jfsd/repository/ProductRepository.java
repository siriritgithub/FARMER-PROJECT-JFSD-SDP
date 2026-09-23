package com.klu.jfsd.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
@Repository
public interface ProductRepository extends JpaRepository<Product, Integer > {
	
	
	
	//@Query("select p from Product p where p.specification = ?1")
	  List<Product> findByType(String specification);
	  
	  @Query("SELECT COUNT(f) FROM Product f")
	  int countAll();
	  
	  List<Product> findByFarmerId(Integer farmerId);
	 

	List<Product> findBySpecification(String specification);
	
	
	 List<Product> findByRequest(int request);
	  


}
