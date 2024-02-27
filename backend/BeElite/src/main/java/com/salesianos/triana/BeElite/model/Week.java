package com.salesianos.triana.BeElite.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Entity
@RequiredArgsConstructor
@AllArgsConstructor
@Builder
@IdClass(WeekId.class)
public class Week {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Id
    private String week_name;

    private String instructions;

    @OneToMany(mappedBy = "week")
    private List<Session> sessions;

    @ManyToOne
    @JoinColumn(name = "program_id")
    private Program program;
}
