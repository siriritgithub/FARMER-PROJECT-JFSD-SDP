package com.klu.jfsd.service;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.security.SecureRandom;
import java.time.Instant;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Short-lived one-time codes for password reset.
 *
 * The old reset flow asked only for a username and a phone number, both of
 * which are printed on the public "view all farmers" page. Anyone could reset
 * anyone's password. Now a code is mailed to the address on the account and
 * must be entered before a new password is accepted.
 *
 * Codes live in memory: they expire in 10 minutes and allow 5 attempts. That is
 * fine for a single instance. If you ever scale to more than one instance,
 * move this to the database or Redis.
 */
@Service
public class OtpService {

    private static final Logger log = LoggerFactory.getLogger(OtpService.class);

    private static final long TTL_SECONDS = 600;   // 10 minutes
    private static final int MAX_ATTEMPTS = 5;

    private final SecureRandom random = new SecureRandom();
    private final Map<String, Entry> store = new ConcurrentHashMap<>();

    private static final class Entry {
        final String code;
        final Instant expiresAt;
        int attempts;

        Entry(String code, Instant expiresAt) {
            this.code = code;
            this.expiresAt = expiresAt;
        }
    }

    /** Generate and store a 6-digit code for the given key (e.g. "farmer:ravi"). */
    public String issue(String key) {
        purgeExpired();
        String code = String.format("%06d", random.nextInt(1_000_000));
        store.put(key, new Entry(code, Instant.now().plusSeconds(TTL_SECONDS)));
        log.info("Issued reset code for key={} (expires in {} minutes)", key, TTL_SECONDS / 60);
        return code;
    }

    /** Verify and consume a code. Returns false for wrong, expired or exhausted codes. */
    public boolean verify(String key, String submittedCode) {
        Entry entry = store.get(key);
        if (entry == null) {
            return false;
        }
        if (Instant.now().isAfter(entry.expiresAt)) {
            store.remove(key);
            return false;
        }
        if (++entry.attempts > MAX_ATTEMPTS) {
            store.remove(key);
            log.warn("Too many reset attempts for key={} - code invalidated", key);
            return false;
        }
        if (entry.code.equals(submittedCode)) {
            store.remove(key);   // single use
            return true;
        }
        return false;
    }

    public void invalidate(String key) {
        store.remove(key);
    }

    private void purgeExpired() {
        Instant now = Instant.now();
        store.entrySet().removeIf(e -> now.isAfter(e.getValue().expiresAt));
    }
}
