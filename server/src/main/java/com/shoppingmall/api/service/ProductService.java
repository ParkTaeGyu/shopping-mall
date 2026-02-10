package com.shoppingmall.api.service;

import java.util.List;
import java.util.Map;

import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;

import com.shoppingmall.api.dto.ProductDto;

@Service
public class ProductService {
    private final SupabaseRestClient supabase;

    public ProductService(SupabaseRestClient supabase) {
        this.supabase = supabase;
    }

    public List<Map<String, Object>> getProducts(String jwt, String category) {
        String query = category == null || category.isBlank()
            ? SupabaseRestClient.query("select", "*")
            : SupabaseRestClient.query("select", "*", "category", "eq." + category);
        return supabase.getList("products", query, jwt, new ParameterizedTypeReference<>() {});
    }

    public Map<String, Object> getProduct(String jwt, String id) {
        String query = SupabaseRestClient.query("select", "*", "id", "eq." + id);
        List<Map<String, Object>> list = supabase.getList("products", query, jwt, new ParameterizedTypeReference<>() {});
        return list.isEmpty() ? null : list.get(0);
    }

    public void addProduct(String jwt, ProductDto dto) {
        supabase.insert("products", Map.of(
            "title", dto.title(),
            "description", dto.description(),
            "price", dto.price(),
            "image_url", dto.imageUrl(),
            "category", dto.category()
        ), jwt, Object.class);
    }

    public void updateProduct(String jwt, String id, ProductDto dto) {
        String query = SupabaseRestClient.query("id", "eq." + id);
        supabase.patch("products", query, Map.of(
            "title", dto.title(),
            "description", dto.description(),
            "price", dto.price(),
            "image_url", dto.imageUrl(),
            "category", dto.category()
        ), jwt);
    }

    public void deleteProduct(String jwt, String id) {
        String query = SupabaseRestClient.query("id", "eq." + id);
        supabase.delete("products", query, jwt);
    }
}
