package com.shoppingmall.api.controller;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import com.shoppingmall.api.dto.ProductDto;
import com.shoppingmall.api.service.ProductService;

@RestController
@RequestMapping("/api")
public class ProductController {
    private final ProductService products;

    public ProductController(ProductService products) {
        this.products = products;
    }

    @GetMapping("/products")
    public List<Map<String, Object>> list(
        @AuthenticationPrincipal Jwt jwt,
        @RequestParam(required = false) String category
    ) {
        return products.getProducts(jwt.getTokenValue(), category);
    }

    @GetMapping("/products/{id}")
    public ResponseEntity<Map<String, Object>> get(
        @AuthenticationPrincipal Jwt jwt,
        @PathVariable String id
    ) {
        Map<String, Object> product = products.getProduct(jwt.getTokenValue(), id);
        if (product == null) return ResponseEntity.notFound().build();
        return ResponseEntity.ok(product);
    }

    @PostMapping("/admin/products")
    public ResponseEntity<Void> add(
        @AuthenticationPrincipal Jwt jwt,
        @Validated @RequestBody ProductDto dto
    ) {
        products.addProduct(jwt.getTokenValue(), dto);
        return ResponseEntity.ok().build();
    }

    @PutMapping("/admin/products/{id}")
    public ResponseEntity<Void> update(
        @AuthenticationPrincipal Jwt jwt,
        @PathVariable String id,
        @Validated @RequestBody ProductDto dto
    ) {
        products.updateProduct(jwt.getTokenValue(), id, dto);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("/admin/products/{id}")
    public ResponseEntity<Void> delete(
        @AuthenticationPrincipal Jwt jwt,
        @PathVariable String id
    ) {
        products.deleteProduct(jwt.getTokenValue(), id);
        return ResponseEntity.ok().build();
    }
}
