package com.shoppingmall.api.service;

import java.util.List;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;

@Service
public class UserService {
    private final SupabaseRestClient supabase;

    public UserService(SupabaseRestClient supabase) {
        this.supabase = supabase;
    }

    public List<Map<String, Object>> getProfiles(String jwt) {
        String query = SupabaseRestClient.query("select", "*", "order", "created_at.desc");
        return supabase.getList("profiles", query, jwt, new ParameterizedTypeReference<>() {});
    }

    public void updateRole(String jwt, String id, String role) {
        String query = SupabaseRestClient.query("id", "eq." + id);
        supabase.patch("profiles", query, Map.of("role", role), jwt);
    }
}
