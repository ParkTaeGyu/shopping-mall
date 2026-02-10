package com.shoppingmall.api.controller;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.shoppingmall.api.dto.AuthRequest;
import com.shoppingmall.api.service.SupabaseAuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    private final SupabaseAuthService auth;

    public AuthController(SupabaseAuthService auth) {
        this.auth = auth;
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, Object>> login(@Validated @RequestBody AuthRequest request) {
        return ResponseEntity.ok(auth.login(request.email(), request.password()));
    }

    @PostMapping("/signup")
    public ResponseEntity<Map<String, Object>> signup(@Validated @RequestBody AuthRequest request) {
        return ResponseEntity.ok(auth.signUp(request.email(), request.password()));
    }
}
