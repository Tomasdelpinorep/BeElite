package com.salesianos.triana.appbike.model;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Entity
@RequiredArgsConstructor
@NoArgsConstructor
@SuperBuilder
public class Program {

    @Id
    @GeneratedValue(generator = "UUID")
    @UuidGenerator
    @Column(columnDefinition = "uuid")
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "coach_id")
    private Coach coach;

    private List<Session> sessions;

    private String description;

    private String image;

    private List<Athlete> athletes;

    @CreatedDate
    private LocalDate createdAt;
}
