package com.salesianos.triana.appbike.model;

import jakarta.persistence.Entity;
import lombok.*;
import lombok.experimental.SuperBuilder;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
@SuperBuilder
public class Coach extends User {

    private List<Program> programs;

    public Coach(UUID id, String username, String password, String email,
                 String nombre, boolean accountNonExpired,
                 boolean accountNonLocked, boolean credentialsNonExpired,
                 boolean enabled, LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt,
                 List<Program> programs) {
        super(id, username, password, email, nombre, accountNonExpired, accountNonLocked,
                credentialsNonExpired, enabled, createdAt, lastPasswordChangeAt);
        this.programs = programs;
    }
}
