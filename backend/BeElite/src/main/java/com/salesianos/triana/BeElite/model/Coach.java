package com.salesianos.triana.BeElite.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.OneToMany;
import lombok.*;
import lombok.experimental.SuperBuilder;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Getter
@Setter
@NoArgsConstructor
@SuperBuilder
public class Coach extends Usuario {

    @OneToMany(mappedBy = "coach", cascade = CascadeType.REMOVE)
    private List<Program> programs;

    public Coach(UUID id, String username, String password, String email,
                 String name, String profilePicUrl,boolean accountNonExpired,
                 boolean accountNonLocked, boolean credentialsNonExpired,
                 boolean enabled, LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt,
                 List<Program> programs) {
        super(id, username, password, email, name, profilePicUrl, accountNonExpired, accountNonLocked,
                credentialsNonExpired, enabled, createdAt, lastPasswordChangeAt);
        this.programs = programs;
    }
}
