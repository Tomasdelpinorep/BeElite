package com.salesianos.triana.BeElite.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.*;
import lombok.experimental.SuperBuilder;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Getter
@Setter
@RequiredArgsConstructor
@SuperBuilder
public class Athlete extends Usuario {

    private int completed_sessions;

    @OneToMany(mappedBy = "athlete", cascade = CascadeType.ALL, orphanRemoval = true)
    @ToString.Exclude
    private List<Invite> invites;

    @ManyToOne
    private Program program;

    @OneToMany(mappedBy = "athlete", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<AthleteSession> athleteSessions;

    LocalDate joinedProgramDate;

    public Athlete(UUID id, String username, String password, String email, String name, String profilePicUrl,
                   byte[] profilePic, String profilePicFileName, boolean accountNonExpired, boolean accountNonLocked, boolean credentialsNonExpired, boolean enabled,
                   LocalDateTime createdAt, LocalDateTime lastPasswordChangeAt, int completed_sessions, Program program) {
        super(id, username, password, email, name, profilePicUrl, profilePic, profilePicFileName, accountNonExpired, accountNonLocked, credentialsNonExpired,
                enabled, createdAt, lastPasswordChangeAt);
        this.completed_sessions = completed_sessions;
        this.program = program;
    }
}
