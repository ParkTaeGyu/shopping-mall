package com.shoppingmall.api.config;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Map;

import org.springframework.core.convert.converter.Converter;
import org.springframework.security.authentication.AbstractAuthenticationToken;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;

public class JwtAuthConverter implements Converter<Jwt, AbstractAuthenticationToken> {
    @Override
    public AbstractAuthenticationToken convert(Jwt jwt) {
        JwtGrantedAuthoritiesConverter defaultConverter = new JwtGrantedAuthoritiesConverter();
        Collection<GrantedAuthority> authorities = defaultConverter.convert(jwt);
        if (authorities == null) {
            authorities = new ArrayList<>();
        } else {
            authorities = new ArrayList<>(authorities);
        }

        String role = null;
        Object userMetadata = jwt.getClaims().get("user_metadata");
        if (userMetadata instanceof Map<?, ?> meta) {
            Object roleObj = meta.get("role");
            if (roleObj != null) {
                role = roleObj.toString();
            }
        }

        if ("admin".equalsIgnoreCase(role)) {
            authorities.add(new SimpleGrantedAuthority("ROLE_ADMIN"));
        }

        return new JwtAuthenticationToken(jwt, authorities);
    }
}
