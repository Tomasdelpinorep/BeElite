package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.RequiredArgsConstructor;
import org.hibernate.annotations.UuidGenerator;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Entity
@RequiredArgsConstructor
@Builder
@AllArgsConstructor
public class Program {

    @Id
    @GeneratedValue(generator = "UUID")
    @UuidGenerator
    @Column(columnDefinition = "uuid")
    private UUID id;

    @ManyToOne
    @JoinColumn(name = "coach_id")
    private Coach coach;

    @OneToMany(mappedBy = "program", cascade = CascadeType.ALL)
    private List<Session> sessions;

    private String description;

    private String image;

    @OneToMany(mappedBy = "program")
    private List<Athlete> athletes;

    @CreatedDate
    private LocalDate createdAt;
}
