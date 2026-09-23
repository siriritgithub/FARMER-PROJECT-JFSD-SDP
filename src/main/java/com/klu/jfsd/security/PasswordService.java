package com.klu.jfsd.security;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

/**
 * Central place for password hashing.
 *
 * The original project stored every password in plain text. Existing rows in
 * your database still contain plain text, so {@link #matches} accepts both:
 *
 *   - if the stored value looks like a BCrypt hash, verify with BCrypt
 *   - otherwise fall back to a plain comparison (legacy row)
 *
 * When a legacy row authenticates successfully the caller should re-save the
 * account with {@link #encode(String)} so it is upgraded in place. That way the
 * database migrates itself as users log in, with no downtime and no data loss.
 */
@Component
public class PasswordService {

    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder(10);

    /** Hash a raw password for storage. */
    public String encode(String rawPassword) {
        if (rawPassword == null) {
            throw new IllegalArgumentException("Password must not be null");
        }
        return encoder.encode(rawPassword);
    }

    /** True if the stored value is already a BCrypt hash. */
    public boolean isHashed(String storedPassword) {
        return storedPassword != null
                && storedPassword.length() == 60
                && (storedPassword.startsWith("$2a$")
                 || storedPassword.startsWith("$2b$")
                 || storedPassword.startsWith("$2y$"));
    }

    /**
     * Verify a submitted password against whatever is in the database,
     * hashed or legacy plain text.
     */
    public boolean matches(String rawPassword, String storedPassword) {
        if (rawPassword == null || storedPassword == null) {
            return false;
        }
        if (isHashed(storedPassword)) {
            return encoder.matches(rawPassword, storedPassword);
        }
        // Legacy plain-text row. Constant-time compare to avoid timing leaks.
        return constantTimeEquals(rawPassword, storedPassword);
    }

    /**
     * True when the stored password is legacy plain text and should be
     * re-hashed by the caller after a successful login.
     */
    public boolean needsUpgrade(String storedPassword) {
        return storedPassword != null && !isHashed(storedPassword);
    }

    private boolean constantTimeEquals(String a, String b) {
        byte[] x = a.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        byte[] y = b.getBytes(java.nio.charset.StandardCharsets.UTF_8);
        int diff = x.length ^ y.length;
        for (int i = 0; i < x.length && i < y.length; i++) {
            diff |= x[i] ^ y[i];
        }
        return diff == 0;
    }
}
