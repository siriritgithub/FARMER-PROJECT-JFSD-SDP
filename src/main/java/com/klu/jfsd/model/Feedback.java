package com.klu.jfsd.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "feedback_table")
public class Feedback {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)//increment numbers automatically
	@Column(name = "feedback_id" , nullable = false , unique = true)
	private int id;
	@Column(name = "name_of_user", nullable = false)
	private String name;
	@Column(name = "feedback_accessor" , nullable = false , unique = false)
	private String accessor;
	// NOTE: unique=true was a bug - it meant the same person could only ever
	// submit feedback once; the second attempt threw a constraint violation.
	@Column(name = "feedback_email" , nullable = false)
	private String email;
	@Column(name = "feedback_subject" , nullable = false , unique = false)
	private String subject;
	@Column(name = "feedback_message" , nullable = false , unique = false)
	private String message;
	@Column(name = "feedback_status" , nullable = false )
	private boolean status = false;

	@Column(name = "feedback_reply", length = 1000)
	private String reply;

	@Column(name = "created_at")
	private java.time.LocalDateTime createdAt;

	@jakarta.persistence.PrePersist
	void onCreate() {
		if (createdAt == null) {
			createdAt = java.time.LocalDateTime.now();
		}
	}

	public String getReply() {
		return reply;
	}
	public void setReply(String reply) {
		this.reply = reply;
	}
	public java.time.LocalDateTime getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(java.time.LocalDateTime createdAt) {
		this.createdAt = createdAt;
	}
	
	
	
	
	
	public boolean isStatus() {
		return status;
	}
	public void setStatus(boolean status) {
		this.status = status;
	}
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
	public String getAccessor() {
		return accessor;
	}
	public void setAccessor(String accessor) {
		this.accessor = accessor;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	
	
}
