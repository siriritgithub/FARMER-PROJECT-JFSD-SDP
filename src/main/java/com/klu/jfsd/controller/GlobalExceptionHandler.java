package com.klu.jfsd.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Catches anything a controller throws and renders error.jsp instead of a
 * stack trace. The original project had no error view at all, so any unexpected
 * exception showed Tomcat's raw error page to the end user.
 */
@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(SessionExpiredException.class)
    public String handleSessionExpired(SessionExpiredException ex) {
        return "redirect:" + ex.getLoginPath() + "?expired=1";
    }

    /**
     * A missing static file (favicon.ico, a stray browser devtools probe, etc.)
     * is completely normal and not a bug. Without this handler it fell through
     * to handleAnything() below and printed a full stack trace at ERROR level
     * on every page load, which buried real errors in noise.
     */
    @ExceptionHandler(NoResourceFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public void handleMissingStaticResource(NoResourceFoundException ex) {
        // Intentionally silent - this is not an application error.
    }

    @ExceptionHandler(Exception.class)
    public ModelAndView handleAnything(HttpServletRequest request, Exception ex) {
        log.error("Unhandled error at {} {}", request.getMethod(), request.getRequestURI(), ex);

        ModelAndView mv = new ModelAndView("error");
        mv.addObject("status", 500);
        mv.addObject("message", "Something went wrong while processing your request.");
        mv.addObject("path", request.getRequestURI());
        return mv;
    }
}
