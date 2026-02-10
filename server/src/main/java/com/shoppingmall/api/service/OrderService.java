package com.shoppingmall.api.service;

import java.util.List;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;

@Service
public class OrderService {
    private final SupabaseRestClient supabase;

    public OrderService(SupabaseRestClient supabase) {
        this.supabase = supabase;
    }

    public List<Map<String, Object>> getOrders(String jwt) {
        String query = SupabaseRestClient.query("select", "*", "order", "created_at.desc");
        return supabase.getList("orders", query, jwt, new ParameterizedTypeReference<>() {});
    }

    public void updateStatus(String jwt, String id, String status) {
        String query = SupabaseRestClient.query("id", "eq." + id);
        supabase.patch("orders", query, Map.of("status", status), jwt);
    }
}
