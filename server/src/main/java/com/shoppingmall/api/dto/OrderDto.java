package com.shoppingmall.api.dto;

public record OrderDto(
    String id,
    String userId,
    double totalAmount,
    String status,
    String createdAt
) {}
