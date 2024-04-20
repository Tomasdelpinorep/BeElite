package com.salesianos.triana.BeElite.dto.User;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.salesianos.triana.BeElite.model.Usuario;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.security.core.GrantedAuthority;

import java.time.LocalDateTime;
import java.util.Collection;

@Data
@NoArgsConstructor
@AllArgsConstructor
@SuperBuilder
public class UserResponse {

    protected String id;
    protected String username, email, name, role, profilePicUrl;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "dd/MM/yyyy HH:mm:ss")
    protected LocalDateTime createdAt;

    public static String getRole(Collection<? extends GrantedAuthority> roleList){
        return roleList.stream().map(GrantedAuthority::getAuthority).toList().get(0);
    }
        public static UserResponse of(Usuario usuario){

        return UserResponse.builder()
                .id(usuario.getId().toString())
                .username(usuario.getUsername())
                .email(usuario.getEmail())
                .name(usuario.getName())
                .profilePicUrl(usuario.getProfilePicUrl())
                .createdAt(usuario.getJoinDate())
                .role(getRole(usuario.getAuthorities()))
                .build();
    }

}
