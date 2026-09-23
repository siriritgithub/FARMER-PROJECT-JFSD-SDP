package com.klu.jfsd.service;

import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

/**
 * One place for outbound email.
 *
 * The original code called mailSender.send(...) directly inside controllers.
 * That meant a missing recipient address, a wrong SMTP password or a network
 * blip threw an exception out of the request and the admin saw a 500 page,
 * while the actual operation (deleting a farmer) never ran.
 *
 * Here, mail is best-effort: failures are logged and reported as a boolean,
 * never thrown. With app.mail.enabled=false the message is only logged, so the
 * whole application runs without any SMTP credentials at all.
 */
@Service
public class MailService {

    private static final Logger log = LoggerFactory.getLogger(MailService.class);

    private final JavaMailSender mailSender;

    @Value("${app.mail.enabled:false}")
    private boolean enabled;

    @Value("${app.mail.from:no-reply@farmconnect.local}")
    private String from;

    public MailService(JavaMailSender mailSender) {
        this.mailSender = mailSender;
    }

    /**
     * @return true if the message was actually handed to the SMTP server.
     */
    public boolean send(String to, String subject, String htmlBody) {
        if (to == null || to.isBlank()) {
            log.warn("Skipping email '{}' - no recipient address on record.", subject);
            return false;
        }
        if (!enabled) {
            log.info("[MAIL DISABLED] would send to={} subject={}", to, subject);
            return false;
        }
        try {
            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            helper.setTo(to);
            helper.setFrom(from);
            helper.setSubject(subject);
            helper.setText(htmlBody, true);
            mailSender.send(message);
            log.info("Email sent to {} subject={}", to, subject);
            return true;
        } catch (Exception e) {
            log.error("Failed to send email to {} subject={}: {}", to, subject, e.getMessage());
            return false;
        }
    }

    public boolean isEnabled() {
        return enabled;
    }
}
