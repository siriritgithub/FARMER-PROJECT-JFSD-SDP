package com.klu.jfsd.controller;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;

/**
 * Renders 404s and other container-level errors into error.jsp.
 */
@Controller
public class AppErrorController implements ErrorController {

    @RequestMapping("/error")
    public ModelAndView handleError(HttpServletRequest request) {
        Object statusObj = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE);
        int status = statusObj == null ? 500 : Integer.parseInt(statusObj.toString());

        String message;
        switch (status) {
            case 404 -> message = "We could not find that page.";
            case 403 -> message = "You do not have permission to view that page.";
            case 400 -> message = "That request was not valid.";
            default  -> message = "Something went wrong on our side.";
        }

        ModelAndView mv = new ModelAndView("error");
        mv.addObject("status", status);
        mv.addObject("message", message);
        mv.addObject("path", request.getAttribute(RequestDispatcher.ERROR_REQUEST_URI));
        return mv;
    }
}
