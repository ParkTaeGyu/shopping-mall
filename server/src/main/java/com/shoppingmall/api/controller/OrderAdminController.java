package com.shoppingmall.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.shoppingmall.api.dto.UpdateStatusRequest;
import com.shoppingmall.api.service.OrderService;

@RestController
@RequestMapping("/api/admin")
public class OrderAdminController {
    private final OrderService orders;

    public OrderAdminController(OrderService orders) {
        this.orders = orders;
    }

    @GetMapping("/orders")
    public List<Map<String, Object>> list(@AuthenticationPrincipal Jwt jwt) {
        return orders.getOrders(jwt.getTokenValue());
    }

    @PutMapping("/orders/{id}/status")
    public ResponseEntity<Void> updateStatus(
        @AuthenticationPrincipal Jwt jwt,
        @PathVariable String id,
        @Validated @RequestBody UpdateStatusRequest request
    ) {
        orders.updateStatus(jwt.getTokenValue(), id, request.status());
        return ResponseEntity.ok().build();
    }
}
