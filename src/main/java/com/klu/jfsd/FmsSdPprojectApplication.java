package com.klu.jfsd;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * FarmConnect - Farmer Management System.
 *
 * The redundant @ComponentScan("com.klu.jfsd") was removed: @SpringBootApplication
 * already scans the package this class lives in and everything below it.
 */
@SpringBootApplication
public class FmsSdPprojectApplication {

    public static void main(String[] args) {
        SpringApplication.run(FmsSdPprojectApplication.class, args);
    }
}
