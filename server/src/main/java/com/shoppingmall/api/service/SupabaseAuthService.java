package com.shoppingmall.api.service;

import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

@Service
public class SupabaseAuthService {
    private final RestClient restClient;
    private final String anonKey;

    public SupabaseAuthService(
        @Value("${supabase.url}") String supabaseUrl,
        @Value("${supabase.anon-key}") String anonKey
    ) {
        this.anonKey = anonKey;
        this.restClient = RestClient.builder()
            .baseUrl(supabaseUrl + "/auth/v1")
            .defaultHeader("apikey", anonKey)
            .defaultHeader(HttpHeaders.AUTHORIZATION, "Bearer " + anonKey)
            .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
            .build();
    }

    public Map<String, Object> login(String email, String password) {
        return restClient.post()
            .uri("/token?grant_type=password")
            .contentType(MediaType.APPLICATION_JSON)
            .body(Map.of("email", email, "password", password))
            .retrieve()
            .body(Map.class);
    }

    public Map<String, Object> signUp(String email, String password) {
        return restClient.post()
            .uri("/signup")
            .contentType(MediaType.APPLICATION_JSON)
            .body(Map.of("email", email, "password", password))
            .retrieve()
            .body(Map.class);
    }
}
