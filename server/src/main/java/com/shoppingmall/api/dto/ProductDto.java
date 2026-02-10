package com.shoppingmall.api.dto;

public record ProductDto(
    String id,
    String title,
    String description,
    double price,
    String imageUrl,
    String category
) {}
