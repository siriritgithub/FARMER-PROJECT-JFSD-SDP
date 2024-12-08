package com.klu.jfsd.service;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.klu.jfsd.model.Farmer;
import com.klu.jfsd.model.Product;
import com.klu.jfsd.model.User;
import com.klu.jfsd.repository.FarmerRepository;
import com.klu.jfsd.repository.ProductRepository;
import com.klu.jfsd.repository.UserRepository;

@Service
public class FarmerServiceImplementation implements FarmerService {

    private static final String UPLOAD_DIR = "uploads/";

    @Autowired
    private FarmerRepository farmerRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ProductRepository productRepository;
    
    @Autowired
    private JavaMailSender javaMailSender;

    @Override
    public String farmerRegestration(Farmer f) {
        try {
            farmerRepository.save(f);
            return "Farmer registered successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            return "Registration failed. Please try again.";
        }
    }

    @Override
    public Farmer checkFarmerLogin(String username, String password) {
        Farmer f = farmerRepository.checkCustomerLogin(username, password);
        if (f != null) {
            return f;
        }
        return null;
    }

    @Override
    public List<User> viewAllUsers() {
        return userRepository.findAll();
    }

    @Override
    public List<Product> viewAllProducts() {
        return productRepository.findAll();
    }

    @Override
    public Farmer getFarmerById(int id) {
        return farmerRepository.findById(id).orElse(null);
    }

    @Override
    public void updateFarmerprofile(Farmer farmer) {
        Farmer existingFarmer = farmerRepository.findById(farmer.getId()).orElse(null);
        if (existingFarmer != null) {
            existingFarmer.setName(farmer.getName());
            existingFarmer.setUsername(farmer.getUsername());
            existingFarmer.setPhone(farmer.getPhone());
            existingFarmer.setAddress(farmer.getAddress());
            existingFarmer.setState(farmer.getState());
            if (farmer.getImage() != null) {
                existingFarmer.setImage(farmer.getImage());
            }
            
            farmerRepository.save(existingFarmer);
        }
    }
    
   
    

    @Override
    public List<Farmer> getUnapprovedFarmers() {
        return farmerRepository.findByApprovedFalse();
    }

    @Override
    public void approveFarmer(int farmerId) {
        Farmer farmer = farmerRepository.findById(farmerId).orElse(null);
        if (farmer != null) {
            farmer.setApproved(true);
            farmerRepository.save(farmer);
        }
    }

    @Override
    public void deleteFarmer(int farmerId) {
        farmerRepository.deleteById(farmerId);
    }

    @Override
    public Farmer findByUsernameAndPhone(String username, String phone) {
        return farmerRepository.findByUsernameAndPhone(username, phone);
    }

    @Override
    public Farmer findByUsername(String username) {
        return farmerRepository.findByUsername(username);
    }

    @Override
    public void updateFarmer(Farmer farmer) {
        farmerRepository.save(farmer);
    }

    @Override
    public String addProduct(Product p) {
        productRepository.save(p);
        return "Product added successfully!";
    }

    @Override
    public boolean verifyPassword(Farmer loggedFarmer, String password) {
        return password.equals(loggedFarmer.getPassword());
    }

    @Override
    public String updateFarmer1(Farmer loggedFarmer) {
        try {
            farmerRepository.save(loggedFarmer);
            return "Update done successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            return "Update unsuccessful, try again.";
        }
    }

    @Override
    public List<Product> getProductsByFarmerId(Integer farmerId) {
        return productRepository.findByFarmerId(farmerId);
    }

    public String deleteProduct(Integer farmerId, int productId) {
        Optional<Product> productOpt = productRepository.findById(productId);
        if (!productOpt.isPresent()) {
            return "Product not found!";
        }

        Product product = productOpt.get();

        if (product.getFarmerId() == farmerId) {
            productRepository.delete(product);
            return "Product deleted successfully!";
        } else {
            return "You can only delete your own products!";
        }
    }

    @Override
    public void deleteFarmer(String mail, int id, String reason) {
        Farmer farmer = getFarmerById(id);
        if (farmer != null) {
            String subject = "Account Deletion Notice";
            String body = "Dear " + farmer.getName() + ",\n\nYour account has been deleted for the following reason:\n" + reason + "\n\nRegards,\nAdmin Team";
           SimpleMailMessage message = new SimpleMailMessage();
           
           message.setFrom("deepak.yaramala@gmail.com");
           message.setTo(mail);
           message.setSubject(subject);
           message.setText(reason);
           //javaMailSender.send(message);
           
            farmerRepository.deleteById(id);
        }
    }
    
    
    
    
    
    
    
    
    
    @Override
    public int getCount() {
        return farmerRepository.countAll();
    }

	@Override
	public void deleteFarmer(int id, String reason) {
		// TODO Auto-generated method stub
		
	}
}
