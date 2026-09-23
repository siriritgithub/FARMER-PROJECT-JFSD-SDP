package com.klu.jfsd.security;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * Guards a group of URLs behind a session attribute.
 *
 * Before this existed, typing /adminviewallusers or /admindeleteusers straight
 * into the address bar worked without logging in at all. Every admin, farmer
 * and user page was publicly reachable.
 */
public class AuthInterceptor implements HandlerInterceptor {

    private final String sessionAttribute;
    private final String loginPath;
    private final String roleLabel;

    public AuthInterceptor(String sessionAttribute, String loginPath, String roleLabel) {
        this.sessionAttribute = sessionAttribute;
        this.loginPath = loginPath;
        this.roleLabel = roleLabel;
    }

    @Override
    public boolean preHandle(HttpServletRequest request,
                             HttpServletResponse response,
                             Object handler) throws Exception {

        HttpSession session = request.getSession(false);
        boolean authenticated = session != null && session.getAttribute(sessionAttribute) != null;

        if (authenticated) {
            // Never let a protected page sit in a browser or proxy cache.
            response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
            response.setHeader("Pragma", "no-cache");
            response.setDateHeader("Expires", 0);
            return true;
        }

        String context = request.getContextPath();
        response.sendRedirect(context + loginPath + "?expired=1&role=" + roleLabel);
        return false;
    }
}
