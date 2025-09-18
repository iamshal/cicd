package com.example.cicddemo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {
    
    @GetMapping("/")
    public String hello() {
        return "Hello from CI/CD Demo!";
    }
    
    @GetMapping("/health")
    public String health() {
        return "OK";
    }
}
