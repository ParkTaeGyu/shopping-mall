package com.shoppingmall.api.dto;

import jakarta.validation.constraints.NotBlank;

public record UpdateRoleRequest(@NotBlank String role) {}
