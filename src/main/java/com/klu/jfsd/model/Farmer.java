package com.klu.jfsd.model;

import jakarta.persistence.*;


@Entity
@Table(name = "farmer_table")
public class Farmer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "farmer_id", nullable = false, unique = true)
    private int id;

    @Column(name = "farmer_name", nullable = false)
    private String name;

    @Column(name = "farmer_phone", nullable = false)
    private String phone;

    @Column(name = "farmer_username", nullable = false, unique = true)
    private String username;
    
    // The old default hardcoded a personal Gmail address, so account-deletion
    // notices for every farmer without an email landed in one private inbox.
    @Column(name = "farmer_email", nullable = true)
    private String email;

    @Column(name = "farmer_password", nullable = false)
    private String password;

    @Column(name = "farmer_address", nullable = false)
    private String address;

    @Column(name = "farmer_state", nullable = false)
    private String state;

    
    @Column(name = "farmer_image", columnDefinition = "TEXT", nullable = false)
    private String image = "https://img.freepik.com/premium-vector/farmer-vector-art_959145-19.jpg";


    @Column(name = "approved", nullable = false)
    private boolean approved = false;
    
    
    

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	
	

	

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public boolean isApproved() {
		return approved;
	}

	public void setApproved(boolean approved) {
		this.approved = approved;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Override
	public String toString() {
		return "Farmer [id=" + id + ", name=" + name + ", phone=" + phone + ", username=" + username + ", email=" + email
				+ ", address=" + address + ", state=" + state + ", approved=" + approved +  "]";
	}
}
