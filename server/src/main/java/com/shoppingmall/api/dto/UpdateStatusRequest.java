package com.shoppingmall.api.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateStatusRequest(@NotBlank String status) {}
