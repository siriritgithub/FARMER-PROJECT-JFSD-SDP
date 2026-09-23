package com.klu.jfsd.controller;

/**
 * Thrown when a controller finds no logged-in principal in the session.
 * Handled by GlobalExceptionHandler, which redirects to the right login page.
 */
public class SessionExpiredException extends RuntimeException {

    private final String loginPath;

    public SessionExpiredException(String loginPath) {
        super("Session expired");
        this.loginPath = loginPath;
    }

    public String getLoginPath() {
        return loginPath;
    }
}
