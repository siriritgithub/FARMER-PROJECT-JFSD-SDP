package com.klu.jfsd.service;

import com.klu.jfsd.model.Feedback;
import com.klu.jfsd.repository.FeedbackRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class FeedbackService {

    private static final Logger log = LoggerFactory.getLogger(FeedbackService.class);

    private final FeedbackRepository feedbackRepository;
    private final MailService mailService;

    public FeedbackService(FeedbackRepository feedbackRepository, MailService mailService) {
        this.feedbackRepository = feedbackRepository;
        this.mailService = mailService;
    }

    public String saveFeedback(Feedback feedback) {
        try {
            feedback.setStatus(false);
            feedbackRepository.save(feedback);
            return "Thanks! Your message has been sent to our team.";
        } catch (Exception e) {
            log.error("Saving feedback failed", e);
            return "Sorry, we could not submit your message. Please try again.";
        }
    }

    /** Admin inbox. There was previously no way to read feedback at all. */
    public List<Feedback> getAllFeedback() {
        return feedbackRepository.findAllByOrderByIdDesc();
    }

    public List<Feedback> getPendingFeedback() {
        return feedbackRepository.findByStatusOrderByIdDesc(false);
    }

    public String resolveFeedback(int id, String reply) {
        Feedback feedback = feedbackRepository.findById(id).orElse(null);
        if (feedback == null) {
            return "Feedback not found.";
        }
        feedback.setStatus(true);
        feedback.setReply(reply);
        feedbackRepository.save(feedback);

        if (reply != null && !reply.isBlank()) {
            mailService.send(feedback.getEmail(),
                    "Re: " + feedback.getSubject(),
                    "<p>Hello " + escape(feedback.getName()) + ",</p>"
                  + "<p>Regarding your message:</p>"
                  + "<blockquote>" + escape(feedback.getMessage()) + "</blockquote>"
                  + "<p>" + escape(reply) + "</p>"
                  + "<p>Regards,<br/>FarmConnect Support</p>");
        }
        return "Feedback marked as resolved.";
    }

    public int getCount() {
        return feedbackRepository.countAll();
    }

    public int getPendingCount() {
        return feedbackRepository.countPending();
    }

    private String escape(String value) {
        return value == null ? "" : value.replace("<", "&lt;").replace(">", "&gt;");
    }
}
