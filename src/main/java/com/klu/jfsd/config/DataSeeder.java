package com.klu.jfsd.config;

import com.klu.jfsd.model.Admin;
import com.klu.jfsd.repository.AdminRepository;
import com.klu.jfsd.security.PasswordService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Creates the first admin account.
 *
 * Without this, admin_table is empty on a fresh database and there is no way in
 * the entire application to create an admin, so admin login could never
 * succeed. Runs once; if any admin already exists it does nothing.
 */
@Component
public class DataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    private final AdminRepository adminRepository;
    private final PasswordService passwordService;

    @Value("${app.admin.username}")
    private String adminUsername;

    @Value("${app.admin.password}")
    private String adminPassword;

    @Value("${app.admin.email}")
    private String adminEmail;

    @Value("${app.admin.name}")
    private String adminName;

    public DataSeeder(AdminRepository adminRepository, PasswordService passwordService) {
        this.adminRepository = adminRepository;
        this.passwordService = passwordService;
    }

    @Override
    public void run(String... args) {
        if (adminRepository.count() > 0) {
            log.info("Admin account already present - skipping seed.");
            return;
        }

        Admin admin = new Admin();
        admin.setUsername(adminUsername);
        admin.setName(adminName);
        admin.setEmail(adminEmail);
        admin.setPassword(passwordService.encode(adminPassword));
        adminRepository.save(admin);

        log.info("=================================================================");
        log.info("  Seeded initial admin account");
        log.info("  username: {}", adminUsername);
        log.info("  Log in at /adminlogin and change this password immediately.");
        log.info("=================================================================");
    }
}
