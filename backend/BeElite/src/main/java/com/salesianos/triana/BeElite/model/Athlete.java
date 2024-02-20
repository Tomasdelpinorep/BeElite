package com.salesianos.triana.BeElite.model;

import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import lombok.*;

import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Getter
@Setter
@ToString
@NoArgsConstructor
public class Athlete extends Usuario {

    private int completed_sessions;

    @ManyToOne
    private Program program;

    public Athlete(UUID id, String username, String password, String email, String name,
                   boolean accountNonExpired, boolean accountNonLocked, boolean credentialsNonExpired, boolean enabled,
                   LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt, int completed_sessions, Program program) {
        super(id, username, password, email, name, accountNonExpired, accountNonLocked, credentialsNonExpired,
                enabled, createdAt, lastPasswordChangeAt);
        this.completed_sessions = completed_sessions;
        this.program = program;
    }
}
