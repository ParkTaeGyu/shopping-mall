package com.shoppingmall.api.dto;

public record UserProfileDto(
    String id,
    String email,
    String role,
    String createdAt
) {}
