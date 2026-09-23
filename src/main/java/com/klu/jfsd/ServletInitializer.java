package com.klu.jfsd;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Lets the WAR be deployed to a standalone Tomcat / external servlet container.
 * Ignored when the WAR is run directly with `java -jar`.
 */
public class ServletInitializer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(FmsSdPprojectApplication.class);
    }
}
