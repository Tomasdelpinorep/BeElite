package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.annotation.CreatedDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Entity
@Builder
@RequiredArgsConstructor
@AllArgsConstructor
@Getter
@Setter
public class Invite {

    @Id
    @GeneratedValue(generator = "UUID")
    @UuidGenerator
    @Column(columnDefinition = "uuid")
    private UUID id;

    @CreatedDate
    private LocalDateTime createdAt;

    @ManyToOne
    private Program program;

    @ManyToOne
    private Athlete athlete;

    @Enumerated(EnumType.STRING)
    private InvitationStatus status;
}
