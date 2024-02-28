package com.salesianos.triana.BeElite.security.jwt;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.salesianos.triana.BeElite.dto.User.UserResponse;
import com.salesianos.triana.BeElite.model.Usuario;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class JwtUserResponse extends UserResponse {

    private String token;
    private String refreshToken;

    public JwtUserResponse(UserResponse userResponse) {
        id = userResponse.getId();
        username = userResponse.getUsername();
        profilePicUrl = userResponse.getProfilePicUrl();
        name = userResponse.getName();
        email = userResponse.getEmail();
        createdAt = userResponse.getCreatedAt();
        role = userResponse.getRole();
    }

    public static JwtUserResponse of (Usuario usuario, String token) {
        JwtUserResponse result = new JwtUserResponse(UserResponse.of(usuario));
        result.setToken(token);
        return result;

    }

}
