package com.shoppingmall.api.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;

@Configuration
public class OpenApiConfig {
    @Bean
    public OpenAPI openAPI() {
        SecurityScheme bearer = new SecurityScheme()
            .type(SecurityScheme.Type.HTTP)
            .scheme("bearer")
            .bearerFormat("JWT");

        return new OpenAPI()
            .info(new Info()
                .title("미용재료 쇼핑몰 API")
                .description("Spring API (Supabase Auth JWT 검증)")
                .version("v1"))
            .addSecurityItem(new SecurityRequirement().addList("bearerAuth"))
            .schemaRequirement("bearerAuth", bearer);
    }
}
