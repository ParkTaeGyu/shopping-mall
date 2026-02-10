package com.shoppingmall.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.shoppingmall.api.dto.UpdateRoleRequest;
import com.shoppingmall.api.service.UserService;

@RestController
@RequestMapping("/api/admin")
public class UserAdminController {
    private final UserService users;

    public UserAdminController(UserService users) {
        this.users = users;
    }

    @GetMapping("/users")
    public List<Map<String, Object>> list(@AuthenticationPrincipal Jwt jwt) {
        return users.getProfiles(jwt.getTokenValue());
    }

    @PutMapping("/users/{id}/role")
    public ResponseEntity<Void> updateRole(
        @AuthenticationPrincipal Jwt jwt,
        @PathVariable String id,
        @Validated @RequestBody UpdateRoleRequest request
    ) {
        users.updateRole(jwt.getTokenValue(), id, request.role());
        return ResponseEntity.ok().build();
    }
}
