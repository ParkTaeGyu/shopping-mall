package com.shoppingmall.api.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestClient;
import org.springframework.web.util.UriComponentsBuilder;

@Component
public class SupabaseRestClient {
    private final RestClient restClient;

    public SupabaseRestClient(
        @Value("${supabase.url}") String supabaseUrl,
        @Value("${supabase.anon-key}") String anonKey
    ) {
        this.restClient = RestClient.builder()
            .baseUrl(supabaseUrl + "/rest/v1")
            .defaultHeader("apikey", anonKey)
            .defaultHeader(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE)
            .build();
    }

    public <T> List<T> getList(String table, String query, String jwt, ParameterizedTypeReference<List<T>> type) {
        return restClient.get()
            .uri("/" + table + query)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwt)
            .retrieve()
            .body(type);
    }

    public <T> T insert(String table, Object body, String jwt, Class<T> type) {
        return restClient.post()
            .uri("/" + table)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwt)
            .header("Prefer", "return=representation")
            .contentType(MediaType.APPLICATION_JSON)
            .body(body)
            .retrieve()
            .body(type);
    }

    public void patch(String table, String query, Object body, String jwt) {
        restClient.patch()
            .uri("/" + table + query)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwt)
            .contentType(MediaType.APPLICATION_JSON)
            .body(body)
            .retrieve()
            .toBodilessEntity();
    }

    public void delete(String table, String query, String jwt) {
        restClient.delete()
            .uri("/" + table + query)
            .header(HttpHeaders.AUTHORIZATION, "Bearer " + jwt)
            .retrieve()
            .toBodilessEntity();
    }

    public static String query(String... pairs) {
        UriComponentsBuilder builder = UriComponentsBuilder.newInstance();
        for (int i = 0; i + 1 < pairs.length; i += 2) {
            builder.queryParam(pairs[i], pairs[i + 1]);
        }
        return builder.build().toUriString();
    }
}
